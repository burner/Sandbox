all:
	dmd -L../../libhurt/libhurt.a -m64 *.d -ofcaller -I../../libhurt/ -deps=dep
	./caller
