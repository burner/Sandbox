all:
	dmd -c -m64 main.d gltypes.d glfuncs.d
	gcc main.o -o glfwtest -lglfw -lGL -lpthread -lphobos2 -march64 /lib/librt.so.1
