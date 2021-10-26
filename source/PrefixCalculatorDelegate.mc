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
		// uncomment next two lines to run the tests
//		prefixTests();
//		postfixTests();
		Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
	}


	// Called when menu is pressed (hold up button for it).
	function onMenu() {
    	// if first reveal has not been made
		if (!view.firstRevealMade) {
			Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
		// opens the main menu
		Ui.pushView(new Rez.Menus.MainMenu(), new MainMenuDelegate(view), Ui.SLIDE_IMMEDIATE);
	}


	// Called when select/start button is pressed.
	function onSelect() {
		// early exit if four rows are full with input
	    if (view.isInputFull) {
    		return true;
    	}
    	// if first reveal has not been made
    	if (!view.firstRevealMade) {
			Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
		
		// if in postfix mode
		if (!view.computeMode) {
			// if stack is empty add new number as 0
			if (view.stack.size() == 0){
				view.stack.add("0");
			// else if the last added item is number (might be gramatically incorrect)
			} else if (view.Calc.isDigitPlus(view.stack[view.stack.size()-1].substring(0,1))) {
				view.stack[view.stack.size()-1] += "0";
			// otherwise simply add 0, it start a new number edit
			} else {
				view.stack.add("0");
			}
		}
		// if in prefix mode
		if (view.computeMode) {
			// if stack is empty do nothing because no expression starts with number
			if (view.stack.size() == 0){
			
			// else if the last added item is number (might be gramatically incorrect)
			} else if (view.Calc.isDigitPlus(view.stack[view.stack.size()-1].substring(0,1))) {
				view.stack[view.stack.size()-1] += "0";
			// otherwise simply add 0, it start a new number edit
			} else {
				view.stack.add("0");
			}
		}
    	// update view
		Ui.requestUpdate();
		return true;
	}


	// Called when back button is pressed.
	function onBack() {
    	// if first reveal has not been made
		if (!view.firstRevealMade) {
			Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
		// opens operations view
		Ui.pushView(new Rez.Menus.OpsMenu(), new OpsMenuDelegate(view), Ui.SLIDE_IMMEDIATE);
    	return true;
    }


 	// Called when up button is pressed.
    function onNextPage() {
    	// if first reveal has not been made
    	if (!view.firstRevealMade) {
			Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
		// early exit if in prefix mode with empty stack (we do not want to add a number)
		if (view.computeMode and view.stack.size() == 0) {
			return true;
		}
    	
    	//1 BEGIN: rotate digits and dot down by one if the last stack item is number
    	var lastItem = view.stack[view.stack.size()-1];
    	var lastItemLastDigit = lastItem.substring(lastItem.length()-1, lastItem.length());
    	
    	if (view.Calc.isDigitPlus(lastItemLastDigit)) {
    		var newDigit;
    		if (lastItemLastDigit.equals(".")) {
    			newDigit = "9";
    		} else {
    			var digit = lastItemLastDigit.toNumber().toLong();
				if (digit == 0) {
	    			newDigit = ".";
	    		} else {
	    			newDigit = (digit - 1).toString();
	    		}
    		}
    		view.stack[view.stack.size()-1] = lastItem.substring(0, lastItem.length()-1) + newDigit;
	  		Ui.requestUpdate();
  		}
  		//1 END
  		return true;
    }


 	// Called when down button is pressed.
    function onPreviousPage() {
    	// if first reveal has not been made
    	if (!view.firstRevealMade) {
			Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
		
		// early exit if in prefix mode with empty stack
		if (view.computeMode and view.stack.size() == 0) {
			return true;
		}
    	
    	//1 BEGIN: rotate digits and dot up by one if the last stack item is number
    	var lastItem = view.stack[view.stack.size()-1];
    	var lastItemLastDigit = lastItem.substring(lastItem.length()-1, lastItem.length());
    	
    	if (view.Calc.isDigitPlus(lastItemLastDigit)) {
    		var newDigit;
    		if (lastItemLastDigit.equals(".")) {
    			newDigit = "0";
    		} else {
    			var digit = lastItemLastDigit.toNumber().toLong();
				if (digit == 9) {
	    			newDigit = ".";
	    		} else {
	    			newDigit = (digit + 1).toString();
	    		}
    		}
    		view.stack[view.stack.size()-1] = lastItem.substring(0, lastItem.length()-1) + newDigit;
	  		Ui.requestUpdate();
  		}
  		//1 END
  		return true;
    }
    
}