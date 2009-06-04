document.registration.parent_first_name.focus();


  var student2_obj = document.getElementById('student2');
  var student3_obj = document.getElementById('student3');
  var student4_obj = document.getElementById('student4');
  var am2_obj     = document.getElementById('am2');
  var am3_obj     = document.getElementById('am3');
  var am4_obj     = document.getElementById('am4');
 
  function add_student2()
  {
    student2_obj.style.display  =  "block";
    am2_obj.style.display      =  "none";
    am3_obj.style.display     =  "block";
  }
  
  function add_student3()
   {
     student3_obj.style.display  =  "block";
     am3_obj.style.display      =  "none";
     am4_obj.style.display      =  "block"; 
    }
    
  function add_student4()
   {
     student4_obj.style.display  =  "block";
     am4_obj.style.display      =  "none";
   }

   $j("#DOB1").datepicker({ yearRange: '1970:2040'});
   $j("#DOB2").datepicker({ yearRange: '1970:2040'});
   $j("#DOB3").datepicker({ yearRange: '1970:2040'});
   $j("#DOB4").datepicker({ yearRange: '1970:2040'});
      
      
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
   var parent_first = document.getElementById('parent_first_name');
   var parent_last = document.getElementById('parent_last_name');
   var parent_mail = document.getElementById('parent_email');
   
   var student_f1 = document.getElementById('registration_first_name');
   var student_l1 = document.getElementById('registration_last_name');
   
   var student_f2 = document.getElementById('f_name_student2');
   var student_l2 = document.getElementById('l_name_student2');
   var student_f3 = document.getElementById('f_name_student3');
   var student_l3 = document.getElementById('l_name_student3');
   var student_f4 = document.getElementById('f_name_student4');
   var student_l4 = document.getElementById('l_name_student4');
   
   if (parent_first.value == parent_first.title) 
   {
     parent_first.value = ""
    }
  if (parent_last.value == parent_last.title) 
   {
     parent_last.value = ""
    }
   if (parent_mail.value == parent_mail.title) 
   {
     parent_mail.value = ""
    }
    if (student_f1.value == student_f1.title) 
   {
     student_f1.value = ""
    }
     if (student_l1.value == student_l1.title) 
   {
     student_l1.value = ""
    }
    if (student_f2.value == student_f2.title) 
   {
     student_f2.value = ""
    }
     if (student_l2.value == student_l2.title) 
   {
     student_l2.value = ""
    }
    if (student_f3.value == student_f3.title) 
   {
     student_f3.value = ""
    }
     if (student_l3.value == student_l3.title) 
   {
     student_l3.value = ""
    }
     if (student_f4.value == student_f4.title) 
   {
     student_f4.value = ""
    }
     if (student_l4.value == student_l4.title) 
   {
     student_l4.value = ""
    }
}
