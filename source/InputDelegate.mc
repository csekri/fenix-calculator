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
    	switch (direction) {
    		case Ui.SWIPE_UP:
    			OnMethods.RotateDigit(view, self, 1);
    			break;
    		case Ui.SWIPE_DOWN:
    			OnMethods.RotateDigit(view, self, -1);
    			break;
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
    	var clickToleranceDistance = 40 * 40;
    	        
        var coords = clickEvent.getCoordinates();
        
        if (distanceSquare(coords[0], coords[1], screenWidth * 0.95, screenHeight * 0.6) < clickToleranceDistance) {
        	OnMethods.OnBack(view, self);
        } else if (distanceSquare(coords[0], coords[1], screenWidth * 0.05, screenHeight * 0.6) < clickToleranceDistance) {
        	OnMethods.OnSelect(view, self);
        } else if (coords[1] < screenHeight * 0.2) {
        	OnMethods.OnMenu(view, self);
        }
        
        return true;
    }
}