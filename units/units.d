import std.string;
import std.stdio;

enum BaseUnit {
	length,
	mass,
	time,
	electric_current,
	themodynamic_temperature,
	amount_of_substance,
	luminous_intensity
}

string constructorMulDivMixin(string T, string S) {
	immutable string str =
"this(%s t, %s s) {
	this.a = a;
	this.b = b;
}

this(const ref typeof(this) o) {
	this.a = o.a;
	this.b = o.b;
}";
	return format(str, T, S);
}

string constructorMixin(string T) {
	immutable string str =
"this(%s value) {
	this.value = value;
}

this(const ref typeof(this) o) {
	this.value = o.value;
}";
	return format(str, T);
}

string additionBinaryOpMulOrDivMixin() {
	immutable string str =
"typeof(this) opBinary(string op)(const typeof(this) rhs) if(op == \"+\" || op == \"-\") {
	static if(op == \"+\") return typeof(this)(this.a + rhs.a, this.b + rhs.b);
	else static if(op == \"-\") return typeof(this)(this.a - rhs.a, this.b - rhs.b);
	else static assert(false);
}" ~

"typeof(this) opBinary(string op, U)(const U rhs) if(op == \"*\" || op == \"/\") {
	static if(op == \"*\") return MulDiv!(MulOrDiv.Mul)(this)(this, rhs);
	else static if(op == \"/\") return MulDiv!(MulOrDiv.Div)(this)(this, rhs);
	else static assert(false);
}";
	return str;
}

string additionBinaryOpMixin() {
	immutable string str =
"typeof(this) opBinary(string op)(const typeof(this) rhs) if(op == \"+\" || op == \"-\") {
	static if(op == \"+\") return typeof(this)(this.value + rhs.value);
	else static if(op == \"-\") return typeof(this)(this.value - rhs.value);
	else static assert(false);
}" ~

/*"Power!(typeof(this),2) opBinary(string op)(const typeof(this) rhs) if(op == \"*\") {
	static if(op == \"*\") return Power!(typeof(this), 2)(this.value * rhs.value);
	else static assert(false);
}" ~ */

"typeof(this) opBinary(string op, U)(const U rhs) if(op == \"*\" || op == \"/\") {
	static if(op == \"*\") return MulDiv!(MulOrDiv.Mul)(this)(this.value, rhs.value);
	else static if(op == \"/\") return MulDiv!(MulOrDiv.Div)(this)(this.value, rhs.value);
	else static assert(false);
}";
	return str;
}

immutable string equalMixin = "
public pure bool opEquals(const typeof(this) o) const @safe nothrow {
	return this.value == o.value;
}";

immutable string equalMixinMulOrDiv = "
public pure bool opEquals(const typeof(this) o) const @safe nothrow {
	return this.a == o.a && this.b == o.b;
}";

string createUnitMixin(string T) {
	return constructorMixin(T) ~ additionBinaryOpMixin() ~ equalMixin;
}

string createMulDivMixin(string T, string S) {
	return constructorMulDivMixin(T, S) ~ additionBinaryOpMulOrDivMixin() ~
		equalMixinMulOrDiv;
}

struct Unit(BaseUnit bu, T) {
	BaseUnit b;
	T value;

#line 1000
	mixin(createUnitMixin(T.stringof));
#line 101
}

enum MulOrDiv {
	Mul,
	Div
}

struct MulDiv(MulOrDiv mod, T,S) {
	T a;
	S b;

#line 2000
	mixin(createMulDivMixin(T.stringof, S.stringof));
#line 115
}

struct Power(T, real power) {
	T value;
#line 3000
	mixin(createUnitMixin(T.stringof));
#line 122
}


alias Unit!(BaseUnit.length, real) Meter;
alias Unit!(BaseUnit.mass, real) Kilogram;
alias Unit!(BaseUnit.time, real) Second;
alias Unit!(BaseUnit.electric_current, real) Ampere;
alias Unit!(BaseUnit.themodynamic_temperature, real) Kelvin;
alias Unit!(BaseUnit.amount_of_substance, real) Mole;
alias Unit!(BaseUnit.luminous_intensity, real) Candela;

alias MulDiv!(MulOrDiv.Div, Meter, Second) MeterPerSecond;
alias Power!(Meter, 2) SquareMeter;

unittest {
	Meter m = Meter(5) + Meter(7);
	assert(m  == Meter(12));
	writeln(m);
}

unittest {
	SquareMeter sm;
	assert(sm.power == 2);
}
