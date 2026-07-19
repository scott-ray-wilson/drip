const ROOT = '[data-slot="tabs"]';
const LIST = '[data-slot="tabs-list"]';
const TRIGGER = '[data-slot="tabs-trigger"]';
const CONTENT = '[data-slot="tabs-content"]';

let installed = false;
let nextId = 0;
const wired = new WeakSet();

// The Gleam API renders role and aria-selected but can't express the id-based
// relationships the ARIA tabs pattern needs: each tab's aria-controls points at
// its panel, each panel's aria-labelledby points back at its tab, and a vertical
// list carries aria-orientation. Wire them here, once per root, just-in-time so
// tabs added after init by SPA re-renders get wired the first time focus or a
// pointer lands on them.
function wireAria(root) {
  if (wired.has(root)) return;
  wired.add(root);

  const list = root.querySelector(LIST);
  if (list && root.dataset.orientation === "vertical") {
    list.setAttribute("aria-orientation", "vertical");
  }

  root.querySelectorAll(`:scope ${LIST} ${TRIGGER}`).forEach((trigger) => {
    const value = trigger.dataset.value;
    if (!value) return;
    // Panels are direct children of the root (see activate), so scoping the
    // lookup keeps nested tabs from cross-wiring.
    const panel = root.querySelector(
      `:scope > ${CONTENT}[data-value="${CSS.escape(value)}"]`,
    );
    if (!panel) return;
    const pair = ++nextId;
    if (!trigger.id) trigger.id = `tab-${pair}`;
    if (!panel.id) panel.id = `tabpanel-${pair}`;
    trigger.setAttribute("aria-controls", panel.id);
    panel.setAttribute("aria-labelledby", trigger.id);
  });
}

function activate(root, value) {
  root.querySelectorAll(`:scope ${LIST} ${TRIGGER}`).forEach((t) => {
    const match = t.dataset.value === value;
    if (match) {
      t.setAttribute("data-active", "true");
      t.setAttribute("aria-selected", "true");
      t.setAttribute("tabindex", "0");
    } else {
      t.removeAttribute("data-active");
      t.setAttribute("aria-selected", "false");
      t.setAttribute("tabindex", "-1");
    }
  });
  // Panels must be direct children of the root so nested tabs stay isolated.
  root.querySelectorAll(`:scope > ${CONTENT}`).forEach((c) => {
    if (c.dataset.value === value) {
      c.removeAttribute("hidden");
      c.removeAttribute("inert");
      c.setAttribute("tabindex", "0");
    } else {
      c.setAttribute("hidden", "");
      c.setAttribute("inert", "");
      c.setAttribute("tabindex", "-1");
    }
  });
}

export function init() {
  if (installed) return;
  installed = true;

  document.querySelectorAll(ROOT).forEach(wireAria);

  document.addEventListener("click", (e) => {
    const trigger = e.target.closest(TRIGGER);
    if (!trigger) return;
    const root = trigger.closest(ROOT);
    if (!root) return;
    const value = trigger.dataset.value;
    if (value) {
      wireAria(root);
      activate(root, value);
    }
  });

  // Focus entering a tablist is the analog of a dialog opening: wire any root
  // that init's initial pass missed (a pointer click that doesn't focus, or a
  // tablist rendered after init) before assistive tech reads it.
  document.addEventListener("focusin", (e) => {
    const root = e.target.closest?.(ROOT);
    if (root) wireAria(root);
  });

  document.addEventListener("keydown", (e) => {
    const trigger = document.activeElement?.closest?.(TRIGGER);
    if (!trigger) return;
    const root = trigger.closest(ROOT);
    if (!root) return;

    const triggers = Array.from(root.querySelectorAll(TRIGGER)).filter(
      (t) => !t.disabled,
    );
    const idx = triggers.indexOf(trigger);
    if (idx === -1) return;

    const orientation = root.dataset.orientation || "horizontal";
    const prevKey = orientation === "horizontal" ? "ArrowLeft" : "ArrowUp";
    const nextKey = orientation === "horizontal" ? "ArrowRight" : "ArrowDown";

    let nextIdx = idx;
    if (e.key === prevKey) {
      nextIdx = idx > 0 ? idx - 1 : triggers.length - 1;
    } else if (e.key === nextKey) {
      nextIdx = idx < triggers.length - 1 ? idx + 1 : 0;
    } else if (e.key === "Home") {
      nextIdx = 0;
    } else if (e.key === "End") {
      nextIdx = triggers.length - 1;
    } else {
      return;
    }

    // Manual activation: Enter/Space select via the native button click; the
    // roving tabindex follows focus so Tab re-enters at the last focused tab.
    e.preventDefault();
    const next = triggers[nextIdx];
    triggers.forEach((t) => {
      t.setAttribute("tabindex", t === next ? "0" : "-1");
    });
    next.focus();
  });
}
