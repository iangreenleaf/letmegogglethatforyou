$(document).ready(startTyping);

function startTyping() {
	textField = $("#q");
	textField.attr('value', '');
	enterSearch(searchString, 0, 0);
}

function typeString(string, index, c){
	//alert('Typing ' + string + ', ' + index);
	if (index < string.length) {
		var chr = string.substr(index, 1);
		textField.val(textField.val() + chr);
		setTimeout(function(){ typeString(string, index + 1, c); }, Math.random() * 360);
	}
	else {
		c();
	}
}

function backspace(length, c) {
	//alert('Del ' + length);
	if (length > 0) {
		textField.val(textField.val().substr(0, textField.val().length - 1));
		setTimeout(function(){ backspace(length - 1, c); }, Math.random() * 240);
	} else {
		setTimeout(c, 400);
	}
}

function enterSearch(myArray, arrayIndex, strIndex) {

	if (arrayIndex >= myArray.length) {
		return;
	}

	prefix = myArray[arrayIndex][0];
	del = myArray[arrayIndex][1];
	add = myArray[arrayIndex][2];

	var waitAfter = 70 * Math.min(del.length, 10)

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

function enterSearch_old(myArray, arrayIndex, strIndex) {
	str = myArray[arrayIndex][1];
	type = myArray[arrayIndex][0];
	if (strIndex < str.length) {
		v = textField.val();
		if (type == '-') {
			textField.val(v.substr(0, v.length - 1));
		} else {
			var chr = str.substr(strIndex, 1);
			textField.val(v + chr);
		}
		setTimeout(function(){ enterSearch(myArray, arrayIndex, strIndex + 1); }, Math.random() * 240);
	} else if (++arrayIndex < myArray.length) {
		setTimeout(function(){ enterSearch(myArray, arrayIndex, 0); }, Math.random() * 240);
		str = myArray[arrayIndex][1];
	} else {
		return;
	for (i=0; i<myArray.length; i++) {
		type = myArray[i][0];
		str = myArray[i][1];
		typeString(str, 0);
	}
	}
}
