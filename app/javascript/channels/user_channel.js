import consumer from "./consumer"


var originalTotalTimeLeft = 600
var originalMessageTimeLeft = 10

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
      messageTimeLeft = originalMessageTimeLeft
  
      $("#chatbar").hide()
      $("#status").text("Now connected to a mysterious internet user! Waiting for them to say something...")
    

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
      $("#chatsubmit").unbind()
      $('#chattext').unbind("keypress.key13")
      if (data.is_unique){
        $("#chatsubmit").bind("click", function(){enableSend()})
        $('#chattext').bind("keypress.key13", function (e) {
          if (e.which == 13) {
            enableSend();
            return false;    
          }
        });
        $("#chatsubmit").css("background-color","lightgreen")
        $("#chatsubmit").val("Send")
      }
      else {
        $("#chatsubmit").css("background-color","lightcoral")
        $("#chatsubmit").val("It's been said!")
      }
    }
  })
}


var totalTimeLeft = originalTotalTimeLeft
var messageTimeLeft = originalMessageTimeLeft
var interval

function formatTime(seconds){
  var minutes = Math.floor(seconds/60)
  var seconds_new = Math.floor(seconds % 60)
  return minutes + ":" + seconds_new.toString().padStart(2,"0")
}

function connectUserChannel(){
  if (!window.location.href.includes("admin")){
    consumer.subscriptions.create({channel: "UserChannel"}, {
      connected() {

        $.ajax({
          type: "GET", 
          url: "/chats/connect_to_new_user",
        })
        
      },

      disconnected() {

        console.log("disconnected")
        
        
      },

      received(data) {

        console.log(data)
        console.log(data.body)
        if (data.body.startsWith("chat_to_user_")){
          totalTimeLeft = originalTotalTimeLeft
          messageTimeLeft = originalMessageTimeLeft
          second_user_id = data.body.split("chat_to_user_")[1]
          $('#chattext').on('input', function(){enableOrDisableSend()});
          if (data.my_turn) {
            $("#chatbar").show()
            $("#status").text("Now connected to a mysterious internet user! Say something *unique*!")
          } else {
            $("#status").text("Now connected to a mysterious internet user! Waiting for them to say something...")
          }
          $("#message-time").text(formatTime(messageTimeLeft))
          $("#total-time").text(formatTime(totalTimeLeft))
          clearInterval(interval);
          var connected = true
          interval = setInterval(function(){
              if (connected && (messageTimeLeft <= 0 || totalTimeLeft <= 0)){
                $("#chatsubmit").unbind()
                $("#chatsubmit").css("background-color","lightcoral")
                $("#chatsubmit").val("Time out")
                connected = false
                $.ajax({
                  type: "GET", 
                  url: "/chats/disconnect_from_current_user"})
              }
              else if (connected){ 
                
                messageTimeLeft -= 1
                totalTimeLeft -= 1
                $("#message-time").text(formatTime(messageTimeLeft))
                $("#total-time").text(formatTime(totalTimeLeft))
              } 
            },1000)
        }
        else if (data.body == "message"){
          $('#history').append("<p><strong>Them: </strong>" +data.message_text+"</p>")
          messageTimeLeft = originalMessageTimeLeft
          $("#chatbar").show()
          $("#status").text("Now connected to a mysterious internet user! Say something *unique*!")
        }
        else if  (data.body == "conversation_ended"){
          $("#chatbar").hide()
          $("#status").text("User disconnected!")
        }
        else if  (data.body == "disconnect_from_user"){
          $("#chatbar").hide()
          $("#status").text("Time ran out! User disconnected!")
        }

        

      }
        // Called when there's incoming data on the websocket for this channel
    });
  }
}

var firstInstance = false

$.ajax({
  type: "GET", 
  url: "/chats/check_for_instances",
  data: {
    user: user_id,
  },
  success: function(data){
    if (data.instances > 0){
      firstInstance = false
      //$("#status").text("You have another window open!")
      connectUserChannel()

    } else {
      firstInstance = true
      connectUserChannel()
    }
    console.log(firstInstance)

  }
})
