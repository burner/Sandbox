import hurt.io.stdio;
import hurt.conv.conv;
import hurt.string.stringutil;
import hurt.util.slog;

extern(C) {
	void initSocketForSending(char*, ushort);
	int writeSocketForSending(void*, int);
	int readSocketForSending(void*, int);
	void closeSocketForSending();
}

void main() {
	initSocketForSending(
		cast(char*)toStringz("localhost"), 
		conv!(int,ushort)(1337) );

	log();
	string msg = "Hello from the client";
	int wrs = writeSocketForSending(cast(void*)msg.ptr, conv!(size_t,int)(
		msg.length * char.sizeof));
	log();
	
	char[] anwser = new char[128];
	log();
	int rrs = readSocketForSending(cast(void*)anwser.ptr, 128);
	//int rrs = readSocketForSending(cast(void*)msg.ptr, conv!(size_t,int)(
	//	anwser.length * char.sizeof));

	printfln("%s", anwser[0 .. rrs].idup);
	closeSocketForSending();
}
