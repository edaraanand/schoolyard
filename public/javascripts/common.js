document.message.welcome_message_content.focus();
 function preview()
 {
 var name = document.getElementById('welcome_message_access_name');
 if (name.value == "")
 {
   alert("Please select the Classroom/Homepage from the dropdown menu");
 }
 else
 {
 var s = $('welcome_message').serialize();
    window.open('/welcome_messages/preview/-/?' + s, 'mywin', 'left=20,top=20,width=1000,height=500,toolbar=1,resizable=0');
 }
 }
