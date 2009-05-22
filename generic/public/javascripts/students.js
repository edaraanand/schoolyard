$j("#birth_date").datepicker({ yearRange: '1970:2040'});


   var parent2_obj = document.getElementById('parent2');
   var parent3_obj = document.getElementById('parent3');
   var parent4_obj = document.getElementById('parent4');
   var am2_obj     = document.getElementById('am2');
   var am3_obj     = document.getElementById('am3');
   var am4_obj     = document.getElementById('am4');
 
 function add_parent2()
   {
      parent2_obj.style.display  =  "block";
      am2_obj.style.display      =  "none";
      am3_obj.style.display      =  "block";
   }
 function add_parent3()
   {
      parent3_obj.style.display  =  "block";
      am3_obj.style.display      =  "none";
      am4_obj.style.display      =  "block"; 
    }
 function add_parent4()
   {
      parent4_obj.style.display  =  "block";
      am4_obj.style.display      =  "none";
     
    }
 function preview()
 {
    ClearAll();
    name = document.getElementById('classroom_person');
    if (name.value == "")
       {
          alert("Please select the Classroom/Homepage from the dropdown menu");
       }
   else
       {
          var s = $('student').serialize();
          window.open('/students/preview/-/?' + s);
       }
  
 }

  $j(document).ready(function()
{
    $j(".defaultText").focus(function(srcc)
    {
        if ($j(this).val() == $j(this)[0].title)
        {
            $j(this).removeClass("defaultTextActive");
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


function ClearAll()
{
   var student_f = document.getElementById('student_first_name');
   var student_l = document.getElementById('student_last_name');
   var parent_f = document.getElementById('protector_first_name');
   var parent_l = document.getElementById('protector_last_name');
   
   var f_parent2 = document.getElementById('f_parent2')
   var l_parent2 = document.getElementById('l_parent2')
   
   var f_parent3 = document.getElementById('f_parent3')
   var l_parent3 = document.getElementById('l_parent3')
   
   var f_parent4 = document.getElementById('f_parent4')
   var l_parent4 = document.getElementById('l_parent4')
   
  
   if (student_f.value == student_f.title) 
   {
     student_f.value = ""
    }
  if (student_l.value == student_l.title) 
   {
     student_l.value = ""
    }
    if (parent_f.value == parent_f.title) 
   {
     parent_f.value = ""
    }
  if (parent_l.value == parent_l.title) 
   {
     parent_l.value = ""
    }
  
    if ( f_parent2.value == f_parent2.title )
    {
        f_parent2.value = ""
     }
      if (l_parent2.value == l_parent2.title )
    {
        l_parent2.value = ""
     }
   
    if (f_parent3.value == f_parent3.title) 
   {
      f_parent3.value = ""
    }
     if (l_parent3.value == l_parent3.title) 
   {
      l_parent3.value = ""
    }
     if (f_parent4.value == f_parent4.title) 
   {
      f_parent4.value = ""
    }
     if (l_parent4.value == l_parent4.title) 
   {
      l_parent4.value = ""
    }
}

