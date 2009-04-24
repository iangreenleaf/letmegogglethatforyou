$(document).ready(startTyping);

function startTyping() {
	// Clear out the text field
	textField = $("#q");
	textField.attr('value', '');
	// Start entering text
	enterSearch(searchString, 0, 0);
}

// Enters a string one character at a time into the text field
// Accepts a string STR to enter, an index INDEX to start at (usually 0),
// and a function c to call once we are finished.
function typeString(str, index, c){
	// Have we hit the end of the string?
	if (index < str.length) {
		// Get the next letter and enter it
		var chr = str.substr(index, 1);
		textField.val(textField.val() + chr);
		// Now call recursively for the next letter after a delay
		setTimeout(function(){ typeString(str, index + 1, c); }, Math.random() * 360);
	}
	else {
		c();
	}
}

// Delete some letters from the end of the text field, one at a time
// Accepts an int LENGTH of how many letters to delete, and a function c
// to call when we are finished.
function backspace(length, c) {
	if (length > 0) {
		textField.val(textField.val().substr(0, textField.val().length - 1));
		setTimeout(function(){ backspace(length - 1, c); }, Math.random() * 240);
	} else {
		// Wait a little bit before continuing
		setTimeout(c, 300);
	}
}

// Loop through the diff array, entering the text as we go
// Accepts array MYARRAY, int ARRAYINDEX, int STRINDEX
function enterSearch(myArray, arrayIndex, strIndex) {

	// If we hit the end of the array, we're done
	if (arrayIndex >= myArray.length) {
		return;
	}

	// The beginning of the word that doesn't change
	prefix = myArray[arrayIndex][0];
	// The part that will get deleted
	del = myArray[arrayIndex][1];
	// The part that replaces del
	add = myArray[arrayIndex][2];

	// Amount of time we wait in between typing and beginning to delete
	var waitAfter = 70 * Math.min(del.length, 10)

	// Ok, we're going to do this in continuation-passing style, because that
	// means we don't have to deal with the timeouts outside of where they're invoked.

	// Type in PREFIX, then DEL, then pause, then delete some letters and type in ADD
	typeString(prefix, 0, function() {
			typeString(del, 0, function() {
				setTimeout(function() {
					backspace(del.length, function() {
						typeString(add, 0, function(){
							enterSearch(myArray, arrayIndex + 1, 0);
							});
						});
					}, waitAfter);
				});
			});
}
