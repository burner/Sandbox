module calc;

import std.ascii;

struct calc(T) {
	string str;
	size_t pos;
	T[string] var;

	calc(string s) : str(s), pos(0) {}
	calc(string s, T[string] v) : str(s), pos(0),
		var(v) {}

	char peek() {
		//return *expressionToParse;
		if(pos >= str.size()) {
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
		//return *expressionToParse++;
		if(pos >= str.size()) {
			throw string("Out of bound");
		}
		char ret = str[pos++];
		while(isWhite(str[pos])) {
			pos++;
		}
		return ret;
	}
	
	double number() {
		while(isWhite(peek())) {
			get();
		}
		stringstream tmp;
		//int result = get() - '0';
		tmp<<get();
		while ((peek() >= '0' && peek() <= '9') || peek() == '.') {
			tmp<<get();
		}
		double ret;
		tmp>>ret;
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
		} else if(peek() >= 'a' && peek() <= 'z') {
			stringstream tmp;
			while(peek() >= 'a' && peek() <= 'z') {
				tmp<<get();
			}
			/*if(peek() == '(') {
				get();
			}*/	
			string func = tmp.str();
			if(func == "abs") {
				get();
				double ret = fabs(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "exp") {
				get();
				double ret = exp(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "exp2") {
				get();
				double ret = exp2(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "log") {
				get();
				double ret = log(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "log10") {
				get();
				double ret = log10(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "log2") {
				get();
				double ret = log10(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "sqrt") {
				get();
				double ret = sqrt(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "mod") {
				get();
				double num1 = expression();
				if(get() != ',') {
					std::cout<<__LINE__<<std::endl;
				}
				double num2 = expression();
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return fmod(num1, num2);
			} else if(func == "srand") {
				get();
				double num1 = expression();
				if(get() != ',') {
					std::cout<<__LINE__<<std::endl;
				}
				double num2 = expression();
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				std::default_random_engine
					generator(std::chrono::system_clock::now().time_since_epoch().count());
				std::uniform_real_distribution<double> distribution(num1,num2);
				return distribution(generator);
			} else if(func == "rand") {
				get();
				double num1 = expression();
				if(get() != ',') {
					std::cout<<__LINE__<<std::endl;
				}
				double num2 = expression();
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				std::default_random_engine generator;
				std::uniform_real_distribution<double> distribution(num1,num2);
				return distribution(generator);
			} else if(func == "pow") {
				get();
				double num1 = expression();
				if(get() != ',') {
					std::cout<<__LINE__<<std::endl;
				}
				double num2 = expression();
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return pow(num1, num2);
			} else if(func == "sin") {
				get();
				double ret = sin(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "cos") {
				get();
				double ret = cos(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "tan") {
				get();
				double ret = tan(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "asin") {
				get();
				double ret = asin(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "acos") {
				get();
				double ret = acos(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "atan") {
				get();
				double ret = atan(expression());
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return ret;
			} else if(func == "clamp") {
				get();
				double num1 = expression();
				if(get() != ',') {
					std::cout<<__LINE__<<std::endl;
				}
				double num2 = expression();
				if(get() != ',') {
					std::cout<<__LINE__<<std::endl;
				}
				double num3 = expression();
				if(get() != ')') {
					std::cout<<__LINE__<<std::endl;
				}
				return clamp(num1,num2,num3);
			} else {
				T[string]::iterator it = var.find(func);
				if(it != var.end()) {
					return it->second;
				}
			}
		}
		return std::numeric_limits<double>::signaling_NaN(); // error
	}
	
	double term() {
		while(isWhite(peek())) {
			get();
		}
		double result = factor();
		while (peek() == '*' || peek() == '/')
			if (get() == '*')
				result *= factor();
			else
				result /= factor();
		return result;
	}
	
	double expression() {
		while(isWhite(peek())) {
			get();
		}
		double result = term();
		while (peek() == '+' || peek() == '-')
			if (get() == '+')
				result += term();
			else
				result -= term();
		return result;
	}
};

/*UNITTEST(calcTest) {
	calc c("5.3+5*2.5");
	AS_EQ(c.expression(), 17.8);
	//calc c2("5.3+5 *sin(2.5)");
	//AS_EQ(c2.expression(), 8.29236);
	{
		T[string] vars;
		vars["hello"] = 1.234;
		calc c3("hello", vars);
		AS_EQ(c3.expression(), 1.234);
	}
	{
		T[string] vars;
		vars["hello"] = 1.234;
		calc c3("hello * 2.0", vars);
		AS_EQ(c3.expression(), 2.468);
	}
	{
		T[string] vars;
		vars["hello"] = 1.234;
		calc c3("clamp(1.0, hello * 0.5, 4.0)", vars);
		AS_EQ(c3.expression(), 1.0);
	}
	{
		T[string] vars;
		vars["hello"] = 1.234;
		vars["foo"] = 1337;
		calc c3("foo * clamp(1.0, hello * 2.0, 4.0)", vars);
		AS_EQ(c3.expression(), 3299.71600);
	}
	for(int i = 0; i < 10; i++) {
		double rs = calculate("rand(0.0, 1.0)");
		AS_T(rs >= 0.0 && rs <= 1.0);
	}
	for(int i = 0; i < 10; i++) {
		double rs = calculate("srand(0.0, 1.0)");
		AS_T(rs >= 0.0 && rs <= 1.0);
	}
	for(int i = 0; i < 10; i++) {
		double rs = calculate("srand(0.8, 1.0)");
		AS_T(rs >= 0.8 && rs <= 1.0);
	}
}*/

double calculate(string expr) {
	calc c(expr);
	return c.expression();
}

double calculate(string expr, T[string] map) {
	calc c(expr, map);
	return c.expression();
}
