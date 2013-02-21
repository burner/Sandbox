module window;

import std.conv;
import std.string;
import std.exception;

import opengl.glfw;
//import opengl.glfuncs;
//import opengl.gltypes;
import opengl.gl;
import slog;

import gl3n.linalg;

struct Window {
	int width, height;	
	float fov;
	float near, far;
	double oldTime;
	int frames = 0;

	// fps counter stuff
	double fps, time, t0;

	// projection
	mat4 proj;

	public void init() {
		this.width = 800;
		this.height = 640;
		this.fov = 45.0f;
		this.near = 0.01f;
		this.far = 10000.0f;

		this.calcProjectionMatrix();

		if(glfwOpenWindow(this.width, this.height, 5, 6, 5,
					0, 0, 0, GLFW_WINDOW) != 1) {
			throw new Exception("glfwOoenWindow failed");
		}

		glfwGetWindowSize(&(this.width), &(this.height));

		glfwOpenWindowHint(GLFW_FSAA_SAMPLES, 4);
		glfwOpenWindowHint(GLFW_OPENGL_VERSION_MAJOR, 4);
		glfwOpenWindowHint(GLFW_OPENGL_VERSION_MINOR, 3);
		glfwOpenWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
		glfwSwapInterval(1);

		const(char)* ver = cast(const(char)*)glGetString(GL_VERSION);
		slog.log("%s", to!string(ver));
 		oldTime = glfwGetTime();
	}

	private void calcProjectionMatrix() {
		this.proj = mat4.perspective(this.width, this.height, this.fov, this.near, this.far);
		log("%s", this.proj);
	}

	mat4 getProjMatrix() const {
		return this.proj;
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

	void setWidth(int w) {
		this.width = w;
		this.calcProjectionMatrix();
	}

	void setHeight(int h) {
		this.height = h;
		this.calcProjectionMatrix();
	}
}
