//This class is responsible for the graphics.

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;

class PrefixCalculatorView extends Ui.View {
	    var numberWidth = 9; // width of character in pixels
    	var numberHeight = 22; // height + line spacing of characters in pixels
    	var stack = []; // operations and numbers in order (contains the tokens of the calculation)
    	var computeMode; // true is prefix mode, false is postfix mode
    	var firstRevealMade = false; // the first time a button is pressed
    	var isInputFull = false; // if four rows became full with input text	
    	
    	
    // Constructor.
    function initialize() {
    	// looks for the stored value of computeMode
    	computeMode = Application.getApp().getProperty("computeMode");
    	// if it is unassigned to prefix/postfix it initialises it to prefix
    	if (computeMode == null) {
    		setComputeMode(true);
    	}
    	// if the mode is postfixmode the stack is initialized to ["0"]
    	if (!self.computeMode) {
    		self.stack = ["0"];
    	}
        View.initialize();
    }


	// Sets the computation mode (prefix/postfix).
	function setComputeMode(computeMode) {
		Application.getApp().setProperty("computeMode", computeMode);
		self.computeMode = computeMode;
	}
	
    // Update the view.
    // Draws everything on canvas and also evaluates the maths expression.
    function onUpdate(dc) {
    	var screenWidth = dc.getWidth();
    	var screenHeight = dc.getHeight();
    	
    	// sets drawing colour white, background color black
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        // clear the window to full black colour
        dc.clear();
        
        // draws the top bottom segment
        dc.drawLine(screenWidth * 0.05, screenHeight * 0.65, screenWidth * 0.95, screenHeight * 0.65);
        // draws the top horizontal segment
        dc.drawLine(screenWidth * 0.05, screenHeight * 0.2, screenWidth * 0.95, screenHeight * 0.2);
        
        //1 BEGIN: writes the computation mode on the screen
        if (self.computeMode) {
        	dc.drawText(screenWidth * 0.50, screenHeight * 0.05, Gfx.FONT_TINY, "prefix", Gfx.TEXT_JUSTIFY_CENTER); // prefix text
        } else {
        	dc.drawText(screenWidth * 0.50, screenHeight * 0.05, Gfx.FONT_TINY, "postfix", Gfx.TEXT_JUSTIFY_CENTER); // postfix text
        }
        //1 END
        
        // expr wil hold the result of the evaluation
    	var expr = 0;

		//2 BEGIN: evaluates the expression in the corresponding calculation mode
    	if (self.computeMode) { // prefix mode
        	expr = Calc.eval(stack);
        	if (stack.size() == 0) {
        		expr = "-";
        	}
        } else { // postfix mode
        	expr = Calc.evalPost(stack);        
        }
        //2 END
        
        //3 BEGIN: writes "=" sign plus the result of the calculation (wraps result if too long)
        if (expr.length() > 14) {
	    	dc.drawText(screenWidth * 0.15, screenHeight * 0.67, Gfx.FONT_TINY, "= " + expr.substring(0, 14), Gfx.TEXT_JUSTIFY_LEFT); // result text
	    	dc.drawText(screenWidth * 0.15, screenHeight * 0.77, Gfx.FONT_TINY, "   " + expr.substring(14, expr.length()), Gfx.TEXT_JUSTIFY_LEFT); // result text
        } else {
    		dc.drawText(screenWidth * 0.15, screenHeight * 0.67, Gfx.FONT_TINY, "= " + expr, Gfx.TEXT_JUSTIFY_LEFT); // result text   	
    	}
    	//3 END
    	
    	var cumstring = ""; // stack converted into text
    	
    	//4 BEGIN: concatanate stack tokens with space into one string
        for (var i = 0; i < stack.size(); i += 1) {
        	cumstring += stack[i] + " ";
        }
        // removes last accidentally added space
        if (cumstring.length() > 0){
        	cumstring = cumstring.substring(0, cumstring.length()-1);
        }
        //4 END
        
        var top   = 0.23 * screenHeight; // y coordinate of the top text row
		var right = 0.1 * screenWidth;   // x c
		var screenWidthRatio = 0.75;     // ratio of text width to screen width
        var row = 0;                     // the current row in the wrapped text
        var cumstringLastChar = cumstring.substring(cumstring.length()-1, cumstring.length()); // the last character in the whole string
        
        //5 BEGIN: wraps text and displays it along with the digit edit special character
        while (cumstring.length() > 0) {
        	var rowCharacterCount = 1;
        	while (rowCharacterCount < cumstring.length() and dc.getTextWidthInPixels(cumstring.substring(0, rowCharacterCount), Gfx.FONT_TINY) <= screenWidth * screenWidthRatio) {
        		rowCharacterCount += 1;
        	}
	        dc.drawText(right, top + row * numberHeight, Gfx.FONT_TINY, cumstring.substring(0, rowCharacterCount), Gfx.TEXT_JUSTIFY_LEFT); // a row from the input
	        if (rowCharacterCount == cumstring.length()) {
	        	if (Calc.isDigitPlus(cumstringLastChar)) {
		        	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		        	dc.drawText(right + dc.getTextWidthInPixels(cumstring.substring(0, cumstring.length()-1), Gfx.FONT_TINY), top+row * numberHeight, Gfx.FONT_TINY, cumstringLastChar, Gfx.TEXT_JUSTIFY_LEFT);
		        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
	  	    	}        
	        }
	        if (row == 3 and dc.getTextWidthInPixels(cumstring.substring(0, rowCharacterCount), Gfx.FONT_TINY) >= screenWidth * screenWidthRatio) {
	        	isInputFull = true;
	        }
	        cumstring = cumstring.substring(rowCharacterCount, cumstring.length());
	        row += 1;
        }
        //5 END
    }
}