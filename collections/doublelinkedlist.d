module doublelinkedlist;

import sequence.removefront;
import sequence.removeback;
import sequence.insertfront;
import sequence.insertback;

import std.stdio;

class DoubleLinkedList(E) : InsertBack!E, InsertFront!E, RemoveBack!E,
		RemoveFront!E {
	void insertFrontImpl(E e) {
		writeln(e);
	}	
	void insertBackImpl(E e) {
		writeln(e);
	}	
	void removeFront(size_t cnt) {
		writeln(cnt);
	}	
	void removeBack(size_t cnt) {
		writeln(cnt);
	}	

	DoubleLinkedList!(E) returnThis() {
		return this;
	}
}

unittest {
	auto dll = new DoubleLinkedList!int();
	dll.insertFront(10);
	dll.removeBack(7);
}
