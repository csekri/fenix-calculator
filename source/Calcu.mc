//Prefix and postfix notations are evaluated with stack machine.

using Toybox.Lang;
using Toybox.System;
using Toybox.Math;


class Calc {
	// returns if character is a digit
	function isDigit(digit) {
		return digit.equals("0") or digit.equals("1") or digit.equals("2") or
		       digit.equals("3") or digit.equals("4") or digit.equals("5") or
		       digit.equals("6") or digit.equals("7") or digit.equals("8") or digit.equals("9") or digit.equals(".");
	}
	
	
	// same as isDigit but includes "." too
	function isDigitPlus(digit) {
		return Calc.isDigit(digit) or digit.equals("-");
	}
	// same as isDigit but includes "." too
	function isNumber(token) {
		if (token.equals("-")) {
			return false;
		}
		var firstCharacter = token.substring(0,1);
		return Calc.isDigitPlus(firstCharacter) or firstCharacter.equals(".") or firstCharacter.equals("-");
	}
	function formatNumber(str) {
		if (str.equals(".")) { return "0.0"; }
		if (str.substring(0,1).equals(".")) { return "0" + str; }
		return str;
	}
	function isBinaryOPExceptMinus(token) {
		return token.equals("+") or token.equals("*") or token.equals("/")
		     or token.equals("^") or token.equals("log");
	}
	function isUnaryOPExceptMinus(token) {
		return token.equals("sqrt") or token.equals("sin") or token.equals("cos")
		     or token.equals("tan") or token.equals("asin") or token.equals("acos")
		     or token.equals("atan") or token.equals("ln") or token.equals("lg")
		     or token.equals("raddeg") or token.equals("degrad");
	}
	
	
	// evaluates prefix notation expression
	function eval(tokens) {
		var stack = [];
		for (var i = 0; i < tokens.size(); i += 1){
		    var token = tokens[tokens.size() - i - 1];
		    
		    // binary operators
		    if (Calc.isBinaryOPExceptMinus(token) or token.equals("-")) {
		        if (stack.size() < 2) { return "-"; }
		    	var pop = stack[stack.size()-1];
		    	
			    if (token.equals("+")) {
			        stack[stack.size()-2] = stack[stack.size()-2] + pop;
			    }
			    if (token.equals("-")) {
			        stack[stack.size()-2] = pop - stack[stack.size()-2];
			    }
			    if (token.equals("*")) {
			        stack[stack.size()-2] = stack[stack.size()-2] * pop;
			    }
			    if (token.equals("/")) {
			    	if (stack[stack.size()-2] == 0) {
		        		stack[stack.size()-2] = NaN;
		        	} else {
		        		stack[stack.size()-2] = (1.0 * pop) / stack[stack.size()-2];
		            }
			    }
			    if (token.equals("^")) {
			        stack[stack.size()-2] = Math.pow(pop, stack[stack.size()-2]);
			    }
			    if (token.equals("log")) {
			        stack[stack.size()-2] = Math.log(stack[stack.size()-2], pop);
			    }
			    
		        stack = stack.slice(null, stack.size() - 1);
		        continue;
			}
			
			// unary operators
		    if (Calc.isUnaryOPExceptMinus(token) or token.equals("(-)")) {
		        if (stack.size() < 1) { return "-"; }
			    if (token.equals("(-)")) {
			        stack[stack.size()-1] *= -1;}
			    if (token.equals("sqrt")) {
			        stack[stack.size()-1] = Math.sqrt(stack[stack.size()-1]);}
			    if (token.equals("sin")) {
			        stack[stack.size()-1] = Math.sin(stack[stack.size()-1]);}
			    if (token.equals("cos")) {
			        stack[stack.size()-1] = Math.cos(stack[stack.size()-1]);}
			    if (token.equals("tan")) {
			        stack[stack.size()-1] = Math.tan(stack[stack.size()-1]);}
			    if (token.equals("asin")) {
			        stack[stack.size()-1] = Math.asin(stack[stack.size()-1]);}
			    if (token.equals("acos")) {
			        stack[stack.size()-1] = Math.acos(stack[stack.size()-1]);}
			    if (token.equals("atan")) {
			        stack[stack.size()-1] = Math.atan(stack[stack.size()-1]);}
			    if (token.equals("ln")) {
			        stack[stack.size()-1] = Math.log(stack[stack.size()-1], 2.71828);}
			    if (token.equals("lg")) {
			        stack[stack.size()-1] = Math.log(stack[stack.size()-1], 10);}
			    if (token.equals("raddeg")) {
			        stack[stack.size()-1] = stack[stack.size()-1] / (2 * 3.141592) * 360;}
			    if (token.equals("degrad")) {
			        stack[stack.size()-1] = stack[stack.size()-1] * (2 * 3.141592) / 360;}
			    continue;
			}
		
		    if (token.equals("e")) {
		    	var e = 2.71828;
		        stack.add(e);
		        continue;
		    }
		    if (token.equals("pi")) {
		    	var pi = 3.141592;
		        stack.add(pi);
		        continue;
		    }
		
		    var integer = null;
		    var real = null;
		    var pureInteger = true;
		    
			for (var j = 0; j < token.length(); j += 1) {
				if (token.substring(j, j+1).equals(".")) {
					pureInteger = false;
				}
			}
			if (Calc.isNumber(token)) {
				if (pureInteger) {
			    	var apiVersion = System.getDeviceSettings().monkeyVersion;
			    	// from API level 3.1.0 is the toLong supported
					if (apiVersion[0] >= 3 and apiVersion[1] >= 1) {
						integer = token.toLong(); // 64 bit
					} else {
						integer = token.toNumber().toLong(); // 32 bit
					}
					stack.add(integer);
				} else {
					var formattedToken = Calc.formatNumber(token);
					real = formattedToken.toFloat();
					stack.add(real);
				}
			}			
		}
		
		if (stack.size() == 1) {
			if (stack[0] > Math.pow(10, 12) or stack[0] < -Math.pow(10, 12)) {
				return stack[0].format("%.7E");
			} else {
				return stack[0].toString();
			}
		} else {
			return "-";
		}
	}
	
	
	// evaluates postfix notation expression
	function evalPost(tokens) {
		var stack = [];
		if (tokens.size() == 0) {
			return "-";
		}
		for (var i = 0; i < tokens.size(); i += 1){
		    var token = tokens[i];
		    
		    // binary operators
		    if (Calc.isBinaryOPExceptMinus(token) or token.equals("-")) {
		        if (stack.size() < 2) { return "-"; }
		    	var pop = stack[stack.size()-1];
		    	
			    if (token.equals("+")) {
			        stack[stack.size()-2] = stack[stack.size()-2] + pop;
			    }
			    if (token.equals("-")) {
			        stack[stack.size()-2] = stack[stack.size()-2] - pop;
			    }
			    if (token.equals("*")) {
			        stack[stack.size()-2] = stack[stack.size()-2] * pop;
			    }
			    if (token.equals("/")) {
			    	if (stack[stack.size()-1] == 0) {
		        		stack[stack.size()-2] = NaN;
		        	} else {
		        		stack[stack.size()-2] = (1.0 * stack[stack.size()-2]) / pop;
		            }
			    }
			    if (token.equals("^")) {
			        stack[stack.size()-2] = Math.pow(stack[stack.size()-2], pop);
			    }
			    if (token.equals("log")) {
			        stack[stack.size()-2] = Math.log(pop, stack[stack.size()-2]);
			    }
			    
		        stack = stack.slice(null, stack.size() - 1);
		        continue;
			}
			
			// unary operators
		    if (Calc.isUnaryOPExceptMinus(token) or token.equals("(-)")) {
		        if (stack.size() < 1) { return "-"; }
			    if (token.equals("(-)")) {
			        stack[stack.size()-1] *= -1;}
			    if (token.equals("sqrt")) {
			        stack[stack.size()-1] = Math.sqrt(stack[stack.size()-1]);}
			    if (token.equals("sin")) {
			        stack[stack.size()-1] = Math.sin(stack[stack.size()-1]);}
			    if (token.equals("cos")) {
			        stack[stack.size()-1] = Math.cos(stack[stack.size()-1]);}
			    if (token.equals("tan")) {
			        stack[stack.size()-1] = Math.tan(stack[stack.size()-1]);}
			    if (token.equals("asin")) {
			        stack[stack.size()-1] = Math.asin(stack[stack.size()-1]);}
			    if (token.equals("acos")) {
			        stack[stack.size()-1] = Math.acos(stack[stack.size()-1]);}
			    if (token.equals("atan")) {
			        stack[stack.size()-1] = Math.atan(stack[stack.size()-1]);}
			    if (token.equals("ln")) {
			        stack[stack.size()-1] = Math.log(stack[stack.size()-1], 2.71828);}
			    if (token.equals("lg")) {
			        stack[stack.size()-1] = Math.log(stack[stack.size()-1], 10);}
			    if (token.equals("raddeg")) {
			        stack[stack.size()-1] = stack[stack.size()-1] / (2 * 3.141592) * 360;}
			    if (token.equals("degrad")) {
			        stack[stack.size()-1] = stack[stack.size()-1] * (2 * 3.141592) / 360;}
			    continue;
			}
		
		    if (token.equals("e")) {
		    	var e = 2.71828;
		        stack.add(e);
		        continue;
		    }
		    if (token.equals("pi")) {
		    	var pi = 3.141592;
		        stack.add(pi);
		        continue;
		    }

		    var integer = null;
		    var real = null;
		    var pureInteger = true;
		    
			for (var j = 0; j < token.length(); j += 1) {
				if (token.substring(j, j+1).equals(".")) {
					pureInteger = false;
				}
			}
			if (Calc.isNumber(token)) {
				if (pureInteger) {
			    	var apiVersion = System.getDeviceSettings().monkeyVersion;
			    	// from API level 3.1.0 is the toLong supported
					if (apiVersion[0] >= 3 and apiVersion[1] >= 1) {
						integer = token.toLong(); // 64 bit
					} else {
						integer = token.toNumber().toLong(); // 32 bit
					}
					stack.add(integer);
				} else {
					var formattedToken = Calc.formatNumber(token);
					real = formattedToken.toFloat();
					stack.add(real);
				}
			}			
		}
		
		if (stack.size() == 1) {
			if (stack[0] > Math.pow(10, 12) or stack[0] < -Math.pow(10, 12)) {
				return stack[0].format("%.7E");
			} else {
				return stack[0].toString();
			}
		} else {
			return "-";
		}
	}
	
	function dealWithUnaryMinus(tokens) {
		var result = tokens;
		var tmp;
		if (tokens[0].equals("-")) {
			tmp = ["0"];
			tmp.addAll(result);
			result = tmp;
		}
		var length;
		while (true) {
			length = result.size();
			for (var i = 1; i < result.size(); i += 1){
				if (result[i-1].equals("(") and result[i].equals("-")) {
					tmp = result.slice(0, i);
					tmp.add("0");
					tmp.addAll(result.slice(i, null));
					result = tmp;
				}
				if (Calc.isBinaryOPExceptMinus(result[i-1]) and result[i].equals("-")) {
					tmp = result.slice(0, i);
					tmp.add("0");
					tmp.addAll(result.slice(i, null));
					result = tmp;
				}
				
			}
			if (result.size() == length) {
				return result;
			}
		}
		return 0;
	}

	
	function evalInfix(tokens) {
		if (tokens.size() == 0) {
			return "-";
		}
		var op_stack = [];
		var out_queue = [];
		var pop = "";
		var PRECEDENCE = { "+" => 1, "-" => 1, "*" => 2, "/" => 2, "^" => 3, "log" => 4, "(" => -1, ")" => -1 };
		tokens = Calc.dealWithUnaryMinus(tokens);
		for (var i = 0; i < tokens.size(); i += 1){
		    var token = tokens[i];
		    
		    if (Calc.isUnaryOPExceptMinus(token)) {
		    	op_stack.add(token);
		    }
		    else if (Calc.isBinaryOPExceptMinus(token) or token.equals("-")) {
		    	while (op_stack.size() > 0 and !Calc.isUnaryOPExceptMinus(op_stack[op_stack.size()-1]) and PRECEDENCE[op_stack[op_stack.size()-1]] >= PRECEDENCE[token]) {
		    		pop = op_stack[op_stack.size()-1];
		    		op_stack = op_stack.slice(0, op_stack.size()-1);
		    		out_queue.add(pop);
		    	}
		    	op_stack.add(token);
		    }
		    else if (token.equals("(")) {
		    	op_stack.add(token);
		    }
		    else if (token.equals(")")) {
	    		if (op_stack.size() == 0) {
	    			return "-";
	    		}
		    	while (op_stack.size() > 0 and !op_stack[op_stack.size()-1].equals("(")) {
		    		pop = op_stack[op_stack.size()-1];
		    		op_stack = op_stack.slice(0, op_stack.size()-1);
		    		out_queue.add(pop);
		    		if (op_stack.size() == 0) {
		    			return "-";
		    		}
		    	}
	    		op_stack = op_stack.slice(0, op_stack.size()-1); // pop left parenthesis
		    	if (op_stack.size() > 0 and Calc.isUnaryOPExceptMinus(op_stack[op_stack.size()-1])) {
		    		pop = op_stack[op_stack.size()-1];
		    		op_stack = op_stack.slice(0, op_stack.size()-1);
		    		out_queue.add(pop);
		    	}
		    }
		    else if (Calc.isNumber(token) or token.equals("e") or token.equals("pi")) {
					out_queue.add(token);
		    }
		}
		
		while (op_stack.size() > 0) {
    		pop = op_stack[op_stack.size()-1];
    		op_stack = op_stack.slice(0, op_stack.size()-1);
		
			if (pop.equals("(")) {
		    	return "-";
		    }
		    if (!pop.equals(")")) {
	    		out_queue.add(pop);
	    	}
			
		}
		return Calc.evalPost(out_queue);
	}
	
	function evalRpnStack(tokens) {
		var returnList = [];
		returnList.addAll(tokens);
		if (tokens.size() < 2) {
			return returnList;
		}
		for (var i=2; i <= 3; i++) {
			if (i == 3 and tokens.size() < 3){
				return returnList;
			}
			var tokenSlice = tokens.slice(tokens.size()-i, tokens.size());
			var evalEnd = Calc.evalPost(tokenSlice);
			if (!evalEnd.equals("-")) {
				returnList = tokens.slice(0, tokens.size()-i+1);
				returnList[returnList.size()-1] = evalEnd;
				return returnList;
			}
		}
		return returnList;
	}
}





