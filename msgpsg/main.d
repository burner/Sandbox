import core.thread;
import std.concurrency;

import hurt.string.formatter;
import hurt.io.stdio;

class Breaks : Thread {
	Tid toSendTo;
	this(Tid tid) {
		super(&run);
		toSendTo = tid;
	}

	void run() {
		for(int i = 0; i < 1000; i++) {
			if(i == 875) {
				send(this.toSendTo, format("stuff broke at %s:%d", __FILE__, __LINE__));
			}
		}
	}
}

void main() {
	Breaks b = new Breaks(thisTid);
	b.start();

	receive(
		(string s) { printfln("received a %s", s); },
	);
}
