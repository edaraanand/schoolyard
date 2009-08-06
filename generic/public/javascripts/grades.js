// Adding a category in New and Edit Modes

$j(document).ready(function()
  {	
   
     $j("#test").dynamicForm("#plus3", "#minus3");

     // $j(s).dynamicForm("#plus3", "#minus3");

    
  });

// Validation for Adding Grades

var container = $j('div.container');

// validate the form when it is submitted
var validator = $j("#report").validate({
	errorContainer: container,
	errorLabelContainer: $("ol", container),
	wrapper: 'li',
	meta: "validate"
});

// clearing default values in New Mode
 
  function ClearAll()
  { 
     var r = document.getElementById('report');
     var pr =  r.getElementsByTagName('input');
     for (var r=0;r<pr.length;r++)
     {
         if (pr[r].value == pr[r].title)
          {
            pr[r].value = "";
          }
     }
	
  }

// clearing default values in Edit Mode

function cool()
{
	var e = document.getElementById('raja');
	var es =  e.getElementsByTagName('input');
	for (var h=0;h<es.length;h++)
	{
		if ( es[h].value == es[h].title )
		{
			es[h].value = ""
		}
	}
}

// Adding Assignments in Edit Mode

     l = 1
    function assignments(counter)
      {  
	     var r = document.getElementById(counter).id;
	      // var k = r.split('');
	      ul = document.getElementById('ament' + r)
         $j(ul).append("<li id='row" + l + "'><input type='text' class='short text' name='cgories_" + r + "[assignment][name][]' id='txt" + l + "'><input type='text' class='short apart text' name='cgories_" + r + "[assignment][max_point][]' id='txt" + l + "'><a href='#' class='delete-btn' onClick='removeFormField(\"#row" + l + "\"); return false;'></a></li>");
      
        l = (l - 1) + 2;

      }


 // Default Text on focus

  $j(document).ready(function()
      {
          $j(".defaultText").focus(function(srcc)
          {
              if ($j(this).val() == $j(this)[0].title)
              {
                  $j(this).removeClass('defaultTextActive');
                  $j(this).val("");
              }
          });

          $j(".defaultText").blur(function()
          {
              if ($j(this).val() == "")
              {
                  $j(this).addClass("defaultTextActive");
                  $j(this).val($j(this)[0].title);
              }
          });

          $j(".defaultText").blur();        
      });

// Removing Assignments

      function removeFormField(id) 
      {
         $j(id).remove();
       }

// Adding Assignments in New and Edit modes

	   id = 1;
	   function testing(counter)
	       {  
	         var div = document.getElementById(counter);
	         var r = document.getElementById(counter).id;
	         var k = r.split('');
	         a = k[4];
	         if (r == 'test')
	           {
	             var ul = document.getElementById('assignment');
	             $j(ul).append("<li id='row" + id + "'><input type='text' class='short text' name='category[assignment][name][]' id='txt"+id+"'><input type='text' class='short text apart' name='category[assignment][max_point][]' id='txt"+id+"'><a href='#' class='delete-btn' onClick='removeFormField(\"#row"+id+"\"); return false;'></a></li>");
	           }
	         else
	           {
	             var li = div.getElementsByTagName("ul");
	             for (i=0; i<li.length; i++)
	             {
	               if (li[i].id == "assignment")
	               {
	                 li[i].id = "assignment_" + a;
	                }
	             }
	              var tt = document.getElementById('assignment_' + a);
	              $j(tt).append("<li id='row" + id + "'><input type='text' class='short text' name='category_" +  a  + "[assignment][name][]' id='txt" + id + "'><input type='text' class='short text apart' name='category_" +  a  + "[assignment][max_point][]' id='txt" + id + "'><a href='#' class='delete-btn' onClick='removeFormField(\"#row" + id + "\"); return false;'></a></li>");
	           }
	         id = (id - 1) + 2;

	       }