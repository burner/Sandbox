module calc;

import std.ascii;
import std.array;
import std.stdio;
import std.conv;
import std.math;
import std.traits;
import std.string;

string constructEval(string name, ulong argc) {
	auto app = appender!string();
	app.put("\tif(func == "); app.put(name); app.put(") {\n");	
	app.put(format("\t\tT[%uu] var;\n", argc));
	app.put("\t\teatWhiteSpace();\n");
	app.put("\t\tget('(');\n");
	app.put(format("\t\tfor(size_t i = 0; i < %u; ++i) {\n", argc));
	app.put("\t\t\tvar[i] = expression();\n");
	app.put("\t\t\teatWhiteSpace();\n");
	app.put(format("\t\t\ti+1 == %u ? get(')') : get(',');\n", argc));
	app.put("\t\t}\n");
	app.put(format("\t\treturn %s(", name));
	for(size_t i = 0; i < argc; ++i) {
		app.put(format("var[%u]", i));
		app.put(i+1 == argc ? ");\n" : ",");
	}
	app.put("\t}\n");
	return app.data();
}

static immutable(string[][]) functions = [
	// zero arguments
	[],
	// one argument
	[ "cos", "sin", "tan", "acos", "asin", "atan", "atan2", 
	"sinh", "cosh", "tanh", "asinh", "acosh", "atanh",
   	"abs", "rndtonl", "sqrt", "expm1", "exp2", "expi", "frexp",
	"ilogb", "ldexp", "log", "log10", "log1p", "log2", "logb",
	"cbrt", "fabs", "ceil", "floor", "nearbyint", "rint", "lrint", 
	"round", "lround", "trunc", "isNaN", "isFinite", "isNormal", 
	"isSubnormal", "isInfinity", "signbit", "sgn", "NaN", "getNaNPayload",
	"nextUp", "nextDown"],

	// two arguments
	["fmod", "modf", "scalbn", "hypot", "remainder", "isIdentical",
	"copysign", "nextafter", "fdim", "fmax", "fmin", "fma", "pow", "feqrel",
	"poly", "approxEqual"],
	
	// three arguments
	["remquo"],

	["approxEqual"]
];

string constructAllAvailable() {
	auto app = appender!string();
	foreach(idx, level; functions)  {
		foreach(name; level) {
			app.put(constructEval(name, idx));
		}
	}
	return app.data();
}

unittest {
	writeln(constructEval("foo", 5));
}

//unittest {
	pragma(msg, constructAllAvailable());
//}

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

	void eatWhiteSpace() {
		while(isWhite(peek())) {
			get();
		}
	}
	
	char get(char excepted = '\0', string file = __FILE__, 
			int line = __LINE__) {
		if(pos >= str.length) {
			throw new Exception("Out of bound");
		}
		char ret = str[pos++];
		while(pos < str.length && isWhite(str[pos])) {
			pos++;
		}

		if(excepted != '\0' && ret != excepted) {
			throw new Exception(format(
				"Excepted a '%c' but found a '%c' at position %u",
				excepted, ret, pos), file, line);
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
			get('('); // '('
			double result = expression();
			get(')'); // ')'
			return result;
		} else if(peek() == '-') {
			get('-');
			return -expression();
		} else if(peek() == '+') {
			get('+');
			return expression();
		} else if((peek() >= 'a' && peek() <= 'z') || 
				(peek() >= 'A' && peek <= 'Z')) {
			size_t startPos = pos;
			while((peek() >= 'a' && peek() <= 'z') || 
					(peek() >= 'A' && peek <= 'Z')) {
				get();
			}

			string func = str[startPos .. pos - (peek() == '\0' ? 0 : 1)];
			mixin(constructAllAvailable());
			return var[func];
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
		assert(approxEqual(calculate!double("sqrt(4)"), 2.0));
	}
	/*{
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
	}*/
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
