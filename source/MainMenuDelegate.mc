// Determines the behaviour of the menu with options Exit, Prefix and Postfix.

using Toybox.WatchUi as Ui;

class MainMenuDelegate extends Ui.MenuInputDelegate {
	var view;
	
	// Constructor.
	function initialize(targetView) {
		view = targetView;
		MenuInputDelegate.initialize();
	}
	
	
	// Called when an item is selected.
	function onMenuItem(item) {
		if (item == :exit) {
			for (var i = 0; i < 2; i += 1) {
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			}
		}
		else if (item == :pre and view.computeMode != 1) {
			view.setComputeMode(1);
			view.stack = [];
			view.isInputFull = false;
	  		Ui.requestUpdate();
		}
		else if (item == :post and view.computeMode != 2) {
			view.setComputeMode(2);
			view.stack = ["0"];
			view.isInputFull = false;
	  		Ui.requestUpdate();
		}
		else if (item == :inf and view.computeMode != 0) {
			view.setComputeMode(0);
			view.stack = [];
			view.isInputFull = false;
	  		Ui.requestUpdate();
		}
	}
}