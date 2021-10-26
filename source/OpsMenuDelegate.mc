// The operation selector menu.

using Toybox.WatchUi as Ui;

class OpsMenuDelegate extends Ui.MenuInputDelegate {
	var view;
	
	// Constructor.
	function initialize(targetView) {
		view = targetView;
		MenuInputDelegate.initialize();
	}
	
	
	// Called when a menu item is selected.
	function onMenuItem(item) {
		//1 BEGIN: if the 4 rows are full, this disables any selection other than clear and delete with early exit
		if ((item != :clear and item != :delete) and view.isInputFull) {
			return true;
		}
		//1 END
		
		//2 BEGIN: if enter is selected in postfix mode with non-empty stack
		if (item == :enter and !view.computeMode) {
				view.stack.add("0");
		}
		//2 END
		//3 BEGIN: if enter is selected in prefix mode with non-empty stack
		if (item == :enter and view.computeMode) {
			if (view.stack.size() > 0){
				view.stack.add("0");
			}
		}
		//3 END
		if (item == :clear) {
			view.isInputFull = false;
			if (view.computeMode) {
				view.stack = [];			
			} else {
				view.stack = ["0"];
			}
		} else if (item == :delete) {
			view.isInputFull = false;
			if (view.stack.size() > 0) {
				if (!view.computeMode and view.stack.size() == 1) {
					view.stack = ["0"];
				} else {
					view.stack = view.stack.slice(null, view.stack.size()-1);
				}
			}
		} else if (item == :add) {
			view.stack.add("+");
		} else if (item == :subtract) {
			view.stack.add("-");
		} else if (item == :invert) {
			view.stack.add("(-)");
		} else if (item == :multiply) {
			view.stack.add("*");
		} else if (item == :divide) {
			view.stack.add("/");
		} else if (item == :sqrt) {
			view.stack.add("sqrt");
		} else if (item == :power) {
			view.stack.add("^");
		} else if (item == :e) {
			if (view.stack.size() > 0 and view.Calc.isDigitPlus(view.stack[view.stack.size()-1])) {
				view.stack = view.stack.slice(null, view.stack.size()-1);
			}
			view.stack.add("e");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :logarithm) {
			Ui.pushView(new Rez.Menus.LogarithmMenu(), self, Ui.SLIDE_IMMEDIATE);
		} else if (item == :log) {
			view.stack.add("log");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :log10) {
			view.stack.add("lg");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :logn) {
			view.stack.add("ln");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :trigonometry) {
			Ui.pushView(new Rez.Menus.TrigonometryMenu(), self, Ui.SLIDE_IMMEDIATE);
		} else if (item == :pi) {
			if (view.stack.size() > 0 and view.Calc.isDigitPlus(view.stack[view.stack.size()-1])) {
				view.stack = view.stack.slice(null, view.stack.size()-1);
			}
			view.stack.add("pi");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :sin) {
			view.stack.add("sin");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :cos) {
			view.stack.add("cos");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :tan) {
			view.stack.add("tan");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :asin) {
			view.stack.add("asin");
		    Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :acos) {
			view.stack.add("acos");
		    Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :atan) {
			view.stack.add("atan");
		    Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :degrad) {
			view.stack.add("degrad");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :raddeg) {
			view.stack.add("raddeg");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		}
		return true;
	}
}