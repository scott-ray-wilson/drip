const TRIGGER = "[data-dialog-target]";
const ROOT = '[data-slot="dialog"]';
const CLOSE = '[data-slot="dialog-close"], [data-dialog-close]';
const TITLE = '[data-slot="dialog-title"]';
const DESCRIPTION = '[data-slot="dialog-description"]';

let installed = false;
let nextId = 0;

// The Gleam API takes title/description children but no ids: assigning them
// here keeps call sites tidy while still giving the dialog an accessible name
// (aria-labelledby) and description (aria-describedby). Done just-in-time on
// open so dialogs added after init (SPA re-renders) get wired too.
function wireAria(dialog) {
  const title = dialog.querySelector(TITLE);
  if (title && !dialog.getAttribute("aria-labelledby")) {
    if (!title.id) title.id = `dialog-title-${++nextId}`;
    dialog.setAttribute("aria-labelledby", title.id);
  }
  const desc = dialog.querySelector(DESCRIPTION);
  if (desc && !dialog.getAttribute("aria-describedby")) {
    if (!desc.id) desc.id = `dialog-description-${++nextId}`;
    dialog.setAttribute("aria-describedby", desc.id);
  }
}

export function init() {
  if (installed) return;
  installed = true;

  document.addEventListener("click", (e) => {
    const trigger = e.target.closest(TRIGGER);
    if (trigger) {
      const targetId = trigger.dataset.dialogTarget;
      const dialog = targetId && document.getElementById(targetId);
      if (dialog && typeof dialog.showModal === "function") {
        e.preventDefault();
        wireAria(dialog);
        dialog.showModal();
      }
      return;
    }

    const closer = e.target.closest(CLOSE);
    if (closer) {
      const dialog = closer.closest(ROOT);
      if (dialog && typeof dialog.close === "function") {
        dialog.close();
      }
      return;
    }

    // A backdrop click reports the <dialog> itself as the target, but so does a
    // click on the dialog's own padding: compare against the element's box and
    // only close when the point falls outside it.
    if (e.target.matches(ROOT) && typeof e.target.close === "function") {
      const r = e.target.getBoundingClientRect();
      const outside =
        e.clientX < r.left ||
        e.clientX > r.right ||
        e.clientY < r.top ||
        e.clientY > r.bottom;
      if (outside) e.target.close();
    }
  });
}
