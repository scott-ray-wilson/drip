// Pixels from the top of the viewport at which a section is considered to
// have become the active one. Sits just past the page's scroll-padding-top
// so the active state flips precisely when a heading reaches the header.
const TRIGGER_Y = 100;

let cleanup = null;
let scheduled = false;

function setup() {
  if (cleanup) {
    cleanup();
    cleanup = null;
  }

  const links = Array.from(document.querySelectorAll("[data-toc-link]"));
  if (links.length === 0) return;

  const linkById = new Map();
  const targets = [];
  for (const link of links) {
    const href = link.getAttribute("href") || "";
    if (!href.startsWith("#")) continue;
    const id = href.slice(1);
    const target = document.getElementById(id);
    if (!target) continue;
    linkById.set(id, link);
    targets.push(target);
  }
  if (targets.length === 0) return;

  // Sort in document order so "topmost-passed" works regardless of TOC order.
  targets.sort((a, b) => {
    const pos = a.compareDocumentPosition(b);
    if (pos & Node.DOCUMENT_POSITION_FOLLOWING) return -1;
    if (pos & Node.DOCUMENT_POSITION_PRECEDING) return 1;
    return 0;
  });

  // The URL fragment seeds the lock. By the time a navigation re-runs setup a
  // clicked anchor has already pushed its hash, so clicks, deep links, and
  // back/forward all pin the named section even when the page cannot scroll
  // it up to the trigger line. Cross-page navigations carry no fragment, so a
  // lock never leaks between pages that reuse section ids.
  const hash = window.location.hash.slice(1);
  let lockedId = linkById.has(hash) ? hash : null;

  let lastActive = null;
  const apply = (activeId) => {
    if (activeId === lastActive) return;
    lastActive = activeId;
    for (const [id, link] of linkById) {
      if (id === activeId) {
        link.setAttribute("data-active", "true");
        link.setAttribute("aria-current", "true");
      } else {
        link.removeAttribute("data-active");
        link.removeAttribute("aria-current");
      }
    }
  };

  const computeActive = () => {
    let activeId = targets[0].id;
    for (const t of targets) {
      if (t.getBoundingClientRect().top <= TRIGGER_Y) activeId = t.id;
      else break;
    }
    return activeId;
  };

  const update = () => {
    if (lockedId) apply(lockedId);
    else apply(computeActive());
  };

  let ticking = false;
  const onScroll = () => {
    if (ticking) return;
    ticking = true;
    requestAnimationFrame(() => {
      ticking = false;
      update();
    });
  };

  // Manual scrolling hands control back to the spy. Recompute immediately:
  // the gesture may not move the page (a wheel nudge while already at the
  // top), so waiting for a scroll event could leave a stale highlight.
  const releaseLock = () => {
    if (!lockedId) return;
    lockedId = null;
    onScroll();
  };

  const onKeyDown = (e) => {
    const navKeys = [
      "PageDown",
      "PageUp",
      "ArrowDown",
      "ArrowUp",
      "Home",
      "End",
      " ",
    ];
    if (!navKeys.includes(e.key)) return;
    // In a field these keys edit text rather than scroll the page.
    if (e.target.closest?.("input, textarea, select, [contenteditable]")) {
      return;
    }
    releaseLock();
  };

  // Scrollbar drags fire neither wheel nor touchmove. A mousedown past the
  // content box is a scrollbar grab (clientWidth and clientHeight exclude
  // classic scrollbars), so it releases like any other manual scroll.
  const onMouseDown = (e) => {
    const root = document.documentElement;
    if (e.clientX >= root.clientWidth || e.clientY >= root.clientHeight) {
      releaseLock();
    }
  };

  // TOC click handlers lock the active state to the clicked link. The page
  // may not be able to scroll a near-bottom section all the way to the
  // trigger line, so without this the spy would keep highlighting an
  // earlier section after the click.
  const clickHandlers = [];
  for (const [id, link] of linkById) {
    const handler = () => {
      lockedId = id;
      apply(id);
    };
    link.addEventListener("click", handler);
    clickHandlers.push([link, handler]);
  }

  // In-page heading anchors lock the same way, so the highlighted TOC entry
  // always matches the section named in the URL hash. Anchors without a TOC
  // entry just release any lock and let the spy recompute on scroll.
  for (const anchor of document.querySelectorAll("[data-anchor-link]")) {
    const href = anchor.getAttribute("href") || "";
    if (!href.startsWith("#")) continue;
    const id = href.slice(1);
    const handler = () => {
      lockedId = linkById.has(id) ? id : null;
      if (lockedId) apply(lockedId);
    };
    anchor.addEventListener("click", handler);
    clickHandlers.push([anchor, handler]);
  }

  // The TOC list's own edge fades are handled generically by the scroll-fade
  // wiring in docs.ffi.mjs; this module only owns the window-scroll spy below.
  window.addEventListener("scroll", onScroll, { passive: true });
  window.addEventListener("resize", onScroll);
  window.addEventListener("wheel", releaseLock, { passive: true });
  window.addEventListener("touchmove", releaseLock, { passive: true });
  window.addEventListener("mousedown", onMouseDown);
  window.addEventListener("keydown", onKeyDown);

  update();

  cleanup = () => {
    window.removeEventListener("scroll", onScroll);
    window.removeEventListener("resize", onScroll);
    window.removeEventListener("wheel", releaseLock);
    window.removeEventListener("touchmove", releaseLock);
    window.removeEventListener("mousedown", onMouseDown);
    window.removeEventListener("keydown", onKeyDown);
    for (const [link, handler] of clickHandlers) {
      link.removeEventListener("click", handler);
    }
  };
}

export function init() {
  if (scheduled) return;
  scheduled = true;
  // Defer to the next paint so Lustre has finished applying the new view.
  requestAnimationFrame(() => {
    scheduled = false;
    setup();
  });
}
