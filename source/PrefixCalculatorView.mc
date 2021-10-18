//This class is responsible for the graphics.

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;


class PrefixCalculatorView extends Ui.View {
	    var numberWidth = 9; // width of character in pixels
    	var numberHeight = 22; // height + line spacing of characters
    	var stack = []; // operations and numbers in order
    	var input = []; // current number being added
    	var current = 0; // current character being added <.123456789>
    	var inputActive = false; // character selector is active or not
    	var newConstant = false; // when <pi> or <e> is added 
    	var calc = new Calc(); // calculator class
    	var computeMode; // true is prefix mode, false is postfix mode
    	var firstRevealMade = false; // the first time a button is pressed
    	var upDownPressed = false; // for checks if up or down has been pressed to reveal character edit 
    	var isInputFull = false; // if four rows became full with input text
    	
    function initialize() {
    	computeMode = Application.getApp().getProperty("computeMode");
    	if (computeMode == null) {
    		setComputeMode(true);
    	}
        View.initialize();
    }

	function setComputeMode(computeMode) {
		Application.getApp().setProperty("computeMode", computeMode);
		self.computeMode = computeMode;
	}
	
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    	var screenWidth = dc.getWidth();
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        dc.clear();
        dc.drawText(screenWidth * 0.25, screenWidth * 0.63, Gfx.FONT_TINY, "=", Gfx.TEXT_JUSTIFY_CENTER); // equality sign
        if (self.computeMode) {
        	dc.drawText(screenWidth * 0.50, screenWidth * 0.05, Gfx.FONT_TINY, "prefix", Gfx.TEXT_JUSTIFY_CENTER); // prefix text
        } else {
        	dc.drawText(screenWidth * 0.50, screenWidth * 0.05, Gfx.FONT_TINY, "postfix", Gfx.TEXT_JUSTIFY_CENTER); // postfix text
        }
        
        var tokens = new Array[stack.size()]; // tokens is stack plus conditionally input and current
        for (var i = 0; i < stack.size(); i += 1) {
			tokens[i] = stack[i];
        }
        if (!newConstant) {
	        var str = "";
	        for (var i = 0; i < input.size(); i += 1) {
				str = str + input[i];
	        }
	        if (upDownPressed) {
	        	str += current;
	        }
	    	tokens.add(str);
    	}
    	var expr = 0;
    	if (self.computeMode) {
        	expr = calc.eval(tokens);
        	if (stack.size() == 0) {
        		expr = "-";
        	}
        } else {
        	expr = calc.evalPost(tokens);        
        }
    	dc.drawText(screenWidth *0.30, screenWidth * 0.75, Gfx.FONT_XTINY, expr, Gfx.TEXT_JUSTIFY_LEFT); // result text   	
    	
    	var cumstring = ""; // input text
        for (var i = 0; i < stack.size(); i += 1) {
        	cumstring += stack[i] + " ";
        }
        for (var i = 0; i < input.size(); i += 1) {
        	cumstring += input[i];
        }
        
        var top = 0.25 * screenWidth;
		var right = 0.1 * screenWidth;
        var row = 0;
        while (cumstring.length() > 17) {
        	var index = 17;
	        dc.drawText(right, top + row * numberHeight, Gfx.FONT_TINY, cumstring.substring(0, index), Gfx.TEXT_JUSTIFY_LEFT); // a row from the input
	        cumstring = cumstring.substring(index, cumstring.length());
	        if (row == 2 and cumstring.length() == 17) {
	        	isInputFull = true;
	        }
	        row += 1;
        }
        dc.drawText(right, top + row * numberHeight, Gfx.FONT_TINY, cumstring, Gfx.TEXT_JUSTIFY_LEFT); // the last row from the input
        
        if (inputActive) {
	        	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
	        	dc.drawText(right + dc.getTextWidthInPixels(cumstring, Gfx.FONT_TINY), top+row * numberHeight, Gfx.FONT_TINY, current, Gfx.TEXT_JUSTIFY_LEFT); // the character selector
	        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
	        }        
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }


    function addInputToStack() {
		var str = "";
		var pureInteger = true;
		for (var i = 0; i < input.size(); i += 1) {
			if (input[i].equals(".")) {
				pureInteger = false;
			}
			str = str + input[i];
		}
		str = str + current;
		if (pureInteger) {
			stack.add(str); // String.toLong() doesn't exist
		} else {
			stack.add(str); // String.toDouble() doesn't exist
		}
		input = [];
		current = 0;
		inputActive = false;
	}
}