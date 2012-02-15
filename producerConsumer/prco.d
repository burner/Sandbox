import core.sync.semaphore;
import core.thread;
import std.concurrency;
import hurt.container.deque;
import hurt.util.random.random;
import hurt.util.slog;

immutable size_t max = 10;
__gshared Deque!(int) buffer;
__gshared Semaphore mutex;
__gshared Semaphore empty;

void main() {
	mutex = new Semaphore(1);
	empty = new Semaphore(0);
	assert(mutex !is null);
	buffer = new Deque!(int)(10);
	spawn(&producer, thisTid);
	spawn(&consumer, thisTid);
	receiveOnly!(int);
	receiveOnly!(int);
	log();
}

void consumer(Tid m) {
	Deque!(int) local = new Deque!(int)();
	Random r = new Random();
	assert(r !is null);
	int i = 0;
	outer: while(true) {
		mutex.wait();
		log("%d %u %u",i++, buffer.getSize(), local.getSize());
		if(buffer.isEmpty()) {
			mutex.notify();
			empty.wait();
		} else {
			while(!buffer.isEmpty()) {
				int tmp = buffer.popFront();
				if(tmp == int.min) {
					break outer;
				} else {
					local.pushBack(tmp);
				}
			}
			mutex.notify();
		}
		uint time = r.uniform!(uint)() % 20;
		Thread.sleep(dur!("msecs")(time));
	}
	send(m, -1);
}

void producer(Tid m) {
	Random r = new Random();
	assert(r !is null);
	for(int i = 0; i < 1000; i++) {
		log("%d",i);
		mutex.wait();
		buffer.pushBack(r.uniform!(int)());
		if(buffer.getSize() > 5) {
			empty.notify();
		}
		mutex.notify();
		uint time = r.uniform!(uint)() % 50;
		Thread.sleep(dur!("msecs")(time));
	}
	mutex.wait();
	buffer.pushBack(int.min);
	mutex.notify();
	empty.notify();
	send(m, -1);
}
