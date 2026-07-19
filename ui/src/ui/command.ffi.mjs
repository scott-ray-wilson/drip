const ROOT = '[data-slot="command"]';
const INPUT = '[data-slot="command-input"]';
const ITEM = '[data-slot="command-item"]';
const EMPTY = '[data-slot="command-empty"]';
const GROUP = '[data-slot="command-group"]';

let installed = false;

function visibleItems(root) {
  return Array.from(root.querySelectorAll(ITEM)).filter(
    (i) =>
      i.style.display !== "none" && i.getAttribute("data-disabled") !== "true",
  );
}

function setSelected(root, item) {
  root
    .querySelectorAll(`${ITEM}[data-selected="true"]`)
    .forEach((i) => i.removeAttribute("data-selected"));
  if (item) {
    item.setAttribute("data-selected", "true");
    item.scrollIntoView({ block: "nearest" });
  }
}

function filter(root, query) {
  const items = Array.from(root.querySelectorAll(ITEM));
  const empty = root.querySelector(EMPTY);
  const groups = Array.from(root.querySelectorAll(GROUP));
  const q = query.trim().toLowerCase();
  let visible = 0;

  items.forEach((item) => {
    const text = (item.dataset.label || item.textContent).trim().toLowerCase();
    const matches = q === "" || text.includes(q);
    item.style.display = matches ? "" : "none";
    if (matches) visible++;
  });

  groups.forEach((group) => {
    const hasVisible = Array.from(group.querySelectorAll(ITEM)).some(
      (i) => i.style.display !== "none",
    );
    group.style.display = hasVisible ? "" : "none";
  });

  if (empty) empty.style.display = visible === 0 ? "" : "none";

  const first = items.find((i) => i.style.display !== "none");
  setSelected(root, first ?? null);
}

function selectItem(root, item) {
  const value = item.dataset.value ?? item.textContent.trim();
  root.dispatchEvent(
    new CustomEvent("command:select", { detail: { value }, bubbles: true }),
  );
}

export function init() {
  if (installed) return;
  installed = true;

  document.addEventListener("input", (e) => {
    const input = e.target.closest(INPUT);
    if (!input) return;
    const root = input.closest(ROOT);
    if (root) filter(root, input.value);
  });

  document.addEventListener("focusin", (e) => {
    const input = e.target.closest(INPUT);
    if (!input) return;
    const root = input.closest(ROOT);
    if (root) filter(root, input.value);
  });

  // Keep focus in input when clicking items.
  document.addEventListener("mousedown", (e) => {
    if (e.target.closest(ITEM)) e.preventDefault();
  });

  document.addEventListener("click", (e) => {
    const item = e.target.closest(ITEM);
    if (!item) return;
    const root = item.closest(ROOT);
    if (root) selectItem(root, item);
  });

  document.addEventListener("keydown", (e) => {
    const input = document.activeElement?.closest?.(INPUT);
    if (!input) return;
    const root = input.closest(ROOT);
    if (!root) return;

    const items = visibleItems(root);
    if (items.length === 0) return;

    const currentIdx = items.findIndex(
      (i) => i.getAttribute("data-selected") === "true",
    );
    let nextIdx = currentIdx;

    switch (e.key) {
      case "ArrowDown":
        e.preventDefault();
        nextIdx = currentIdx < items.length - 1 ? currentIdx + 1 : 0;
        break;
      case "ArrowUp":
        e.preventDefault();
        nextIdx = currentIdx > 0 ? currentIdx - 1 : items.length - 1;
        break;
      case "Home":
        e.preventDefault();
        nextIdx = 0;
        break;
      case "End":
        e.preventDefault();
        nextIdx = items.length - 1;
        break;
      case "Enter":
        e.preventDefault();
        if (currentIdx >= 0) {
          const item = items[currentIdx];
          if (item.tagName === "A" && item.hasAttribute("href")) {
            // Synthesize a click so anchors navigate natively and any
            // delegated click handlers (e.g. dialog close) still run.
            item.click();
          } else {
            selectItem(root, item);
          }
        }
        return;
      default:
        return;
    }

    if (nextIdx !== currentIdx) setSelected(root, items[nextIdx]);
  });

  document.addEventListener("mousemove", (e) => {
    const item = e.target.closest(ITEM);
    if (!item) return;
    const root = item.closest(ROOT);
    if (!root) return;
    if (item.getAttribute("data-selected") === "true") return;
    if (item.style.display === "none") return;
    setSelected(root, item);
  });
}
