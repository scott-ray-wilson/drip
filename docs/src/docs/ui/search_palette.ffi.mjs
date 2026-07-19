// Behavior for the docs search palette (see search_palette.gleam). `id` is the
// dialog element's id, owned on the Gleam side so the string is defined once.

let installed = false;

export function init(id) {
  if (installed) return;
  installed = true;

  // ⌘K / Ctrl-K toggles the search palette from anywhere. Shift/Alt combos
  // are left alone (Ctrl-Shift-K is Firefox's web console).
  document.addEventListener("keydown", (e) => {
    if (
      (e.metaKey || e.ctrlKey) &&
      !e.shiftKey &&
      !e.altKey &&
      e.key?.toLowerCase() === "k"
    ) {
      const dialog = document.getElementById(id);
      if (!dialog) return;
      e.preventDefault();
      if (dialog.open) {
        dialog.close();
      } else if (typeof dialog.showModal === "function") {
        dialog.showModal();
      }
    }
  });

  // Picking a result dismisses the palette it lives in. The command surface
  // dispatches `command:select` (bubbling) on click/Enter; the anchor's own
  // navigation is handled by modem.
  document.addEventListener("command:select", (e) => {
    const dialog = e.target.closest?.('dialog[data-slot="dialog"]');
    if (dialog && typeof dialog.close === "function") dialog.close();
  });

  // Reset the query when the palette closes so it reopens fresh. `close`
  // does not bubble, so listen in the capture phase; the synthetic input
  // event re-runs the command filter (visibility, empty state, selection).
  document.addEventListener(
    "close",
    (e) => {
      if (e.target?.id !== id) return;
      const input = e.target.querySelector('[data-slot="command-input"]');
      if (!input) return;
      input.value = "";
      input.dispatchEvent(new Event("input", { bubbles: true }));
    },
    true,
  );
}

// The trigger's shortcut hint depends on this: ⌘K needs a command key.
export function is_apple_platform() {
  const platform =
    navigator.userAgentData?.platform ?? navigator.platform ?? "";
  return /mac|iphone|ipad|ipod/i.test(platform);
}
