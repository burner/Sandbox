all:
	dmd -c -m64 main.d
	gcc main.o -o glfwtest -lglfw -lGL -lpthread -lphobos2 -march64 /lib/librt.so.1
