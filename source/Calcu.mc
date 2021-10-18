//Prefix and postfix notations are evaluated with stack machine.

using Toybox.Lang;
using Toybox.System;
using Toybox.Math;


class Calc {
	// returns if character is a digit
	function isDigit(token) {
		return token.equals("0") or token.equals("1") or token.equals("2") or
		       token.equals("3") or token.equals("4") or token.equals("5") or
		       token.equals("6") or token.equals("7") or token.equals("8") or token.equals("9");
	}
	// evaluates prefix notation expression
	function eval(tokens) {
		var stack = [];
		var stack_tmp = [];
		for (var i = 0; i < tokens.size(); i += 1){
		    var token = tokens[tokens.size() - i - 1];
		    // double operators
		    if (token.equals("+") or token.equals("-") or token.equals("*") or token.equals("/")
		     or token.equals("^") or token.equals("log") or token.equals("+")
		     or token.equals("+") or token.equals("+") or token.equals("+")) {
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
		        		stack[stack.size()-2] = - Math.log(0, 10);
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
			    
			    stack_tmp = new [stack.size()-1];
		        for (var k = 0; k < stack.size() - 1; k += 1){
			        stack_tmp[k] = stack[k];
		        }
		        stack = stack_tmp;
		        continue;
			}
			
		    if (token.equals("(-)") or token.equals("sqrt") or token.equals("sin") or token.equals("cos")
		     or token.equals("tan") or token.equals("asin") or token.equals("acos")
		     or token.equals("atan") or token.equals("ln") or token.equals("lg")
		     or token.equals("raddeg") or token.equals("degrad")) {
		        if (stack.size() < 1) { return "-"; }
			    // single operators
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
			        stack[stack.size()-1] = stack[stack.size()-1] / (2 * 3.141565) * 360;}
			    if (token.equals("degrad")) {
			        stack[stack.size()-1] = stack[stack.size()-1] * (2 * 3.141565) / 360;}
			    continue;
			}
		
		    if (token.equals("e")) {
		    	var e = 2.71828;
		        stack.add(e);
		        continue;
		    }
		    if (token.equals("pi")) {
		    	var pi = 3.141565;
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
			
			
			if (isDigit(token.substring(0,1))) {		
				if (pureInteger) {
					integer = token.toNumber().toLong(); // String.toLong() doesn't exist
					stack.add(integer);
				} else {
					real = token.toFloat(); // String.toDouble() doesn't exist
					stack.add(real);
				}
			}			
		}
		if (stack.size() == 1) {
			return stack[0].toString();
		} else {
			return "-";
		}
	}
	// evaluates postfix notation expression
	function evalPost(tokens) {
		var stack = [];
		var stack_tmp = [];
		if (tokens.size() == 0) {
			return "-";
		}
		for (var i = 0; i < tokens.size(); i += 1){
		    var token = tokens[i];
		    // double operators
		    if (token.equals("+") or token.equals("-") or token.equals("*") or token.equals("/")
		     or token.equals("^") or token.equals("log") or token.equals("+")
		     or token.equals("+") or token.equals("+") or token.equals("+")) {
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
		        		stack[stack.size()-2] = -Math.log(0, 10);
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
			    
			    stack_tmp = new [stack.size()-1];
		        for (var k = 0; k < stack.size() - 1; k += 1){
			        stack_tmp[k] = stack[k];
		        }
		        stack = stack_tmp;
		        continue;
			}
			
			
		    if (token.equals("(-)") or token.equals("sqrt") or token.equals("sin") or token.equals("cos")
		     or token.equals("tan") or token.equals("asin") or token.equals("acos")
		     or token.equals("atan") or token.equals("ln") or token.equals("lg")
		     or token.equals("raddeg") or token.equals("degrad")) {
		        if (stack.size() < 1) { return "-"; }
			    // single operators
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
			        stack[stack.size()-1] = stack[stack.size()-1] / (2 * 3.141565) * 360;}
			    if (token.equals("degrad")) {
			        stack[stack.size()-1] = stack[stack.size()-1] * (2 * 3.141565) / 360;}
			    continue;
			}
		
		    if (token.equals("e")) {
		    	var e = 2.71828;
		        stack.add(e);
		        continue;
		    }
		    if (token.equals("pi")) {
		    	var pi = 3.141565;
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
			
			
			if (isDigit(token.substring(0,1))) {		
				if (pureInteger) {
					integer = token.toNumber().toLong();
					stack.add(integer);
				} else {
					real = token.toFloat();
					stack.add(real);
				}
			}			
		}
		if (stack.size() == 1) {
			return stack[0].toString();
		} else {
			return "-";
		}
	}
}





