import rules;
import ast;

import hurt.container.deque;

void main() {
	Ast ast = new Ast();
	Deque!(int) stack = new Deque!(int)([1,2,3,4,5,6,7,8]);
	mixin(rules.r0);
	stack.popBack(3);
	mixin(rules.r1);
	stack.popBack(2);
}
