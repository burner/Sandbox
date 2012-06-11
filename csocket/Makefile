SRC=serverctrl.d

all:
	gcc -c server.c -o server.o
	dmd -debug -gc -m64 -w -unittest -version=staging $(SRC) -I. ../../libhurt/libhurt.a -I../../libhurt server.o -ofserverctrl
	gcc -c client.c -o client.o
	dmd -debug -gc -m64 -w -unittest -version=staging clientctrl.d -I. ../../libhurt/libhurt.a -I../../libhurt client.o -ofclientctrl
