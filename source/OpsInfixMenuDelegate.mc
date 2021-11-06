// The operation selector menu.

using Toybox.WatchUi as Ui;

class OpsInfixMenuDelegate extends Ui.MenuInputDelegate {
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
		
		if (item == :clear) {
			view.isInputFull = false;
			view.stack = [];
		} else if (item == :delete) {
			view.isInputFull = false;
			if (view.stack.size() > 0) {
				if (view.stack.size() > 1 and view.stack[view.stack.size()-1].equals("(") and Calc.isUnaryOPExceptMinus(view.stack[view.stack.size()-2])) {
					view.stack = view.stack.slice(null, view.stack.size()-2);
				} else {
					view.stack = view.stack.slice(null, view.stack.size()-1);
				}
			}
		} else if (item == :leftbr) {
			view.stack.add("(");
		} else if (item == :rightbr) {
			view.stack.add(")");
		} else if (item == :add) {
			view.stack.add("+");
		} else if (item == :subtract) {
			view.stack.add("-");
		} else if (item == :multiply) {
			view.stack.add("*");
		} else if (item == :divide) {
			view.stack.add("/");
		} else if (item == :sqrt) {
			view.stack.add("sqrt");
			view.stack.add("(");
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
			view.stack.add("(");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :logn) {
			view.stack.add("ln");
			view.stack.add("(");
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
			view.stack.add("(");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :cos) {
			view.stack.add("cos");
			view.stack.add("(");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :tan) {
			view.stack.add("tan");
			view.stack.add("(");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :asin) {
			view.stack.add("asin");
			view.stack.add("(");
		    Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :acos) {
			view.stack.add("acos");
			view.stack.add("(");
		    Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :atan) {
			view.stack.add("atan");
			view.stack.add("(");
		    Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :degrad) {
			view.stack.add("degrad");
			view.stack.add("(");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		} else if (item == :raddeg) {
			view.stack.add("raddeg");
			view.stack.add("(");
			Ui.popView(Ui.SLIDE_IMMEDIATE);
		}
		return true;
	}
}