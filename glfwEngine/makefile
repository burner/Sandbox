all:
	scons -j4

getlibs:
	git clone https://github.com/Dav1dde/gl3n.git
	cd gl3n && make	

clean:
	scons --clean

run: all
	optirun ./glfwtest

