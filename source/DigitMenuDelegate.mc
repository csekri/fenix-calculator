// Determines the behaviour of the menu with options Exit, Prefix and Postfix.

using Toybox.WatchUi as Ui;

class DigitMenuDelegate extends Ui.MenuInputDelegate {
	var view;
	var delegate;
	
	// Constructor.
	function initialize(targetView, targetDelegate) {
		view = targetView;
		delegate = targetDelegate;
		MenuInputDelegate.initialize();
	}
	
	
	// Called when an item is selected.
	function onMenuItem(item) {
		var digit = "0";
		switch (item) {
			case :d0:
			    digit = "0";
			    break;
			case :d1:
			    digit = "1";
			    break;
			case :d2:
			    digit = "2";
			    break;
			case :d3:
			    digit = "3";
			    break;
			case :d4:
			    digit = "4";
			    break;
			case :d5:
			    digit = "5";
			    break;
			case :d6:
			    digit = "6";
			    break;
			case :d7:
			    digit = "7";
			    break;
			case :d8:
			    digit = "8";
			    break;
			case :d9:
			    digit = "9";
			    break;
			case :ddot:
			    digit = ".";
			    break;
		}
		OnMethods.OnSelect(view, digit, delegate);
		return true;
}
}