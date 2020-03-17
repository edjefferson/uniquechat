import consumer from "./consumer"

var user_id = parseInt(document.cookie.match(new RegExp('(^| )user_id=([^;]+)'))[2]);
var second_user_id

function enableSend(){
  $.ajax({
    type: "GET", 
    url: "/chats/new_message",
    data: {
      user_from: user_id,
      user_to: second_user_id,
      message: $("#chattext").val()
    },
    success: function(){
      $('#history').append("<p><strong>You: </strong>" +$("#chattext").val()+"</p>")
      $("#chattext").val("")
    }
  })
}
function enableOrDisableSend(){
  $.ajax({
    type: "GET", 
    url: "/chats/check_message",
    data: {
      user_from: user_id,
      user_to: second_user_id,
      message: $("#chattext").val()
    },
    success: function(data){
      console.log(data)
      if (data.is_unique){
        $("#chatsubmit").unbind()
        $("#chatsubmit").bind("click", function(){enableSend()})
        $("#chatsubmit").css("background-color","lightgreen")
        $("#chatsubmit").val("Send")

      }
      else {
        $("#chatsubmit").unbind()
        $("#chatsubmit").css("background-color","lightcoral")
        $("#chatsubmit").val("It's been said!")

      }
    }
  })
}

consumer.subscriptions.create({channel: "UserChannel"}, {
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
      second_user_id = data.body.split("chat_to_user_")[1]
      $("#chatbar").show()
      $("#status").text("Now connected to a mysterious internet user! Say something *unique*!")
      $('#chattext').on('input', function(){enableOrDisableSend()});
    }
    else if (data.body == "message"){
      $('#history').append("<p><strong>Them: </strong>" +data.message_text+"</p>")
    }
    else if  (data.body == "conversation_ended"){
      $("#chatbar").hide()
      $("#status").text("User disconnected!")

    }

  }
    // Called when there's incoming data on the websocket for this channel
});
