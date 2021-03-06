var post = {
  validate: function() {
    var title = $('post_title');
    var content = $('post_content');
    var postSubmit = $('post_submit');
    var errors = "";
    if (title.value == "") {
      title.setStyle({backgroundColor: "#fff9f9"});
			errors += "* Please enter a title.\n";
		}
		if (content.value == "") {
      content.setStyle({backgroundColor: "#fff9f9"});
			errors += "* Please enter some content.\n";
		}
    if (errors == "") {
		  postSubmit.value = "Processing...";
		  postSubmit.disabled = true;
			return true;
		} else {
			alert("Please fix the following errors:\n"+errors);
			return false;
		}
  }
}

// -------------------------
// Multiple File Upload
// -------------------------
function MultiSelector(list_target, max) {
  this.list_target = list_target;this.count = 0;this.id = 0;if( max ){this.max = max;} else {this.max = -1;};this.addElement = function( element ){if( element.tagName == 'INPUT' && element.type == 'file' ){element.name = 'attachment[file_' + (this.id) + ']';element.multi_selector = this;element.onchange = function(){var new_element = document.createElement( 'input' );new_element.type = 'file';this.parentNode.insertBefore( new_element, this );this.multi_selector.addElement( new_element );this.multi_selector.addListRow( this );this.style.position = 'absolute';this.style.left = '-1000px';};if( this.max != -1 && this.count >= this.max ){element.disabled = true;};this.count++;this.current_element = element;} else {alert( 'Error: not a file input element' );};};this.addListRow = function( element ){var new_row = document.createElement('li');var new_row_button = document.createElement( 'a' );new_row_button.title = 'Remove This Image';new_row_button.href = '#';new_row_button.innerHTML = 'Remove';new_row.element = element;new_row_button.onclick= function(){this.parentNode.element.parentNode.removeChild( this.parentNode.element );this.parentNode.parentNode.removeChild( this.parentNode );this.parentNode.element.multi_selector.count--;this.parentNode.element.multi_selector.current_element.disabled = false;return false;};new_row.innerHTML = element.value.split('/')[element.value.split('/').length - 1];new_row.appendChild( new_row_button );this.list_target.appendChild( new_row );};
}
