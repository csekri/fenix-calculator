// The operation selector menu.

using Toybox.WatchUi as Ui;

class OpsMenuDelegate extends Ui.MenuInputDelegate {
	var view;
	
	function initialize(targetView) {
		view = targetView;
		MenuInputDelegate.initialize();
	}
	
	function onMenuItem(item) {
		if (item != :clear and view.isInputFull) {
			return true;
		}
		if (item == :enter and (view.stack.size() > 0 or !view.computeMode)) {
			view.addInputToStack();
		}
		if (item != :enter) {
			if (view.upDownPressed != false and !(view.computeMode and view.stack.size() == 0)) {
			view.addInputToStack();
			}
			view.upDownPressed = false;
		}
		if (item == :clear) {
			view.isInputFull = false;
			view.stack = [];
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
			view.newConstant = true;
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
			view.newConstant = true;
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