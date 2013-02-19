import std.conv;
import std.stdio;
import std.stdio;
import std.string;

import opengl.glfuncs;
import opengl.glfw;
import opengl.gltypes;

import window;
import slog;
import shader;

Window win;

GLuint s;
GLuint vertexbuffer;

int main() {
	if(glfwInit() != 1) {
		log("glfwInit failed");
		return 0;
	}

	win.init();

	s = loadShader("shader/SimpleVertexShader.vertexshader", 
		"shader/SimpleFragmentShader.fragmentshader");

	static const GLfloat[9] g_vertex_buffer_data = [ 
		-1.0f, -1.0f, 0.0f,
		 1.0f, -1.0f, 0.0f,
		 0.0f,  1.0f, 0.0f,
	];

	glGenBuffers(1, &vertexbuffer);
	glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
	glBufferData(GL_ARRAY_BUFFER, g_vertex_buffer_data.sizeof, g_vertex_buffer_data, GL_STATIC_DRAW);

	mainLoop();
	glfwTerminate();
	return 0;
}

void mainLoop() {
	while(true) {
		win.updateWindowFrameTitle();
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		glUseProgram(s);

		// 1rst attribute buffer : vertices
		glEnableVertexAttribArray(0);
		glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
		glVertexAttribPointer(
			0,         // attribute 0. No particular reason for 0, but must match the layout in the shader.
			3,         // size
			GL_FLOAT,  // type
			GL_FALSE,  // normalized?
			0,         // stride
			cast(void*)0   // array buffer offset
		);

		// Draw the triangle !
		glDrawArrays(GL_TRIANGLES, 0, 3); // From index 0 to 3 -> 1 triangle

		glDisableVertexAttribArray(0);

		if(glfwGetKey(GLFW_KEY_ESC) == GLFW_PRESS) {
			break;
		}
 
		glfwSwapBuffers();
	}
}
