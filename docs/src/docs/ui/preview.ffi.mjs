const ROOT = '[data-slot="preview"]';
const TOGGLE = '[data-slot="code-toggle"]';
const HIDE = '[data-slot="code-hide"]';

let installed = false;

// Focus hands off between the pills so keyboard users stay anchored when the
// one they clicked hides itself; hiding also rewinds to the preview's top.
// scrollIntoView passes no behavior, deferring to the reduced-motion-gated
// scroll-behavior in docs.css.
function setOpen(root, open) {
  const toggle = root.querySelector(TOGGLE);
  if (!toggle) return;
  toggle.setAttribute("aria-expanded", open ? "true" : "false");
  requestAnimationFrame(() => {
    const target = open ? root.querySelector(HIDE) : toggle;
    if (target) target.focus({ preventScroll: true });
    if (!open) root.scrollIntoView({ block: "start" });
  });
}

export function init() {
  if (installed) return;
  installed = true;

  document.addEventListener("click", (e) => {
    const toggle = e.target.closest(TOGGLE);
    if (toggle) {
      const root = toggle.closest(ROOT);
      if (root) setOpen(root, true);
      return;
    }
    const hide = e.target.closest(HIDE);
    if (hide) {
      const root = hide.closest(ROOT);
      if (root) setOpen(root, false);
    }
  });
}
