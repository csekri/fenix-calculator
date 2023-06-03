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
			return;
		}
		//1 END
		
		
		switch (item) {
			case :enter:
				if (self.view.computeMode == 3 and self.view.stack.size() == 5) {
				} else {
					view.stack.add("0");
				}
			break;
			case :clear:
				view.isInputFull = false;
				if (self.view.computeMode == 3) {
			    	self.view.restRpnStackLength = -1;
				}
				view.stack = [];
			break;
			case :delete:
				if (view.stack.size() > 0) {
					view.isInputFull = false;
					if (self.view.computeMode == 3) {
				    	self.view.restRpnStackLength = -1;
					}
					view.stack = view.stack.slice(null, view.stack.size()-1);
				}
			break;
			case :swap:
				if (view.stack.size() > 1) {
					var temp = view.stack[view.stack.size() - 1];
					view.stack[view.stack.size() - 1] = view.stack[view.stack.size() - 2];
					view.stack[view.stack.size() - 2] = temp;
				}
			break;
			case :add:
				view.stack.add("+");
			break;
			case :subtract:
				view.stack.add("-");
			break;
			case :invert:
				view.stack.add("(-)");
			break;
			case :multiply:
				view.stack.add("*");
			break;
			case :divide:
				view.stack.add("/");
			break;
			case :sqrt:
				view.stack.add("sqrt");
			break;
			case :power:
				view.stack.add("^");
			break;
			case :e:
				view.stack.add("e");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :logarithm:
				Ui.pushView(new Rez.Menus.LogarithmMenu(), self, Ui.SLIDE_IMMEDIATE);
			break;
			case :log:
				view.stack.add("log");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :log10:
				view.stack.add("lg");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :logn:
				view.stack.add("ln");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :trigonometry:
				Ui.pushView(new Rez.Menus.TrigonometryMenu(), self, Ui.SLIDE_IMMEDIATE);
			break;
			case :pi:
				view.stack.add("pi");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :sin:
				view.stack.add("sin");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :cos:
				view.stack.add("cos");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :tan:
				view.stack.add("tan");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :asin:
				view.stack.add("asin");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :acos:
				view.stack.add("acos");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :atan:
				view.stack.add("atan");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :degrad:
				view.stack.add("degrad");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :raddeg:
				view.stack.add("raddeg");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
		}
		//return true;
	}
}