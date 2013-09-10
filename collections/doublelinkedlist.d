module doublelinkedlist;

import models.list;

import std.stdio;

class DoubleLinkedList(E) : List!(E,DoubleLinkedList!E) {
	void insertFrontImpl(E e) {
		writeln(e);
	}	
	void insertBackImpl(E e) {
		writeln(e);
	}	

	void emplaceFrontImpl(E e) {
		writeln(e);
	}	
	void emplaceBackImpl(E e) {
		writeln(e);
	}	

	DoubleLinkedList!E removeFront(size_t cnt) {
		writeln(cnt);
		return this;
	}	
	DoubleLinkedList!E removeBack(size_t cnt) {
		writeln(cnt);
		return this;
	}

	size_t length() const { return 0; }
	bool empty() const { return true; }

	ref inout(E) back() inout { assert(false); }
	ref inout(E) front() inout { assert(false); }
}

unittest {
	auto dll = new DoubleLinkedList!int();
	dll.insertFront(10).removeFront(6);
	dll.removeBack(7);
	dll.emplaceBack(8);
}
