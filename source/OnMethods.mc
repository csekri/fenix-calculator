using Toybox.WatchUi as Ui;
using Toybox.Lang;
using Toybox.System;
using Toybox.Math;


class OnMethods {
	// Open menu options.
	function OnMenu (view, delegate) {
	    // if first reveal has not been made
		if (!view.firstRevealMade) {
			Ui.pushView(view, delegate, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
		// opens the main menu
		Ui.pushView(new Rez.Menus.MainMenu(), new MainMenuDelegate(view), Ui.SLIDE_IMMEDIATE);
		return true;
	}
	
	
	// Add new digit or number.
	function OnSelect(view, digit, delegate) {
		// early exit if four rows are full with input
	    if (view.isInputFull) {
    		return true;
    	}
    	// if first reveal has not been made
    	if (!view.firstRevealMade) {
			Ui.pushView(view, delegate, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
		

		// if stack is empty add new number as `digit`
		if (view.stack.size() == 0){
			view.stack.add(digit);
		// else if the last added item is number (might be gramatically incorrect)
		} else if (view.Calc.isDigitPlus(view.stack[view.stack.size()-1].substring(0,1))) {
			view.stack[view.stack.size()-1] += digit;
		// otherwise simply add 0, it start a new number edit
		} else {
			view.stack.add(digit);
		}
		
    	// update view
		Ui.requestUpdate();
		return true;	
	}
	
	
	// Open operations menu.
	function OnBack(view, delegate) {
	    // if first reveal has not been made
		if (!view.firstRevealMade) {
			Ui.pushView(view, delegate, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
		// opens operations view
		if (view.computeMode == 0) {
			Ui.pushView(new Rez.Menus.OpsInfixMenu(), new OpsInfixMenuDelegate(view), Ui.SLIDE_IMMEDIATE);
			
		} else {
			Ui.pushView(new Rez.Menus.OpsMenu(), new OpsMenuDelegate(view), Ui.SLIDE_IMMEDIATE);		
		}
		return true;
	}
	
	
	// Rotate digits by pressing up or down.
	function RotateDigit(view, delegate, difference) {
	    // if first reveal has not been made
    	if (!view.firstRevealMade) {
			Ui.pushView(view, delegate, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
		// early exit stack is empty
		if (view.stack.size() == 0) {
			return true;
		}
    	
    	//1 BEGIN: rotate digits and dot down by one if the last stack item is number
    	var lastItem = view.stack[view.stack.size()-1];
    	var lastItemLastDigit = lastItem.substring(lastItem.length()-1, lastItem.length());
    	
    	if (view.Calc.isDigitPlus(lastItemLastDigit)) {
	    	var digitAsNumber;
	    	var newDigit;
	    	if (lastItemLastDigit.equals(".")) {
	    		digitAsNumber = 10;
	    	} else {
	    		digitAsNumber = lastItemLastDigit.toNumber().toLong();
	    	}
	    	
	    	digitAsNumber = (digitAsNumber + difference + 11) % 11;
	    	
	    	if (digitAsNumber == 10) {
	    		newDigit = ".";
	    	} else {
	    		newDigit = digitAsNumber.toString();
	    	}
    		view.stack[view.stack.size()-1] = lastItem.substring(0, lastItem.length()-1) + newDigit;
	  		Ui.requestUpdate();
	    }
  		//1 END
  		return true;
	}
}