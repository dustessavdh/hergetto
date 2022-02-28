import "../css/app.scss"
import "bootstrap"

import "phoenix_html"
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "topbar"
import Hooks from "./_hooks"
import Alpine from "alpinejs"
import "./cookies"

Alpine.start()
window.Alpine = Alpine

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken }, hooks: Hooks, dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) { window.Alpine.clone(from, to) }
    }
  }
})

// Show progress bar on live navigation and form submits.
// Only displays if still loading after 200 msec.
topbar.config({ barColors: { 0: "#E4D8F8" }, shadowColor: "rgba(0, 0, 0, .3)" });
let topBarScheduled = undefined;
window.addEventListener("phx:page-loading-start", () => {
  if (!topBarScheduled) {
    topBarScheduled = setTimeout(() => topbar.show(), 200);
  };
});
window.addEventListener("phx:page-loading-stop", () => {
  clearTimeout(topBarScheduled);
  topBarScheduled = undefined;
  topbar.hide();
});

// connect if there are any LiveViews on the page
liveSocket.connect()
window.liveSocket = liveSocket

