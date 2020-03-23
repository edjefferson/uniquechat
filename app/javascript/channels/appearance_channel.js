import consumer from "./consumer"

if (!window.location.href.includes("admin")){

consumer.subscriptions.create("AppearanceChannel", {
  connected() {
    // Called when the subscription is ready for use on the server

  },

  disconnected() {
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
  }
});
}