import hurt.io.stdio;
import hurt.conv.conv;
import hurt.util.slog;

extern(C) {
	void initSocket(ushort);
	int readSocket(void*,int);	
	int writeSocket(void*,int);	
	void closeSocket();
}

void main() {
	initSocket(1337);
	log();
	char[] buf = new char[128];
	auto n = readSocket(cast(void*)buf.ptr, 
		conv!(size_t,int)(buf.length*char.sizeof));
	printfln("%s", buf[0 .. n].idup);
	string anwser = "Got your message";
	n = writeSocket(cast(void*)anwser.ptr, conv!(size_t,int)(anwser.length*char.sizeof));
	printfln("wrote %d bytes", n);
	closeSocket();
}
