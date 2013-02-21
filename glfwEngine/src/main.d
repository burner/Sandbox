import core.memory;

import std.conv;
import std.stdio;
import std.stdio;
import std.string;

import opengl.gl;
//import opengl.glfuncs;
import opengl.glfw;
//import opengl.gltypes;

import gl3n.linalg;

import window;
import slog;
import shader;
import camera;
import objloader;

Window win;
Camera cam;

GLuint s;
GLuint vertexbuffer;
Mesh m;		

extern(C) void windowResizeCallback(int width, int height) {
	log("window resize to width %d and height %d", width, height);
	win.setWidth(width);	
	win.setHeight(height);	
}

int main() {
	GC.disable();
	if(glfwInit() != 1) {
		log("glfwInit failed");
		return 0;
	}
	glfwSetWindowSizeCallback(&windowResizeCallback);

	m.loadObjFile("models/box.obj");

	win.init();
	cam.init();

	s = loadShader("shader/TransformVertexShader.vertexshader", 
		"shader/TextureFragmentShader.fragmentshader");

	/*static const GLfloat[9] g_vertex_buffer_data = [ 
		-1.0f, -1.0f, 0.0f,
		 1.0f, -1.0f, 0.0f,
		 0.0f,  1.0f, 0.0f,
	];

	glGenBuffers(1, &vertexbuffer);
	glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
	glBufferData(GL_ARRAY_BUFFER, g_vertex_buffer_data.sizeof,
	g_vertex_buffer_data, GL_STATIC_DRAW);*/

	mainLoop();
	glfwTerminate();
	return 0;
}

void mainLoop() {
	while(true) {
		log();
		win.updateWindowFrameTitle();
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

		if(glfwGetKey('Q') == GLFW_PRESS) {
			log();
			cam.rotateAroundAxis(2, -2.0);
		}

		mat4 model = mat4.look_at(vec3(0,0,10), vec3(0,0,-1), vec3(0,1,0));
		mat4 camM = cam.getViewMatrix();
		mat4 proM = win.getProjMatrix();
		log();
		//log("%s", identi);
		//log("%s", camM);
		//log("%s", proM);
		mat4 mvp = win.getProjMatrix() * cam.getViewMatrix() * model;
		glUseProgram(s);
		log();
		m.render(mvp, s);
		log();
		log("%s", mvp.toString());


		/*// 1rst attribute buffer : vertices
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

		glDisableVertexAttribArray(0);*/

		if(glfwGetKey(GLFW_KEY_ESC) == GLFW_PRESS) {
			break;
		}
 
		glfwSwapBuffers();
		//glfwPollEvents();
		GC.collect();
	}
}
