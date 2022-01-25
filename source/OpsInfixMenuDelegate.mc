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
		
		switch (item) {
			case :clear:
				view.isInputFull = false;
				view.stack = [];
			break;
			case :delete:
				view.isInputFull = false;
				if (view.stack.size() > 0) {
					if (view.stack.size() > 1 and view.stack[view.stack.size()-1].equals("(") and Calc.isUnaryOPExceptMinus(view.stack[view.stack.size()-2])) {
						view.stack = view.stack.slice(null, view.stack.size()-2);
					} else {
						view.stack = view.stack.slice(null, view.stack.size()-1);
					}
				}
			break;
			case :leftbr:
				view.stack.add("(");
			break;
			case :rightbr:
				view.stack.add(")");
			break;
			case :add:
				view.stack.add("+");
			break;
			case :subtract:
				view.stack.add("-");
			break;
			case :multiply:
				view.stack.add("*");
			break;
			case :divide:
				view.stack.add("/");
			break;
			case :sqrt:
				view.stack.add("sqrt");
				view.stack.add("(");
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
				view.stack.add("(");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :logn:
				view.stack.add("ln");
				view.stack.add("(");
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
				view.stack.add("(");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :cos:
				view.stack.add("cos");
				view.stack.add("(");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :tan:
				view.stack.add("tan");
				view.stack.add("(");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :asin:
				view.stack.add("asin");
				view.stack.add("(");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :acos:
				view.stack.add("acos");
				view.stack.add("(");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :atan:
				view.stack.add("atan");
				view.stack.add("(");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :degrad:
				view.stack.add("degrad");
				view.stack.add("(");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			case :raddeg:
				view.stack.add("raddeg");
				view.stack.add("(");
				Ui.popView(Ui.SLIDE_IMMEDIATE);
			break;
			
		}
		return true;
	}
}