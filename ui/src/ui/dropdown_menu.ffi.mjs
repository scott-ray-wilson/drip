const TRIGGER = "[data-dropdown-menu-trigger]";
const CONTENT = '[data-slot="dropdown-menu-content"]';
const ITEM =
  '[role="menuitem"], [role="menuitemcheckbox"], [role="menuitemradio"]';
const GAP = 4;

let installed = false;

// Caches the user's preferred side/align so we can re-run collision
// resolution from the original intent on every place(), even after we've
// written a flipped value back to data-side. We detect external changes
// (re-render with a different side, programmatic edit) by comparing the
// current dataset to what we last wrote: if they match, the user hasn't
// touched it and the cached preference still applies; if they differ, the
// preference is reset from the dataset.
const preferences = new WeakMap();

const OPPOSITE_SIDE = {
  top: "bottom",
  bottom: "top",
  left: "right",
  right: "left",
};

function getContent(trigger) {
  const id = trigger.getAttribute("aria-controls");
  if (!id) return null;
  const el = document.getElementById(id);
  return el && el.matches(CONTENT) ? el : null;
}

function getTrigger(content) {
  const id = content.id;
  if (!id) return null;
  return document.querySelector(
    `${TRIGGER}[aria-controls="${CSS.escape(id)}"]`,
  );
}

function readPxAttr(el, name, fallback) {
  const parsed = parseInt(el.dataset[name], 10);
  return Number.isFinite(parsed) ? parsed : fallback;
}

function readBoolAttr(el, name, fallback) {
  const v = el.dataset[name];
  if (v === undefined || v === null || v === "") return fallback;
  return v !== "false";
}

function getPreferences(content) {
  const cached = preferences.get(content);
  const currentSide = content.dataset.side || "bottom";
  const currentAlign = content.dataset.align || "start";
  if (
    cached &&
    cached.writtenSide === currentSide &&
    cached.writtenAlign === currentAlign
  ) {
    return { side: cached.side, align: cached.align };
  }
  preferences.set(content, {
    side: currentSide,
    align: currentAlign,
    writtenSide: currentSide,
    writtenAlign: currentAlign,
  });
  return { side: currentSide, align: currentAlign };
}

function setResolved(content, side, align) {
  const cached = preferences.get(content);
  if (cached) {
    cached.writtenSide = side;
    cached.writtenAlign = align;
  }
  if (content.dataset.side !== side) content.dataset.side = side;
  if (content.dataset.align !== align) content.dataset.align = align;
}

// Aligns content along the cross axis of the chosen side. `start` pins the
// content's leading edge to the trigger's leading edge (plus alignOffset);
// `end` pins the trailing edges; `center` ignores alignOffset.
function alignCross(triggerStart, triggerEnd, contentSize, align, alignOffset) {
  switch (align) {
    case "start":
      return triggerStart + alignOffset;
    case "end":
      return triggerEnd - contentSize - alignOffset;
    case "center":
    default:
      return triggerStart + (triggerEnd - triggerStart) / 2 - contentSize / 2;
  }
}

// Computes the unclamped {top,left} for a given side+align relative to the
// trigger rect. The result is the placement before any collision resolution.
function computePosition(t, cw, ch, side, align, sideOffset, alignOffset) {
  switch (side) {
    case "top":
      return {
        top: t.top - ch - sideOffset,
        left: alignCross(t.left, t.right, cw, align, alignOffset),
      };
    case "left":
      return {
        top: alignCross(t.top, t.bottom, ch, align, alignOffset),
        left: t.left - cw - sideOffset,
      };
    case "right":
      return {
        top: alignCross(t.top, t.bottom, ch, align, alignOffset),
        left: t.right + sideOffset,
      };
    case "bottom":
    default:
      return {
        top: t.bottom + sideOffset,
        left: alignCross(t.left, t.right, cw, align, alignOffset),
      };
  }
}

function viewportBoundary() {
  return {
    top: 0,
    left: 0,
    right: window.innerWidth,
    bottom: window.innerHeight,
  };
}

// How far the rect overflows the boundary along the main axis of `side`
// (positive = overflowing). The cross axis isn't measured here; the shift
// step clamps the cross axis directly so it doesn't influence the flip
// decision. `padding` is a per-side object so a sticky header can pad just
// the top edge without inflating the other three.
function mainAxisOverflow(top, left, cw, ch, boundary, padding, side) {
  switch (side) {
    case "top":
      return boundary.top + padding.top - top;
    case "bottom":
      return top + ch - (boundary.bottom - padding.bottom);
    case "left":
      return boundary.left + padding.left - left;
    case "right":
      return left + cw - (boundary.right - padding.right);
  }
  return 0;
}

// Resolves a per-side collision-padding object. Each edge falls back to the
// uniform `data-collision-padding` (and finally to 0) so callers can set a
// global value and override one or two sides individually.
function readCollisionPadding(content) {
  const base = readPxAttr(content, "collisionPadding", 0);
  return {
    top: readPxAttr(content, "collisionPaddingTop", base),
    right: readPxAttr(content, "collisionPaddingRight", base),
    bottom: readPxAttr(content, "collisionPaddingBottom", base),
    left: readPxAttr(content, "collisionPaddingLeft", base),
  };
}

// Vertical space available to the content on the resolved side: the gap
// between the trigger's anchored edge (plus sideOffset) and the far boundary
// minus its padding. A menu taller than this is capped so it scrolls.
function availableHeight(t, boundary, padding, side, sideOffset) {
  switch (side) {
    case "top":
      return t.top - sideOffset - (boundary.top + padding.top);
    case "bottom":
      return boundary.bottom - padding.bottom - (t.bottom + sideOffset);
    default:
      return boundary.bottom - padding.bottom - (boundary.top + padding.top);
  }
}

// Content uses position: fixed so coords come straight from the trigger's
// viewport-relative bounding rect. Repositioning on scroll/resize keeps it
// pinned to the trigger as the page moves. Content size is read via
// offsetWidth/offsetHeight (layout box) rather than getBoundingClientRect
// (visual box) so we don't measure the closed-state scale-95 transform.
//
// Collision resolution runs when `data-avoid-collisions` is not "false":
// flip to the opposite side if the preferred side overflows worse on the
// main axis, cap the height to the space left on the resolved side so a
// tall menu scrolls, then clamp the cross-axis position into the boundary
// minus padding (shift). The resolved side is written back to `data-side`
// so the CSS `transform-origin` rules animate from the right edge after a
// flip.
function place(trigger, content) {
  // Clear any prior cap so offsetHeight reads the natural height; it's
  // re-applied below once the resolved side is known.
  content.style.maxHeight = "";
  const t = trigger.getBoundingClientRect();
  const cw = content.offsetWidth;
  const ch = content.offsetHeight;
  const { side: preferredSide, align } = getPreferences(content);
  const sideOffset = readPxAttr(content, "sideOffset", GAP);
  const alignOffset = readPxAttr(content, "alignOffset", 0);
  const avoidCollisions = readBoolAttr(content, "avoidCollisions", true);
  const collisionPadding = readCollisionPadding(content);

  let side = preferredSide;
  let { top, left } = computePosition(
    t,
    cw,
    ch,
    side,
    align,
    sideOffset,
    alignOffset,
  );

  if (avoidCollisions) {
    const boundary = viewportBoundary();

    const preferredOverflow = mainAxisOverflow(
      top,
      left,
      cw,
      ch,
      boundary,
      collisionPadding,
      side,
    );
    if (preferredOverflow > 0) {
      const oppositeSide = OPPOSITE_SIDE[side];
      const opposite = computePosition(
        t,
        cw,
        ch,
        oppositeSide,
        align,
        sideOffset,
        alignOffset,
      );
      const oppositeOverflow = mainAxisOverflow(
        opposite.top,
        opposite.left,
        cw,
        ch,
        boundary,
        collisionPadding,
        oppositeSide,
      );
      if (oppositeOverflow < preferredOverflow) {
        side = oppositeSide;
        top = opposite.top;
        left = opposite.left;
      }
    }

    // Cap the height to the space on the resolved side so a menu taller than
    // the viewport scrolls (overflow-y-auto) instead of clipping off-screen,
    // re-anchoring from the clamped height so top/right sides don't gap.
    const avail = Math.max(
      0,
      availableHeight(t, boundary, collisionPadding, side, sideOffset),
    );
    const height = Math.min(ch, avail);
    content.style.maxHeight = `${avail}px`;
    if (height < ch) {
      ({ top, left } = computePosition(
        t,
        cw,
        height,
        side,
        align,
        sideOffset,
        alignOffset,
      ));
    }

    // Each axis clamps independently and only while the trigger is still
    // partially visible along that axis; once it scrolls off, that axis'
    // clamp releases so the menu travels with the trigger instead of
    // staying pinned to the boundary edge after the anchor has gone.
    const horizVisible = t.right > boundary.left && t.left < boundary.right;
    const vertVisible = t.bottom > boundary.top && t.top < boundary.bottom;
    if (horizVisible) {
      const min = boundary.left + collisionPadding.left;
      const max = boundary.right - cw - collisionPadding.right;
      if (max >= min) left = Math.min(max, Math.max(min, left));
    }
    if (vertVisible) {
      const min = boundary.top + collisionPadding.top;
      const max = boundary.bottom - height - collisionPadding.bottom;
      if (max >= min) top = Math.min(max, Math.max(min, top));
    }
  }

  content.style.top = `${top}px`;
  content.style.left = `${left}px`;
  setResolved(content, side, align);
}

// Visible, enabled items in DOM order: the set roving focus moves through.
// Disabled items are skipped so the arrow keys never land on an inert row;
// the three disabled signals mirror what the CSS dims.
function getItems(content) {
  return Array.from(content.querySelectorAll(ITEM)).filter(
    (el) =>
      !el.disabled &&
      !el.hasAttribute("data-disabled") &&
      el.getAttribute("aria-disabled") !== "true",
  );
}

// Moves roving focus to items[index], wrapping past either end so ArrowDown
// off the last item lands on the first (and ArrowUp the reverse). preventScroll
// keeps the page from lurching toward the fixed-position menu on focus.
function focusItem(items, index) {
  if (!items.length) return;
  const i = ((index % items.length) + items.length) % items.length;
  items[i].focus({ preventScroll: true });
}

function isOpen(content) {
  return content.dataset.state === "open";
}

function openMenu(trigger) {
  const content = getContent(trigger);
  if (!content) return;
  closeAll(trigger);
  place(trigger, content);
  content.dataset.state = "open";
  trigger.setAttribute("aria-expanded", "true");

  // Roving focus: menu items stay out of the page tab sequence (tabindex -1)
  // and are reached with the arrow keys instead. Focus the first item on open
  // so keyboard users land inside the menu. Because the CSS rings items with
  // :focus-visible, the ring only shows when the menu was opened from the
  // keyboard, not the pointer.
  const items = getItems(content);
  items.forEach((item) => item.setAttribute("tabindex", "-1"));
  if (items.length) items[0].focus({ preventScroll: true });
}

function closeMenu(trigger) {
  const content = getContent(trigger);
  if (content) {
    // Send focus back to the trigger when it's still inside the menu, so
    // keyboard dismissal (Escape, Tab, selecting an item) lands where the menu
    // was opened. If focus already moved elsewhere (e.g. an outside click
    // that landed on another control), leave it where the user put it.
    if (content.contains(document.activeElement)) {
      trigger.focus({ preventScroll: true });
    }
    content.dataset.state = "closed";
  }
  trigger.setAttribute("aria-expanded", "false");
}

function closeAll(except) {
  document.querySelectorAll(TRIGGER).forEach((trigger) => {
    if (trigger === except) return;
    if (trigger.getAttribute("aria-expanded") === "true") closeMenu(trigger);
  });
}

// The single open menu, if any. Only one is ever open at a time because
// openMenu closes the rest first, so the first expanded trigger wins.
function getOpenMenu() {
  for (const trigger of document.querySelectorAll(TRIGGER)) {
    if (trigger.getAttribute("aria-expanded") !== "true") continue;
    const content = getContent(trigger);
    if (content && isOpen(content)) return { trigger, content };
  }
  return null;
}

// Dismisses an open menu once its trigger has scrolled fully out of the
// viewport. Click-activated menus get no natural dismissal signal as the
// trigger leaves screen (unlike hover-driven tooltips, where `mouseout`
// fires), so we close them here to avoid menus floating against an empty
// page after the anchor disappears.
function triggerOffScreen(trigger) {
  const t = trigger.getBoundingClientRect();
  return (
    t.bottom <= 0 ||
    t.top >= window.innerHeight ||
    t.right <= 0 ||
    t.left >= window.innerWidth
  );
}

let rafQueued = false;
function reposition() {
  if (rafQueued) return;
  rafQueued = true;
  requestAnimationFrame(() => {
    rafQueued = false;
    document.querySelectorAll(TRIGGER).forEach((trigger) => {
      const content = getContent(trigger);
      if (!content || !isOpen(content)) return;
      if (triggerOffScreen(trigger)) closeMenu(trigger);
      else place(trigger, content);
    });
  });
}

export function init() {
  if (installed) return;
  installed = true;

  document.addEventListener("click", (e) => {
    const trigger = e.target.closest(TRIGGER);
    if (trigger) {
      e.preventDefault();
      const content = getContent(trigger);
      if (content && isOpen(content)) closeMenu(trigger);
      else openMenu(trigger);
      return;
    }

    const item = e.target.closest(ITEM);
    if (item) {
      const content = item.closest(CONTENT);
      const itemTrigger = content && getTrigger(content);
      if (itemTrigger) closeMenu(itemTrigger);
      return;
    }

    if (!e.target.closest(CONTENT)) closeAll();
  });

  document.addEventListener("keydown", (e) => {
    const open = getOpenMenu();

    // Escape closes the open menu, but only consume the event when one is
    // actually open; otherwise leave Escape for any surrounding layer
    // (dialog, sheet) that wants to handle it.
    if (e.key === "Escape") {
      if (!open) return;
      e.preventDefault();
      e.stopPropagation();
      closeMenu(open.trigger);
      return;
    }

    if (!open) {
      // Arrow keys on a focused trigger open the menu (Enter/Space already do
      // via the native button). Down focuses the first item, Up the last.
      if (e.key === "ArrowDown" || e.key === "ArrowUp") {
        const trigger = e.target.closest?.(TRIGGER);
        const content = trigger && getContent(trigger);
        if (!content) return;
        e.preventDefault();
        openMenu(trigger);
        if (e.key === "ArrowUp") {
          const items = getItems(content);
          focusItem(items, items.length - 1);
        }
      }
      return;
    }

    const items = getItems(open.content);
    const current = items.indexOf(document.activeElement);

    switch (e.key) {
      case "ArrowDown":
        e.preventDefault();
        focusItem(items, current < 0 ? 0 : current + 1);
        break;
      case "ArrowUp":
        e.preventDefault();
        focusItem(items, current < 0 ? items.length - 1 : current - 1);
        break;
      case "Home":
        e.preventDefault();
        focusItem(items, 0);
        break;
      case "End":
        e.preventDefault();
        focusItem(items, items.length - 1);
        break;
      case "Tab":
        // Tab leaves the menu: close it and let focus continue from the
        // trigger so the page tab order is unaffected by the open menu.
        closeMenu(open.trigger);
        break;
    }
  });

  // Capture-phase scroll catches scrolling of any ancestor, not just window.
  window.addEventListener("scroll", reposition, {
    capture: true,
    passive: true,
  });
  window.addEventListener("resize", reposition);
}
