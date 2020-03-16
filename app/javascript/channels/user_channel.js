import consumer from "./consumer"

var user_id = parseInt(document.cookie.match(new RegExp('(^| )user_id=([^;]+)'))[2]);

consumer.subscriptions.create({channel: "UserChannel", user_id: user_id}, {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {

    console.log(data)
    console.log(data.body)
    if (data.body.startsWith("chat_to_user_")){
      var second_user_id = data.body.split("chat_to_user_")[1]
      $("#now_talking_to").show()
      $("#now_talking_to").click(
        function(){
          $.ajax({
            type: "GET", 
            url: "/chats/new_message",
            data: {
              user_from: user_id,
              user_to: second_user_id,
              message: "hello"
            },
            success: function(){
            }
          })
        }
      )
    }

    // Called when there's incoming data on the websocket for this channel
  }
});
