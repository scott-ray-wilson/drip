const COPY = "[data-markdown]";
const STATUS = "[data-copy-status]";

let installed = false;

export function init() {
  if (installed) return;
  installed = true;

  document.addEventListener("click", (e) => {
    const button = e.target.closest(COPY);
    if (!button) return;
    navigator.clipboard
      .writeText(button.dataset.markdown)
      .then(() => {
        button.setAttribute("data-copied", "true");
        const status = button.querySelector(STATUS);
        if (status) status.textContent = "Copied";
        clearTimeout(button._t);
        button._t = setTimeout(() => {
          button.removeAttribute("data-copied");
          if (status) status.textContent = "";
        }, 1500);
      })
      .catch(() => {});
  });
}
