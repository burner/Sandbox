module funcs;

extern(C) string getSome() {
	return "GotSome";
}

extern(C) int addFive(int z) {
	return z + 5;
}
