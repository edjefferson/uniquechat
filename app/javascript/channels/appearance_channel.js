import consumer from "./consumer"

consumer.subscriptions.create("AppearanceChannel", {
  connected() {
    // Called when the subscription is ready for use on the server

  },

  disconnected() {
  },

  received(data) {
    console.log(data.users)
    $("#active_user_list").text("Active users:" + data.users.join(", "))
    // Called when there's incoming data on the websocket for this channel
  }
});
