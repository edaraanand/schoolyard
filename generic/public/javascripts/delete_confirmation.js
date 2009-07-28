$j(document).ready(function() {
  $j('.delete').click(function() {
     var answer = confirm('Are you sure?');
    return answer;
  }); 
});