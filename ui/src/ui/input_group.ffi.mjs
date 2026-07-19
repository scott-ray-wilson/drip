const ADDON = '[data-slot="input-group-addon"]';
const CONTROL = '[data-slot="input-group-control"]';
const GROUP = '[data-slot="input-group"]';

let installed = false;

export function init() {
  if (installed) return;
  installed = true;

  document.addEventListener("click", (e) => {
    const addon = e.target.closest(ADDON);
    if (!addon) return;
    // Don't steal focus when the user clicks a button inside the addon.
    if (e.target.closest("button")) return;
    const group = addon.closest(GROUP);
    if (!group) return;
    const control = group.querySelector(CONTROL);
    if (control && typeof control.focus === "function") control.focus();
  });
}
