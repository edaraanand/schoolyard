$j("input.date").datepicker({ yearRange: '1970:2040'});

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
          alert("Please select the Classroom from the dropdown menu");
       }
   else
       {
          var s = $('student').serialize();
          window.open('/students/preview/-/?' + s);
       }
  
 }
 
 function edit_preview()
 {
     var r = $('student').serialize();
     window.open('/students/preview/-/?' + r);
    
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

 var thisForm = "studs";
 
 var defaultVals = new Array();
 defaultVals[0] = new Array("f_name_parent4", "First Name");
 defaultVals[1] = new Array("l_name_parent4", "Last Name");
 
 defaultVals[2] = new Array("f_name_parent3", "First Name");
 defaultVals[3] = new Array("l_name_parent3", "Last Name");
 
 defaultVals[4] = new Array("f_name_parent2", "First Name");
 defaultVals[5] = new Array("l_name_parent2", "Last Name");
 
 defaultVals[6] = new Array("student_first_name", "First Name");
 defaultVals[7] = new Array("student_last_name", "Last Name");
 
 defaultVals[8] = new Array("protector_first_name", "First Name");
 defaultVals[9] = new Array("protector_last_name", "Last Name");
 
 
 function ClearAll() 
  {
     with (document.forms[thisForm]) 
      {
         for (var n=0; n<defaultVals.length; n++) 
         {
            var thisField = defaultVals[n][0];
            var thisDefault = defaultVals[n][1];
            if (elements[thisField].value == elements[thisField].title)
             elements[thisField].value = '';
   }}}
   
   function MPLoadDefaults()
  {
    with (document.forms[thisForm])
    {
        for (var n=0; n<defaultVals.length; n++) 
          {
             var thisField = defaultVals[n][0];
             var thisDefault = defaultVals[n][1];
             if (elements[thisField].value == '')
                elements[thisField].value = thisDefault;
                //elements[thisfield].addClass("defaultTextActive");
    }}}
 
 function MPClearField(field) 
  {
      var fieldName = field.name;
     for (var n=0; n<defaultVals.length; n++) 
       {
         var thisField = defaultVals[n][0];
         var thisDefault = defaultVals[n][1];
       if (thisField == fieldName) {
          if (field.value == thisDefault) field.value = '';
        break;
   }}}
   
 function MPClearAll() 
  {
     with (document.forms[thisForm]) 
      {
         for (var n=0; n<defaultVals.length; n++) 
         {
            var thisField = defaultVals[n][0];
            var thisDefault = defaultVals[n][1];
            if (elements[thisField].value == thisDefault)
             elements[thisField].value = '';
           
   }}}
   
   function clickrecall(thisfield, defaulttext) 
   {
     if (thisfield.value == "")
       {
         thisfield.value = defaulttext;
         //thisfield.className = defaultTextActive;
         thisfield.className += ' defaultTextActive';
         //thisfield.addClass("defaultTextActive");
       }
    }
 
