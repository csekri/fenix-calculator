// This class is responsible for the button presses.

using Toybox.WatchUi as Ui;
using Toybox.Lang;
using Toybox.System;

class PrefixCalculatorDelegate extends Ui.BehaviorDelegate {
	var view;
	
	function initialize() {
		Ui.BehaviorDelegate.initialize();
		view = new PrefixCalculatorView();
//		prefixTests();
//		postfixTests();
		Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
	}

	function onMenu() {
		if (!view.firstRevealMade) {
			Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
		Ui.pushView(new Rez.Menus.MainMenu(), new MainMenuDelegate(view), Ui.SLIDE_IMMEDIATE);
	}

	function onSelect() {
	    if (view.isInputFull) {
    		return true;
    	}
		if (view.inputActive) {
			view.input.add(view.current);
			view.current = 0;
		} else {
			view.inputActive = true;
		}
//		Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
		Ui.requestUpdate();
		return true;
	}
	
	function onBack() {
		view.newConstant = false;
		if (!view.firstRevealMade) {
			Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
		Ui.pushView(new Rez.Menus.OpsMenu(), new OpsMenuDelegate(view), Ui.SLIDE_IMMEDIATE);
    	return true;
    }
    
    function hasDot() {
    	for (var i = 0; i < view.input.size(); i += 1) {
    		if (view.input[i].equals(".")) {
    			return true;
    		}
    	}
    	return false;
 	}
 	
    function onNextPage() {
    	if (view.isInputFull) {
    		return true;
    	}
    	view.upDownPressed = true;
    	if (!view.firstRevealMade) {
			Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
    
		view.newConstant = false;
    	if (view.stack.size() > 0 or !view.computeMode) {
	    	view.inputActive = true;
			if (view.current instanceof Number) {
	    		if (view.current > 0) {
	    			view.current -= 1;
	    		} else {
	    			if (!hasDot()) {
	    				view.current = ".";
	    			} else {
	    				view.current = 9;
	    			}
	    		}
		    } else {
		    	view.current = 9;
	    	}
	  		Ui.requestUpdate();
  		}
  		return true;
    }
    
    function onPreviousPage() {
        if (view.isInputFull) {
    		return true;
    	}
    	view.upDownPressed = true;
       	if (!view.firstRevealMade) {
			Ui.pushView(view, self, Ui.SLIDE_IMMEDIATE);
			view.firstRevealMade = true;
		}
		view.newConstant = false;
        if (view.stack.size() > 0 or !view.computeMode) {
	    	view.inputActive = true;
	    	if (view.current instanceof Number) {
	    		if (view.current < 9) {
	    			view.current += 1;
	    		} else {
	    			if (!hasDot()) {
	    				view.current = ".";
	    			} else {
	    				view.current = 0;
	    			}
	    		}
		    } else {
		    	view.current = 0;
	    	}
	  		Ui.requestUpdate();
  		}
  		return true;
    }
    

}