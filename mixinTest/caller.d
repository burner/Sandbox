import rules;
import ast;

import hurt.container.deque;
import hurt.string.formatter;

void main() {
	Ast ast = new Ast();
	Deque!(int) stack = new Deque!(int)([1,2,3,4,5,6,7,8]);
	void delegate(size_t) choice = delegate void(size_t idx) { 
			mixin(rules.ruleChoice);
		};
	
	choice(0);
	stack.popBack(3);
	choice(1);
	stack.popBack(2);
}
