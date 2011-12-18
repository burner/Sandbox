import glfw;

import std.stdio;

int main() {
	if(glfwInit() != 1) {
		writeln("glfwInit failed");
		return 0;
	}
	writeln("glfwInit worked");

	const int window_width = 800,
		  window_height = 600;

	// 800 x 600, 16 bit color, no depth, alpha or stencil buffers, windowed
	if(glfwOpenWindow(window_width, window_height, 5, 6, 5,
				0, 0, 0, GLFW_WINDOW) != 1) {
		writeln("glfwOoenWindow failed");
		return 0;
	}
	glfwSetWindowTitle("The GLFW Window");
  // set the projection matrix to a normal frustum with a max depth of 50
	while(true) {
		// calculate time elapsed, and the amount by which stuff rotates
		// escape to quit, arrow keys to rotate view
		if (glfwGetKey(GLFW_KEY_ESC) == GLFW_PRESS)
			break;
		writeln(glfwGetKey(GLFW_KEY_SPACE) == GLFW_PRESS);
    	glfwSwapBuffers();
	}
	glfwTerminate();
	return 1;
}
