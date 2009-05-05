$(document).ready(function() {
	initPage();
	// If the variable is not defined, we're on step one
	if (typeof(window['searchString']) == 'undefined') {
		buttons = $('#btnG, #btnI');
		buttons.click(function() {
			// Get the options entered
			queryString = $("#setup_form").serialize();
			// If they clicked I'm Feeling Lucky, add that to the string
			if ($(this).attr("id") == 'btnI') {
				queryString += '&l=1';
			}
			// Build the whole URL
			href = 'http://letmegogglethatforyou.com?' + queryString;
			// Throw up a box with that url
			$(".output").empty().append($('<input readonly="readonly" value="' + href + '" size="50" class="url" >'));
			$(".output input.url").focus().select();
			$(".infobox").text("Now use the link below for great justice.");
			return false;
		});
	} else {
		startTyping();
	}
});

function initPage() {

	ads = $(".ads a");
	amazonLink = $(".ads .brand_logo");

	// Fade the ads and Amazon logo in
	ads.add(amazonLink).css("opacity", "0");
	ads.fadeTo("slow", "0.8");
	amazonLink.fadeTo("slow", "0.6");

	// Give the ads a nice mouseover opacity change
	ads.hover(
		function () {
			$(this).css("opacity", "1.0");
		},
		function () {
			$(this).css("opacity", "0.8");
		}
		);
	amazonLink.hover(
		function () {
			$(this).css("opacity", "1.0");
		},
		function () {
			$(this).css("opacity", "0.6");
		}
		);

	// Hide the about section until someone clicks
	aboutWord = $("h2.about span");
	aboutText = $(".credits p");
	aboutText.hide();
	aboutWord.hover(
		function() {
			$(this).css("cursor", "pointer").css("color", "#666");
		},
		function() {
			$(this).css("cursor", "pointer").css("color", "#999");
		}
		);
	aboutWord.click(function() { aboutText.slideToggle("slow"); });

}
function startTyping() {

	setMessage(1);

	// Clear out the text field
	textField = $("#q");
	textField.attr('value', '');

	// Animate the mouse cursor
	fakeMouse = $("#cursor");
	fakeMouse.show();
	fakeMouse.animate({
		top: textField.position().top  + 15,
		left: textField.position().left + 10
	}, 1500, 'swing', function(){
		textField.focus();
		fakeMouse.animate({ top: "+=18px", left: "+=10px" }, 'fast', function() { fixSafariRenderGlitch(); });
		// Start entering text
		enterSearch(searchString, 0, 0, doneTyping);
		setMessage(2);
	});
}

function doneTyping() {
	setMessage(3);
	button = $(".clickme");
	fakeMouse.animate({
		top: button.position().top  + 10,
		left: button.position().left + 30
	}, 2000, 'swing', function(){
		button.focus();
		setTimeout(function() { button.click(); }, 200);
	});
}

function setMessage(key) {
	$(".infobox .text").text(messageArray['step' + key]);
}
messageArray = {
	step1 : 'Stop and read what you just wrote.',
	step2: 'Does it make any sense at all?',
	step3: 'Spellcheck is no excuse.'
}

/* I'll trust that the LMGTFY guys know what they're doing */
function fixSafariRenderGlitch() {
	if ($.browser.safari) textField.blur().focus();
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
// Accepts array MYARRAY, int ARRAYINDEX, int STRINDEX, function c
function enterSearch(myArray, arrayIndex, strIndex, c) {

	// If we hit the end of the array, we're done
	if (arrayIndex >= myArray.length) {
		c();
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
							enterSearch(myArray, arrayIndex + 1, 0, c);
							});
						});
					}, waitAfter);
				});
			});
}
