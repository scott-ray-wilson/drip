const ROOT = '[data-slot="alert-dialog-root"]';
const TRIGGER = "[data-alert-dialog-trigger]";
const DIALOG = '[data-slot="alert-dialog"]';
const TITLE = '[data-slot="alert-dialog-title"]';
const DESCRIPTION = '[data-slot="alert-dialog-description"]';
const CLOSER = "[data-alert-dialog-close]";

let installed = false;
let nextId = 0;

// The Gleam API takes title/description children but no ids: assigning them
// here keeps the call sites tidy while still satisfying the APG requirement
// that an alertdialog reference a title via aria-labelledby and a message via
// aria-describedby. We do it just-in-time on open rather than at init so
// dialogs added after init (SPA re-renders) get wired too.
function wireAria(dialog) {
  const title = dialog.querySelector(TITLE);
  if (title && !dialog.getAttribute("aria-labelledby")) {
    if (!title.id) title.id = `alert-dialog-title-${++nextId}`;
    dialog.setAttribute("aria-labelledby", title.id);
  }
  const desc = dialog.querySelector(DESCRIPTION);
  if (desc && !dialog.getAttribute("aria-describedby")) {
    if (!desc.id) desc.id = `alert-dialog-description-${++nextId}`;
    dialog.setAttribute("aria-describedby", desc.id);
  }
}

export function init() {
  if (installed) return;
  installed = true;

  document.addEventListener("click", (e) => {
    const trigger = e.target.closest(TRIGGER);
    if (trigger) {
      const root = trigger.closest(ROOT);
      const dialog = root && root.querySelector(DIALOG);
      if (dialog && typeof dialog.showModal === "function") {
        e.preventDefault();
        wireAria(dialog);
        dialog.showModal();
      }
      return;
    }

    const closer = e.target.closest(CLOSER);
    if (closer) {
      const dialog = closer.closest(DIALOG);
      if (dialog && typeof dialog.close === "function") {
        dialog.close();
      }
    }
  });
}
