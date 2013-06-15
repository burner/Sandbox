module calc;

import std.ascii;
import std.stdio;
import std.conv;
import std.math;
import std.traits;

struct calc(T) {
	string str;
	size_t pos;
	T[string] var;

	this(string s) { 
		str = s; 
		pos = 0u;
	}

	this(string s, T[string] v) { 
		str = s; 
		pos = 0;
		var = v;
	}

	char peek() {
		if(pos >= str.length) {
			return '\0';
		}
		return str[pos];
	}

	static double clamp(double a, double x, double b) {
		if(a > x) {
			return a;
		} else if(x > b) {
			return b;
		} else {
			return x;
		}
	}

	bool isWhite(const char c) {
		return c == ' ' || c == '\t' || c == '\n';
	}
	
	char get() {
		if(pos >= str.length) {
			throw new Exception("Out of bound");
		}
		char ret = str[pos++];
		while(pos < str.length && isWhite(str[pos])) {
			pos++;
		}
		return ret;
	}
	
	double number() {
		while(isWhite(peek())) {
			get();
		}
		size_t startPos = pos;
		while ((peek() >= '0' && peek() <= '9') || peek() == '.') {
			get();
		}
		double ret = to!double(str[startPos .. pos]);
		return ret;
	}
	
	double factor() {
		while(isWhite(peek())) {
			get();
		}
		if(peek() >= '0' && peek() <= '9') {
			return number();
		} else if(peek() == '(') {
			get(); // '('
			double result = expression();
			get(); // ')'
			return result;
		} else if(peek() == '-') {
			get();
			return -expression();
		} else if(peek() == '+') {
			get();
			return expression();
		} else if((peek() >= 'a' && peek() <= 'z') || 
				(peek() >= 'A' && peek <= 'Z')) {
			size_t startPos = pos;
			while((peek() >= 'a' && peek() <= 'z') || 
					(peek() >= 'A' && peek <= 'Z')) {
				get();
			}

			string func = str[startPos .. pos - (peek() == '\0' ? 0 : 1)];
			//writefln("\"%s\"", func);
			if(func == "abs") {
				get();
				double ret = fabs(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "exp") {
				get();
				double ret = exp(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "exp2") {
				get();
				double ret = exp2(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "log") {
				get();
				double ret = log(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "log10") {
				get();
				double ret = log10(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "log2") {
				get();
				double ret = log10(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "sqrt") {
				get();
				double ret = sqrt(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "pow") {
				get();
				double num1 = expression();
				if(get() != ',') {
					//std::cout<<__LINE__<<std::endl;
				}
				double num2 = expression();
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return pow(num1, num2);
			} else if(func == "sin") {
				get();
				double ret = sin(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "cos") {
				get();
				double ret = cos(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "tan") {
				get();
				double ret = tan(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "asin") {
				get();
				double ret = asin(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "acos") {
				get();
				double ret = acos(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "atan") {
				get();
				double ret = atan(expression());
				if(get() != ')') {
					//std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else {
				return var[func];
			}
		}
		return T.init; // error
	}
	
	double term() {
		while(isWhite(peek())) {
			get();
		}
		double result = factor();
		//writeln(__LINE__, " ", result);
		while (peek() == '*' || peek() == '/') {
			if(get() == '*') {
				result *= factor();
			} else {
				result /= factor();
			}
		}
		return result;
	}
	
	double expression() {
		while(isWhite(peek())) {
			get();
		}
		double result = term();
		while(peek() == '+' || peek() == '-') {
			if(get() == '+') {
				result += term();
			} else {
				result -= term();
			}
		}
		return result;
	}
}

unittest {
	auto c = calc!(double)("5.3+5*2.5");
	assert(c.expression() == 17.8);
	{
		double[string] vars;
		vars["hello"] = 1.234;
		auto c3 = calc!double("hello", vars);
		assert(c3.expression() == 1.234);
	}
	{
		double[string] vars;
		vars["hello"] = 1.234;
		auto c3 = calc!double("hello * 2.0", vars);
		assert(c3.expression() == 2.468);
	}
	{
		double[string] vars;
		vars["hello"] = 1.234;
		auto c3 = calc!double("clamp(1.0, hello * 0.5, 4.0)", vars);
		double rs = c3.expression();
		assert(rs == 1.0, to!string(rs));
	}
	{
		double[string] vars;
		vars["hello"] = 1.234;
		vars["foo"] = 1337;
		calc!double c3 = 
			calc!double("foo * clamp(1.0, hello * 2.0, 4.0)", vars);
		double rs = c3.expression();
		assert(rs == 3299.71600, to!string(rs));
	}
	for(int i = 0; i < 10; i++) {
		double rs = calculate!double("rand(0.0, 1.0)");
		assert(rs >= 0.0 && rs <= 1.0, to!string(rs));
	}
	for(int i = 0; i < 10; i++) {
		double rs = calculate!double("srand(0.0, 1.0)");
		assert(rs >= 0.0 && rs <= 1.0, to!string(rs));
	}
	for(int i = 0; i < 10; i++) {
		double rs = calculate!double("srand(0.8, 1.0)");
		assert(rs >= 0.8 && rs <= 1.0, to!string(rs));
	}
}

T calculate(T = double)(string expr) {
	T[string] map;
	calc!(T) c = calc!(T)(expr, map);
	return c.expression();
}

T calculate(T)(string expr, T[string] map) if(isNumeric!T) {
	calc!(T) c = calc!(T)(expr, map);
	return c.expression();
}

/*double calculate(string expr) {
	calc c(expr);
	return c.expression();
}*/

unittest {
	double[string] values;
	values["foo"] = 2.0;
	values["bar"] = 4.0;
	double r = calculate!double("foo * bar", values);
	assert(r == 8.0, to!string(r));
}

void main() {
}
