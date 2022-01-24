/*
This class is responsible for the button presses in the calculator view.
*/

using Toybox.WatchUi as Ui;
using Toybox.Lang;
using Toybox.System;


class PrefixCalculatorDelegate extends Ui.BehaviorDelegate {
	var view; // class object responsible for the graphical appearance
	
	
	// Constructor.
	function initialize() {	
		// constructor of parent class
		Ui.BehaviorDelegate.initialize();
		view = new PrefixCalculatorView();
		// uncomment next two lines to run the tests, on lower-end devices it might trigger execution timeout
//		prefixTests();
//		postfixTests();
//		infixTests();
		Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
	}


	// Called when menu is pressed (hold up button for it).
	function onMenu() {
    	return OnMethods.OnMenu(view, self);
	}


	// Called when select/start button is pressed.
	function onSelect() {
	    if (self.view.computeMode == 3 and self.view.stack.size() == self.view.restRpnStackLength) {
    	} else {
			return OnMethods.OnSelect(view, "0", self);
		}
	}


	// Called when back button is pressed.
	function onBack() {
    	return OnMethods.OnBack(view, self);
   }


 	// Called when up button is pressed.
    function onNextPage() {
        if (self.view.computeMode == 3 and self.view.stack.size() == self.view.restRpnStackLength) {
    	} else {
    		return OnMethods.RotateDigit(view, self, -1);
    	}
    }


 	// Called when down button is pressed.
    function onPreviousPage() {
    	if (self.view.computeMode == 3 and self.view.stack.size() == self.view.restRpnStackLength) {
    	} else {
    		OnMethods.RotateDigit(view, self, 1);
    	}
    }    
    
}