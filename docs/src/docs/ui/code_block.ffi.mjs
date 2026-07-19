const ROOT = '[data-slot="code-block"]';
const TAB = '[data-slot="code-block-tab"]';
const PANEL = '[data-slot="code-block-panel"]';
const EXPAND = '[data-slot="expand-toggle"]';
const COLLAPSE = '[data-slot="collapse-toggle"]';
const COPY = "[data-copy-button]";

let installed = false;

function activate(root, tab) {
  const value = tab.dataset.tab;
  root.querySelectorAll(TAB).forEach((t) => {
    const on = t.dataset.tab === value;
    t.setAttribute("aria-selected", on ? "true" : "false");
    t.setAttribute("tabindex", on ? "0" : "-1");
  });
  // Panels only toggle visibility; the pre inside each one is the tab stop.
  root.querySelectorAll(PANEL).forEach((p) => {
    if (p.dataset.tab === value) {
      p.removeAttribute("hidden");
      p.removeAttribute("inert");
    } else {
      p.setAttribute("hidden", "");
      p.setAttribute("inert", "");
    }
  });
}

function copy(button) {
  const code = button.parentElement.querySelector("code");
  if (!code) return;
  navigator.clipboard
    .writeText(code.innerText)
    .then(() => {
      button.setAttribute("data-copied", "true");
      clearTimeout(button._t);
      button._t = setTimeout(() => button.removeAttribute("data-copied"), 1500);
    })
    .catch(() => {});
}

// Focus hands off between the expand and collapse pills so keyboard users
// stay anchored; collapsing also rewinds to the block's top. scrollIntoView
// passes no behavior so reduced-motion preferences hold.
function setExpanded(root, expanded) {
  root.setAttribute("data-expanded", expanded ? "true" : "false");
  requestAnimationFrame(() => {
    const pill = root.querySelector(expanded ? COLLAPSE : EXPAND);
    if (pill) pill.focus({ preventScroll: true });
    if (!expanded) root.scrollIntoView({ block: "start" });
  });
}

export function init() {
  if (installed) return;
  installed = true;

  document.addEventListener("click", (e) => {
    const tab = e.target.closest(TAB);
    if (tab) {
      const root = tab.closest(ROOT);
      if (root) activate(root, tab);
      return;
    }

    const copyButton = e.target.closest(COPY);
    if (copyButton) {
      copy(copyButton);
      return;
    }

    const toggle = e.target.closest(`${EXPAND}, ${COLLAPSE}`);
    if (toggle) {
      const root = toggle.closest(ROOT);
      if (root) setExpanded(root, toggle.matches(EXPAND));
    }
  });

  // Mirrors the keyboard model of `ui/tabs`' FFI: Left/Right move focus with
  // wrap-around, Home/End jump to the ends, and Enter/Space select via the
  // native button click.
  document.addEventListener("keydown", (e) => {
    const tab = document.activeElement?.closest?.(TAB);
    if (!tab) return;
    const root = tab.closest(ROOT);
    if (!root) return;

    const tabs = Array.from(root.querySelectorAll(TAB));
    const idx = tabs.indexOf(tab);
    if (idx === -1) return;

    const last = tabs.length - 1;
    let next;
    if (e.key === "ArrowLeft") next = idx > 0 ? idx - 1 : last;
    else if (e.key === "ArrowRight") next = idx < last ? idx + 1 : 0;
    else if (e.key === "Home") next = 0;
    else if (e.key === "End") next = last;
    else return;

    // Manual activation: the roving tabindex follows focus so Tab re-enters
    // at the last focused tab.
    e.preventDefault();
    const target = tabs[next];
    tabs.forEach((t) => t.setAttribute("tabindex", t === target ? "0" : "-1"));
    target.focus();
  });
}
