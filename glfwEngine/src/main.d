import glfw;

import std.stdio;
import glfuncs;
import gltypes;
import std.stdio;
import std.string;
import std.conv;

float rotate_y = 0,
		rotate_z = 0;
const float rotations_per_tick = .2;

int main() {
	if(glfwInit() != 1) {
		writeln("glfwInit failed");
		return 0;
	}
	writeln("glfwInit worked");

	int window_width = 800,
			window_height = 600;

	// 800 x 600, 16 bit color, no depth, alpha or stencil buffers, windowed
	if(glfwOpenWindow(window_width, window_height, 5, 6, 5,
				0, 0, 0, GLFW_WINDOW) != 1) {
		writeln("glfwOoenWindow failed");
		return 0;
	}
	glfwGetWindowSize(&window_width, &window_height);
	glfwSetWindowSize(window_width, window_height);
	const(char)* ver = glGetString(GL_VERSION);
	writeln(to!string(ver));
	glfwSwapInterval(0);
	glfwSetWindowTitle("The GLFW Window");
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	float aspect_ratio = (cast(float)window_height) / window_width;
	glFrustum(.5, -.5, -.5 * aspect_ratio, .5 * aspect_ratio, 1, 50);
	glMatrixMode(GL_MODELVIEW);
	// set the projection matrix to a normal frustum with a max depth of 50
	Main_Loop();
	glfwTerminate();
	return 1;
}

void Main_Loop() {
	// the time of the previous frame
	double old_time = glfwGetTime();
	int frames = 0;
	double fps, time, t0;
	// this just loops as long as the program runs
	while(1) {
        time = glfwGetTime();

		// Calcul and display the FPS
        if((time-t0) > 1.0 || frames == 0) {
            fps = cast(double)frames / (time-t0);
            glfwSetWindowTitle(toStringz(to!string(fps)));
            t0 = time;
            frames = 0;
        }
        frames ++;

		// calculate time elapsed, and the amount by which stuff rotates
		double current_time = glfwGetTime(),
			 delta_rotate = (current_time - old_time) * rotations_per_tick 
			 * 360;
		old_time = current_time;
		// escape to quit, arrow keys to rotate view
		if (glfwGetKey(GLFW_KEY_ESC) == GLFW_PRESS)
			break;
		if (glfwGetKey(GLFW_KEY_LEFT) == GLFW_PRESS)
			rotate_y += delta_rotate;
		if (glfwGetKey(GLFW_KEY_RIGHT) == GLFW_PRESS)
			rotate_y -= delta_rotate;
		// z axis always rotates
		rotate_z += delta_rotate;
 
		// clear the buffer
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		// draw the figure
		Draw();
		// swap back and front buffers
		glfwSwapBuffers();
	}
}

void Draw_Square(float red, float green, float blue) {
	// Draws a square with a gradient color at coordinates 0, 10
	glBegin(GL_QUADS); {
	glColor3f(red, green, blue);
	glVertex2i(1, 11);
	glColor3f(red * .8, green * .8, blue * .8);
	glVertex2i(-1, 11);
	glColor3f(red * .5, green * .5, blue * .5);
	glVertex2i(-1, 9);
	glColor3f(red * .8, green * .8, blue * .8);
	glVertex2i(1, 9);
	}
	glEnd();
}
 
void Draw() {
	// reset view matrix
	glLoadIdentity();
	// move view back a bit
	glTranslatef(0, 0, -30);
	// apply the current rotation
	glRotatef(rotate_y, 0, 1, 0);
	glRotatef(rotate_z, 0, 0, 1);
	// by repeatedly rotating the view matrix during drawing, the
	// squares end up in a circle
	int i = 0, squares = 15;
	float red = 0, blue = 1;
	for (; i < squares; ++i){
		glRotatef(360.0/squares, 0, 0, 1);
		// colors change for each square
		red += 1.0/12;
		blue -= 1.0/12;
		Draw_Square(red, .6, blue);
	}
}
