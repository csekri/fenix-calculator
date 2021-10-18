// Determines the behaviour of the menu with options Exit, Prefix and Postfix.

using Toybox.WatchUi as Ui;

class MainMenuDelegate extends Ui.MenuInputDelegate {
	var view;
	
	function initialize(targetView) {
		view = targetView;
		MenuInputDelegate.initialize();
	}
	
	function onMenuItem(item) {
		if (item == :exit) {
			for (var i = 0; i < 700; i += 1) {
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			}
		}
		else if (item == :pre) {
			view.setComputeMode(true);
			view.stack = [];
			view.input = [];
			view.current = ".";
			view.isInputFull = false;
			view.inputActive = false;
	  		Ui.requestUpdate();
		}
		else if (item == :post) {
			view.setComputeMode(false);
			view.stack = [];
			view.input = [];
			view.current = ".";
			view.isInputFull = false;
			view.inputActive = false;
	  		Ui.requestUpdate();
		}
	}
}