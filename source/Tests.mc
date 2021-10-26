/*
Tests for the correctness of the calculation evaluator both in
perfix and postfix notations
*/

using Toybox.Test;


// Tests if a and b are close enough (to say the evaluation is correct).
// Returns true if they are close otherwise false.
function toleranceTest(a, b) {
	var epsilon = 0.001;
	if ((a.toFloat()-b.toFloat())*(a.toFloat()-b.toFloat()) < epsilon * epsilon) {
		return true;
	} else {
		return false;
	}
}

// Tests for the prefix notation calculation
function prefixTests() {
	var calc = new Calc();
	var stack = ["1"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "1"), true);
	
	stack = ["+", "1", "2"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "3"), true);
	
	stack = ["+", "1", "2.2"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "3.2"), true);
	
	stack = ["-", "10", "4"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "6"), true);
	
	stack = ["*", "3", "4"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "12"), true);
	
	stack = ["/", "5", "3"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "1.666666"), true);
	
	stack = ["/", "7", "0"];
	Test.assertEqual(calc.eval(stack), "nan");
	
	stack = ["log", "2", "1024"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "10"), true);
	
	stack = ["(-)", "4"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "-4"), true);
	
	stack = ["sqrt", "4"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "2"), true);

	stack = ["sin", "1"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "0.84147"), true);

	stack = ["cos", "1"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "0.5403"), true);

	stack = ["tan", "1"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "1.5574"), true);

	stack = ["asin", "0.5"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "0.52359"), true);

	stack = ["acos", "0.5"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "1.04719"), true);

	stack = ["atan", "0.5"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "0.463647"), true);

	stack = ["ln", "10"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "2.30258"), true);

	stack = ["lg", "31"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "1.4914"), true);

	stack = ["raddeg", "2"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "114.592"), true);

	stack = ["degrad", "3"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "0.0523599"), true);

	stack = ["pi"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "3.1415926535"), true);

	stack = ["e"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "2.71828"), true);
	
	// complicated
	stack = ["+", "+", "+", "+", "1.2", "2.4", "3.6", "4.8", "6.0"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "18.0"), true);

	// sqrt(3*3+4*4)
	stack = ["sqrt", "+", "^", "3", "2", "^", "4", "2"];
	Test.assertEqual(toleranceTest(calc.eval(stack), "5"), true);
}


// Tests for the postfix notation calculation
function postfixTests() {
	var calc = new Calc();
	var stack = ["1"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "1"), true);
	
	stack = ["1", "2", "+"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "3"), true);
	
	stack = ["1", "2.2", "+"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "3.2"), true);
	
	stack = ["10", "4", "-"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "6"), true);
	
	stack = ["3", "4", "*"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "12"), true);
	
	stack = ["5", "3", "/"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "1.666666"), true);
	
	stack = ["7", "0", "/"];
	Test.assertEqual(calc.evalPost(stack), "nan");
	
	stack = ["2", "1024", "log"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "10"), true);
	
	stack = ["4", "(-)"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "-4"), true);
	
	stack = ["4", "sqrt"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "2"), true);

	stack = ["1", "sin"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "0.84147"), true);

	stack = ["1", "cos"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "0.5403"), true);

	stack = ["1", "tan"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "1.5574"), true);

	stack = ["0.5", "asin"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "0.52359"), true);

	stack = ["0.5", "acos"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "1.04719"), true);

	stack = ["0.5", "atan"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "0.463647"), true);

	stack = ["10", "ln"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "2.30258"), true);

	stack = ["31", "lg"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "1.4914"), true);

	stack = ["2", "raddeg"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "114.592"), true);

	stack = ["3", "degrad"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "0.0523599"), true);

	stack = ["pi"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "3.1415926535"), true);

	stack = ["e"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "2.71828"), true);
	
	// complicated
	stack = ["1.2", "2.4", "3.6", "4.8", "6.0", "+", "+", "+", "+"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "18.0"), true);

	// sqrt(3*3+4*4)
	stack = ["3", "2", "^", "4", "2", "^", "+", "sqrt"];
	Test.assertEqual(toleranceTest(calc.evalPost(stack), "5"), true);
	
}