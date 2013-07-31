all: polyfitc polyfitd
	dmd *.o -L/usr/lib/libgsl.so -L/usr/lib/libgslcblas.so -ofpolyfit
	./polyfit

polyfitc: polyfitc.c
	gcc -c polyfitc.c

polyfitd: polyfit.d
	dmd -c polyfit.d -unittest -debug
