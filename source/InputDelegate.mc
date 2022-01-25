using Toybox.WatchUi as Ui;
using Toybox.Lang;
using Toybox.System;
using Toybox.Math;


class InputDelegate extends Ui.InputDelegate {
	var view;
	
	
	// Constructor.
	function initialize() {	
		// constructor of parent class
		Ui.InputDelegate.initialize();
		view = new PrefixCalculatorView();
		// uncomment next two lines to run the tests, on lower-end devices it might trigger execution timeout
//		prefixTests();
//		postfixTests();
//		infixTests();
		Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
	}
	
	
	// Swipe up or down.
    function onSwipe(swipeEvent) {
    	var direction = swipeEvent.getDirection();
    	if (self.view.computeMode == 3 and self.view.stack.size() == self.view.restRpnStackLength) {
    	} else {
			switch (direction) {
	    		case Ui.SWIPE_UP:
					OnMethods.RotateDigit(view, self, 1);    			
	    			break;
	    		case Ui.SWIPE_DOWN:
	    			OnMethods.RotateDigit(view, self, -1);
	    			break;
	    		case Ui.SWIPE_LEFT:
	    			OnMethods.OnSelect(view, "0", self);
	    			break;
			}
		}
    }


	// Euclidean distance squared.
	function distanceSquare(x1, y1, x2, y2) {
		return (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
	}
	
	
	// Sign of a real or integer.
	function sign(x) {
		if (x > 0) {
			return 1;
		}
		return -1;
	}
	
	
	// Minimum between a and b.
	function min(a, b) {
		if (a < b) {
			return a;
		}
		return b;
	}

    
    // Touchscreen been tapped on.
    function onTap(clickEvent) {
    	var screenWidth = System.getDeviceSettings().screenWidth;
    	var screenHeight = min(System.getDeviceSettings().screenHeight, 1.3*screenWidth);
    	var clickToleranceDistance = screenWidth * screenWidth * 0.28 * 0.28;
    	        
        var coords = clickEvent.getCoordinates();
        
        if (distanceSquare(coords[0], coords[1], screenWidth * 0.95, screenHeight * 0.68) < clickToleranceDistance) {
        	OnMethods.OnBack(view, self);
        } else if (distanceSquare(coords[0], coords[1], screenWidth * 0.05, screenHeight * 0.68) < clickToleranceDistance) {
//        	Ui.pushView(new Rez.Menus.DigitMenu(), new DigitMenuDelegate(view, self), Ui.SLIDE_IMMEDIATE);
//        	Ui.requestUpdate();
	    	if (self.view.computeMode == 3 and self.view.stack.size() == self.view.restRpnStackLength) {
	    	} else {
				OnMethods.OnSelect(view, "0", self);
			}
        } else if (coords[1] < screenHeight * 0.2) {
        	OnMethods.OnMenu(view, self);
        }
        
        return true;
    }
    
    function onKeyPressed(keyEvent) {
    	view.isInputFull = false;
    	var lengthBefore = view.stack.size();
		if (view.stack.size() > 0) {
			if (view.stack.size() > 1 and view.stack[view.stack.size()-1].equals("(") and Calc.isUnaryOPExceptMinus(view.stack[view.stack.size()-2])) {
				view.stack = view.stack.slice(null, view.stack.size()-2);
			} else {
				if (Calc.isNumber(view.stack[view.stack.size()-1])){
					if (view.stack[view.stack.size()-1].length() > 1) {
						view.stack[view.stack.size()-1] = view.stack[view.stack.size()-1].substring(0, view.stack[view.stack.size()-1].length()-1);
					} else {
						view.stack = view.stack.slice(null, view.stack.size()-1);
					}
				} else {
					view.stack = view.stack.slice(null, view.stack.size()-1);
				}
			}
		}
		var lengthAfter = view.stack.size();
		if (lengthAfter < lengthBefore and self.view.computeMode == 3) {
			self.view.restRpnStackLength = -1;
		}
		Ui.requestUpdate();
    	return true;
    
    }
}