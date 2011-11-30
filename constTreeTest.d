import hurt.io.stdio;

class Node {
	int value;
	Node left, right, parent;

	this(int value, Node parent) {
		this.parent = parent;
		this.value = value;
	}

	ConstIterator begin() {
		return new ConstIterator(this);
	}

	int getValue() const {
		return this.value;
	}

	void insert(int value) {
		if(value > this.value && this.right !is null) {
			this.right.insert(value);
		} else if(value > this.value && this.right is null) {
			this.right = new Node(value, this);
		} else if(value < this.value && this.right !is null) {
			this.left.insert(value);
		} else if(value < this.value && this.right is null) {
			this.left = new Node(value, this);
		}
	}
}

class ConstIterator {
	Node ptr;

	this(Node ptr) {
		this.ptr = ptr;
	}

	const(Node) getValue() {
		return this.ptr;
	}

	void increment() {
		Node y;
		if(null !is (y = this.ptr.right)) {
			while(y.left !is null) {
				y = y.left;
			}
			this.ptr = y;
		} else {
			y = this.ptr.parent;
			while(y !is null && this.ptr is y.right) {
				this.ptr = y;
				y = y.parent;
			}
			this.ptr = y;
		}
	}	

	void decrement() {
		Node y;
		if(null !is (y = this.ptr.left)) {
			while(y.right !is null) {
				y = y.right;
			}
			this.ptr = y;
		} else {
			y = this.ptr.parent;
			while(y !is null && this.ptr is y.left) {
				this.ptr = y;
				y = y.parent;
			}
			this.ptr = y;
		}
	}

	bool isValid() const {
		return this.ptr !is null;
	}
}

void main() {
	Node r = new Node(10, null);
	for(int i = 0; i < 20; i+=2) {
		r.insert(i);
	}
	ConstIterator it = r.begin();
	while(it.isValid()) {
		const(Node) n = it.getValue();
		println(n.getValue());
		it.increment();
	}
}
