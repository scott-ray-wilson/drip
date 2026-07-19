// --- Theme ------------------------------------------------------------------

const THEME_KEY = "theme";

export function set_theme(theme) {
  const apply = () => {
    document.documentElement.classList.toggle("dark", theme === "dark");
  };
  const reduce = window.matchMedia?.("(prefers-reduced-motion: reduce)").matches;
  if (document.startViewTransition && !reduce) {
    document.startViewTransition(apply);
  } else {
    apply();
  }
  try {
    localStorage.setItem(THEME_KEY, theme);
  } catch {}
}

export function get_theme() {
  try {
    return localStorage.getItem(THEME_KEY) ?? "dark";
  } catch {
    return "dark";
  }
}

// --- Page Title -------------------------------------------------------------

export function set_title(title) {
  document.title = title;
}

// --- Scroll -----------------------------------------------------------------

export function scroll_to_fragment(fragment) {
  document.getElementById(fragment)?.scrollIntoView();
}

// --- Scroll edge fades --------------------------------------------------------

// Any element tagged `data-scroll-fade` gets `data-fade-top` /
// `data-fade-bottom` toggled as it scrolls, so the CSS mask can reveal a soft
// fade at whichever edge still has hidden content. Each area is driven by its
// own scroll, independent of the page-level scroll handling above.

// Areas we've already wired, so re-running init after a navigation doesn't
// stack duplicate scroll listeners on a node that persisted across the patch.
const wiredFadeAreas = new WeakSet();

function measureFade(el) {
  const { scrollTop, scrollHeight, clientHeight } = el;
  el.toggleAttribute("data-fade-top", scrollTop > 1);
  el.toggleAttribute(
    "data-fade-bottom",
    scrollHeight - clientHeight - scrollTop > 1,
  );
}

// A single, rAF-throttled resize listener re-measures every fade area. Kept at
// module scope and added once so it never closes over a stale element.
let fadeResizeWired = false;
function wireFadeResize() {
  if (fadeResizeWired) return;
  fadeResizeWired = true;
  let ticking = false;
  window.addEventListener("resize", () => {
    if (ticking) return;
    ticking = true;
    requestAnimationFrame(() => {
      ticking = false;
      for (const el of document.querySelectorAll("[data-scroll-fade]")) {
        measureFade(el);
      }
    });
  });
}

function wireFade(el) {
  if (!wiredFadeAreas.has(el)) {
    wiredFadeAreas.add(el);
    let ticking = false;
    el.addEventListener(
      "scroll",
      () => {
        if (ticking) return;
        ticking = true;
        requestAnimationFrame(() => {
          ticking = false;
          measureFade(el);
        });
      },
      { passive: true },
    );
  }
  measureFade(el);
}

// Idempotent and safe to call after each navigation.
export function init_scroll_fades() {
  wireFadeResize();
  // Defer to the next paint so Lustre has finished applying the new view and
  // each scroll area has settled at its final size before the first measure.
  requestAnimationFrame(() => {
    for (const el of document.querySelectorAll("[data-scroll-fade]")) {
      wireFade(el);
    }
  });
}
