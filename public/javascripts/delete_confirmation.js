$j(document).ready(function() {
  $j('.delete').click(function() {
     var answer = confirm('Are you sure you want to delete this?');
     return answer;
  }); 
});