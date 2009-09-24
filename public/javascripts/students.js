i= 5
function addFormField()
{
	var id = document.getElementById('id').value;
	$j('#students').append("<li id='row" + id + "'><label>Parents/Guardian</label><input type='text' class='short text required' name='parent[fname][fname_"+id+"]' id='fname" + id + "'><input type='text' class='apart short text required' name='parent[lname][lname_"+id+"]' id='lname" + id + "'></li>");
  $j('#students').append("<li id='row" + i + "'><label>Email</label><input type='text' class='text required email' name='parent[email][email_"+i+"]' id='email" + i + "'><a href='#' class='remove' onclick='removeFormField(\"#row" + id + "\", \"#row" + i + "\"); return false;'>Remove</a></li>");
  $('fname'+id).focus();
  id = (id - 1) + 2;
  i = (i - 1) + 2;
  document.getElementById('id').value = id;
}  

 
function removeFormField(id, i) 
 {
	 $j(i).remove();
	 $j(id).remove();
	 
 } 	 
  	
// Validation for Editing The Grades
var container = $j('div.container');

// validate the form when it is submitted
var validator = $j("#student").validate({
    errorContainer: container,
    errorLabelContainer: $("ol", container),
    wrapper: 'li',
    meta: "validate"
});
