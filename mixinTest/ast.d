module ast;

import hurt.io.stdio;

class Ast {
	public void production0(int a, int b, int c) {
		printfln("production0 %d %d %d", a, b, c);	
	}

	public void production1(int a, int b) {
		printfln("production1 %d %d", a, b);	
	}
}
