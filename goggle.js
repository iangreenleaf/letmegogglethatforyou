$(document).ready(startTyping);

function startTyping() {
	textField = $("#q");
	textField.attr('value', '');
	enterSearch(searchString, 0, 0);
}

function typeString(string, index){
	var chr = string.substr(0, index + 1);
	textField.val(textField.val() + chr);
	if (index < string.length) {
		setTimeout(function(){ typeString(string, index + 1); }, Math.random() * 240);
	}
	else {
	}
}

function backspace() {
}

function enterSearch(myArray, arrayIndex, strIndex) {
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
