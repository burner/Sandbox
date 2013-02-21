import std.array;
import std.exception;
import std.stdio;
import std.string;
import std.file;
import std.format;

import gl3n.linalg;

//import opengl.gltypes;
//import opengl.glfuncs;
import opengl.gl;

import slog;

struct Mesh {
	GLuint[3] buffers;
	GLuint vertexArrayId;
	size_t numTriangle;

	void render(ref mat4 mvp, GLuint programID) {
		GLuint MatrixID = glGetUniformLocation(programID, "MVP");
		glUniformMatrix4fv(MatrixID, 1, GL_FALSE, mvp.value_ptr);
	  	glEnableVertexAttribArray(0);
		glBindBuffer(GL_ARRAY_BUFFER, buffers[0]);
		log();
		// 1nd attribute buffer : vertices
		glVertexAttribPointer(
				0,		// attribute. No particular reason for 0, but must match the layout in the shader.
				3,		// size
				GL_FLOAT, // type
				GL_FALSE, // normalized?
				0,		// stride
				null // array buffer offset
		);

		log();
		// 2nd attribute buffer : normals
		glEnableVertexAttribArray(1);
		glBindBuffer(GL_ARRAY_BUFFER, buffers[1]);
		glVertexAttribPointer(
				1,		// attribute. No particular reason for 1, but must match the layout in the shader.
				3,		// size : U+V => 2
				GL_FLOAT, // type
				GL_FALSE, // normalized?
				0,		// stride
				null  // array buffer offset
		);

		log();
		// 2nd attribute buffer : UVs
		glEnableVertexAttribArray(2);
		glBindBuffer(GL_ARRAY_BUFFER, buffers[2]);
		glVertexAttribPointer(
				2,		// attribute. No particular reason for 1, but must match the layout in the shader.
				2,		// size : U+V => 2
				GL_FLOAT, // type
				GL_FALSE, // normalized?
				0,		// stride
				null  // array buffer offset
		);
		log("%d", cast(GLint)this.numTriangle/9);

		// Draw the triangle !
		glDrawArrays(GL_TRIANGLES, 0, cast(GLint)this.numTriangle/9);
		log();

		glDisableVertexAttribArray(0);
		glDisableVertexAttribArray(1);
		glDisableVertexAttribArray(2);
	}

	void loadObjFile(string filename) {
		File f = File(filename);
		enforce(f.isOpen());
		auto ver = appender!(vec3[])();
		auto nor = appender!(vec3[])();
		auto uv = appender!(vec2[])();
		auto fv = appender!(size_t[])();
		auto fn = appender!(size_t[])();
		auto fu = appender!(size_t[])();

		char[] buf;
		while(f.readln(buf)) {
			if(buf.length == 0) {
				continue;
			} else if(buf[0] != 'v' && buf[0] != 'f') {
				continue;
			} else if(buf[0] == 'f') {
				int[9] tmp;	
				uint cnt = formattedRead(buf, "f %d/%d/%d %d/%d/%d %d/%d/%d",
						&tmp[0], &tmp[1], &tmp[2], &tmp[3], &tmp[4], &tmp[5],
						&tmp[6], &tmp[7], &tmp[8]);
				enforce(cnt == 9, "face not read correct");
				fv.put([tmp[0], tmp[3], tmp[6]]);
				fu.put([tmp[1], tmp[4], tmp[7]]);
				fn.put([tmp[2], tmp[5], tmp[8]]);
			} else if(buf[0 .. 2] == "v ") {
				float[3] tmp;	
				uint cnt = formattedRead(buf, "v %f %f %f", &tmp[0], &tmp[1], 
					&tmp[2]);
				ver.put(vec3(tmp[0], tmp[1], tmp[2]));
			} else if(buf[0 .. 2] == "vn") {
				float[3] tmp;	
				uint cnt = formattedRead(buf, "vn %f %f %f", &tmp[0], &tmp[1], 
					&tmp[2]);
				nor.put(vec3(tmp[0], tmp[1], tmp[2]));
			} else if(buf[0 .. 2] == "vt") {
				float[2] tmp;	
				uint cnt = formattedRead(buf, "vt %f %f", &tmp[0], &tmp[1]);
				uv.put(vec2(tmp[0], tmp[1]));
			}
		}

		auto verD = ver.data();
		auto norD = nor.data();
		auto uvD = uv.data();

		//log("%u %u %u", verD.length, norD.length, uvD.length);

		auto fvD = fv.data();
		auto fnD = fn.data();
		auto fuD = fu.data();

		float[] uvgl = new float[fvD.length*2];
		float[] norgl = new float[fvD.length*3];
		float[] vergl = new float[fvD.length*3];

		//log("%u %u %u", vergl.length, norgl.length, uvgl.length);

		size_t veridx = 0;
		size_t noridx = 0;
		size_t uvidx = 0;
		for(size_t i = 0; i < fvD.length; ++i) {
			size_t fvDIdx = fvD[i];
			size_t fnDIdx = fnD[i];
			size_t fuDIdx = fuD[i];

			//log("%u %u %u", fvDIdx-1, fnDIdx-1, fuDIdx-1);
			//log("%u %u %u", veridx, noridx, uvidx);

			vergl[veridx] = verD[fvDIdx-1].x;
			vergl[veridx+1] = verD[fvDIdx-1].y;
			vergl[veridx+2] = verD[fvDIdx-1].z;	veridx+=3;

			norgl[noridx] = norD[fnDIdx-1].x;
			norgl[noridx+1] = norD[fnDIdx-1].y;
			norgl[noridx+2] = norD[fnDIdx-1].z;	noridx+=3;

			uvgl[uvidx] = uvD[fuDIdx-1].x;
			uvgl[uvidx+1] = uvD[fuDIdx-1].y; uvidx+=2;
		}

		log("%u %u %u", vergl.length, norgl.length, uvgl.length);

		//writeln(uvgl);
		//writeln();
		//writeln(norgl);
		//writeln();
		//writeln(vergl);

		f.close();

		log();

		//GLuint VertexArrayID;
		glGenVertexArrays(1, &vertexArrayId);
		glBindVertexArray(vertexArrayId);

		//GLuint vertexbuffer;
		glGenBuffers(1, &buffers[0]);
		glBindBuffer(GL_ARRAY_BUFFER, buffers[0]);
		glBufferData(GL_ARRAY_BUFFER, vergl.length * float.sizeof, vergl.ptr, GL_STATIC_DRAW);

		glGenBuffers(1, &buffers[1]);
		glBindBuffer(GL_ARRAY_BUFFER, buffers[1]);
		glBufferData(GL_ARRAY_BUFFER, norgl.length * float.sizeof, norgl.ptr, GL_STATIC_DRAW);

		glGenBuffers(1, &buffers[2]);
		glBindBuffer(GL_ARRAY_BUFFER, buffers[2]);
		glBufferData(GL_ARRAY_BUFFER, uvgl.length * float.sizeof, norgl.ptr, GL_STATIC_DRAW);

		this.numTriangle = vergl.length;
	}
}
