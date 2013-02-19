module window;

import std.conv;
import std.string;
import std.exception;

import opengl.glfuncs;
import opengl.glfw;
import opengl.gltypes;
import slog;

struct Window {
	int width, height;	
	double oldTime;
	int frames = 0;
	double fps, time, t0;

	public void init() {
		this.width = 800;
		this.height = 640;

		if(glfwOpenWindow(this.width, this.height, 5, 6, 5,
					0, 0, 0, GLFW_WINDOW) != 1) {
			throw new Exception("glfwOoenWindow failed");
		}

		glfwOpenWindowHint(GLFW_FSAA_SAMPLES, 4);
		glfwOpenWindowHint(GLFW_OPENGL_VERSION_MAJOR, 4);
		glfwOpenWindowHint(GLFW_OPENGL_VERSION_MINOR, 3);
		glfwOpenWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
		glfwSwapInterval(1);

		const(char)* ver = glGetString(GL_VERSION);
		log("%s", to!string(ver));
 		oldTime = glfwGetTime();
	}

	public void updateWindowFrameTitle() {
        time = glfwGetTime();

		// Calculate and display the FPS
        if((time-t0) > 1.0 || frames == 0) {
            fps = cast(double)frames / (time-t0);
            glfwSetWindowTitle(toStringz(to!string(fps)));
            t0 = time;
            frames = 0;
        }
        frames++;

		double current_time = glfwGetTime();
		this.oldTime = current_time;
	}

	int getWidth() const {
		return this.width;
	}

	int getHeight() const {
		return this.height;
	}
}
