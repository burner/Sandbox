import std.stdio;
import std.algorithm;
import std.math;

extern(C) {
void polynomialfit(int obs, int degree, double *dx, double *dy, double *store); /* n, p */
}

double[] polyfit(double[] dx, double[] dy, int degree) {
	assert(dx.length == dy.length);
	double[] rslt = new double[dx.length];

	polynomialfit(dx.length, degree, dx.ptr, dy.ptr, rslt.ptr);

	ptrdiff_t idx = rslt.countUntil!(std.math.isNaN)();
	return rslt[0 .. idx == -1 ? $ : idx];
}

void main() {
	double x[] = [0,  1,  2,  3,  4,  5,  6,   7,   8,   9,   10];
	double y[] = [1,  6,  17, 2, 57, 86, 121, 162, 209, 262, 321];

	double[] f = polyfit(x,y,7);

	writeln(f);
}
