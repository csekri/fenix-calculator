//This class is responsible for the graphics.

using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;

class PrefixCalculatorView extends Ui.View {
    	var stack = []; // operations and numbers in order (contains the tokens of the calculation)
    	var computeMode; // infix:0, prefix:1, postfix:2
    	var firstRevealMade = false; // the first time a button is pressed
    	var isInputFull = false; // if four rows became full with input text
    	var restRpnStackLength = -1;
    	
    	
    // Constructor.
    function initialize() {
    	// looks for the stored value of computeMode
    	computeMode = Application.getApp().getProperty("computeModeNew");
    	// if it is unassigned to infix/prefix/postfix it initialises it to infix
    	if (computeMode == null) {
    		setComputeMode(0);
    	}
        View.initialize();
    }


	// Sets the computation mode (prefix/postfix).
	function setComputeMode(computeMode) {
		Application.getApp().setProperty("computeModeNew", computeMode);
		self.computeMode = computeMode;
	}
	
	function min(a, b) {
		if (a < b) {
			return a;
		}
		return b;
	}
	
	
	function rpnStackView(view, dc, screenWidth, screenHeight, numberHeight) {
		System.println(view.stack);
		var lengthBefore = view.stack.size();
		view.stack = Calc.evalRpnStack(view.stack);
		var lengthAfter = view.stack.size();
		if (lengthAfter - lengthBefore < 0) {
			restRpnStackLength = lengthAfter;
		}
		

		for (var i = 0; i < view.stack.size(); i += 1) {
			var textPrefix = "   ";
			if (i == 0) {
				textPrefix = "> ";
			}
			var text = "";
			if (view.stack[view.stack.size()-1-i].length() > 12) {
				var number = view.stack[view.stack.size()-1-i].toFloat();
				text = textPrefix + (number.format("%.6E"));
	    	} else {
	    		text = textPrefix + view.stack[view.stack.size()-1-i];
	    	}
	    		dc.drawText(screenWidth * 0.13, screenHeight * 0.70 - i*numberHeight, Gfx.FONT_TINY, text, Gfx.TEXT_JUSTIFY_LEFT); // result text	    	
		}
		if (view.stack.size() == 0) {
	    	dc.drawText(screenWidth * 0.13, screenHeight * 0.70, Gfx.FONT_TINY, ">", Gfx.TEXT_JUSTIFY_LEFT); // draw ">" when the stack is empty		
		}
	
	}	
    // Update the view.
    // Draws everything on canvas and also evaluates the maths expression.
    function onUpdate(dc) {
    	var modeTexts = ["traditional", "prefix", "postfix", "rpn stack"];
    	var screenWidth = dc.getWidth();
    	var screenHeight = min(dc.getHeight(), 1.3 * screenWidth);
    	
    	var dims = dc.getTextDimensions("0", Gfx.FONT_TINY);
    	var numberHeight = dims[1]; // height + line spacing of characters in pixels
    	
    	// sets drawing colour white, background color black
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        // clear the window to full black colour
        dc.clear();
        
        // draws the bottom horizontal segment when not in rpn stack mode
        if (self.computeMode != 3) {
	        if (System.getDeviceSettings().isTouchScreen) {
	        	dc.drawLine(screenWidth * 0.13, screenHeight * 0.68, screenWidth * 0.87, screenHeight * 0.68);
	        } else {
	        	dc.drawLine(screenWidth * 0.01, screenHeight * 0.68, screenWidth * 0.99, screenHeight * 0.68);        	
	        }
        }
        
    	// if touchscreen device draws Digit and Ops buttons
        if (System.getDeviceSettings().isTouchScreen) {
        	dc.drawText(screenWidth * 0.05, screenHeight * 0.62, Gfx.FONT_TINY, "D", Gfx.TEXT_JUSTIFY_LEFT);
        	dc.drawText(screenWidth * 0.95, screenHeight * 0.62, Gfx.FONT_TINY, "O", Gfx.TEXT_JUSTIFY_RIGHT);
        }
        
        // draws the top horizontal segment
    	dc.drawLine(screenWidth * 0.01, screenHeight * 0.2, screenWidth * 0.99, screenHeight * 0.2);        	
        
        //1 BEGIN: writes the computation mode on the screen
    	dc.drawText(screenWidth * 0.50, screenHeight * 0.05, Gfx.FONT_TINY, modeTexts[self.computeMode], Gfx.TEXT_JUSTIFY_CENTER);
        //1 END
        
        if (self.computeMode != 3) {
	        // expr will hold the result of the evaluation
	    	var expr = "";
	
			//2 BEGIN: evaluates the expression in the corresponding calculation mode
	    	if (self.computeMode == 1) { // prefix mode
	        	expr = Calc.eval(stack);
	        	if (stack.size() == 0) {
	        		expr = "-";
	        	}
	        } else if (self.computeMode == 2) { // postfix mode
	        	expr = Calc.evalPost(stack);        
	        } else if (self.computeMode == 0) { // infix mode
//	        	System.println(stack);
	        	expr = Calc.evalInfix(stack);
	        }
	        expr = "= " + expr;
	        //2 END
	        
	        //3 BEGIN: writes "=" sign plus the result of the calculation (wraps result if too long)
	        var rowCharacterCount = 0;
	        while (rowCharacterCount < expr.length() and dc.getTextWidthInPixels(expr.substring(0, rowCharacterCount), Gfx.FONT_TINY) <= screenWidth * 0.6) {
	        		rowCharacterCount += 1;
	    	}
	        if (rowCharacterCount < expr.length()) {
		    	dc.drawText(screenWidth * 0.15, screenHeight * 0.70, Gfx.FONT_TINY, expr.substring(0, rowCharacterCount), Gfx.TEXT_JUSTIFY_LEFT); // result text
		    	dc.drawText(screenWidth * 0.15, screenHeight * 0.80, Gfx.FONT_TINY, "   " + expr.substring(rowCharacterCount, expr.length()), Gfx.TEXT_JUSTIFY_LEFT); // result text
	        } else {
	    		dc.drawText(screenWidth * 0.15, screenHeight * 0.70, Gfx.FONT_TINY, expr, Gfx.TEXT_JUSTIFY_LEFT); // result text   	
	    	}
	    	//3 END    	
	    	
	    	var cumstring = ""; // stack converted into text
	    	
	    	//4 BEGIN: concatanate stack into one long string (in pre&postfix modes spaces are added too)
	    	if (self.computeMode == 0) { // infix mode
	    		for (var i = 0; i < stack.size(); i += 1) {
	        		cumstring += stack[i];
	        	}
	        } else {
		        for (var i = 0; i < stack.size(); i += 1) {
		        	cumstring += stack[i] + " ";
		        }
		        // removes last accidentally added space
		        if (cumstring.length() > 0){
		        	cumstring = cumstring.substring(0, cumstring.length()-1);
		        }
	        }
	        //4 END
	        var top   = 0.23 * screenHeight; // y coordinate of the top text row
			var right = 0.1 * screenWidth;   // x c
			var screenWidthRatio = 0.75;     // ratio of text width to screen width
	        var row = 0;                     // the current row in the wrapped text
	        var cumstringLastChar = cumstring.substring(cumstring.length()-1, cumstring.length()); // the last character in the whole string
	        
	        //5 BEGIN: wraps text and displays it along with the digit edit special character
	        while (cumstring.length() > 0) {
	        	rowCharacterCount = 1;
	        	while (rowCharacterCount < cumstring.length() and dc.getTextWidthInPixels(cumstring.substring(0, rowCharacterCount), Gfx.FONT_TINY) <= screenWidth * screenWidthRatio) {
	        		rowCharacterCount += 1;
	        	}
		        dc.drawText(right, top + row * numberHeight, Gfx.FONT_TINY, cumstring.substring(0, rowCharacterCount), Gfx.TEXT_JUSTIFY_LEFT); // a row from the input
		        if (rowCharacterCount == cumstring.length()) {
		        	if (Calc.isDigit(cumstringLastChar)) {
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
        } else {
        	rpnStackView(self, dc, screenWidth, screenHeight, numberHeight);
        }
    }
}