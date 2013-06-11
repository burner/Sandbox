import std.file;
import std.string;
import std.stdio;

import opengl.glfuncs;
import opengl.gltypes;

import slog;

GLuint loadShader(string vertex_file_path, string fragment_file_path) {
	// Create the shaders
	GLuint VertexShaderID = glCreateShader(GL_VERTEX_SHADER);
	GLuint FragmentShaderID = glCreateShader(GL_FRAGMENT_SHADER);

	// Read the Vertex Shader code from the file
	string VertexShaderCode = readText(vertex_file_path);

	// Read the Fragment Shader code from the file
	string FragmentShaderCode = readText(fragment_file_path);

	GLint Result = GL_FALSE;
	int InfoLogLength;

	int* n = null;

	// Compile Vertex Shader
	log("Compiling shader : %s", vertex_file_path);
	immutable(char)* vertexSource = toStringz(VertexShaderCode);
	glShaderSource(VertexShaderID, 1, cast(const(char**))(&vertexSource), n);
	glCompileShader(VertexShaderID);

	// Check Vertex Shader
	glGetShaderiv(VertexShaderID, GL_COMPILE_STATUS, &Result);
	glGetShaderiv(VertexShaderID, GL_INFO_LOG_LENGTH, &InfoLogLength);
	int linkValue;
	glGetProgramiv(VertexShaderID, GL_LINK_STATUS, &linkValue);
	if(InfoLogLength > 0 && linkValue == GL_INVALID_VALUE){
		char[] VertexShaderErrorMessage = new char[InfoLogLength+1];
		glGetShaderInfoLog(VertexShaderID, InfoLogLength, null, VertexShaderErrorMessage.ptr);
		log("%d %s", InfoLogLength, VertexShaderErrorMessage.idup);
		foreach(it;VertexShaderErrorMessage) {
			write(it);
		}
		writeln();
		throw new Exception("Creating VertexShader Failed");
	}

	// Compile Fragment Shader
	log("Compiling shader : %s", fragment_file_path);
	immutable(char)* fragmentSource = toStringz(FragmentShaderCode);
	glShaderSource(FragmentShaderID, 1, cast(const(char**))(&fragmentSource), null);
	glCompileShader(FragmentShaderID);

	// Check Fragment Shader
	glGetShaderiv(FragmentShaderID, GL_COMPILE_STATUS, &Result);
	glGetShaderiv(FragmentShaderID, GL_INFO_LOG_LENGTH, &InfoLogLength);
	glGetProgramiv(FragmentShaderID, GL_LINK_STATUS, &linkValue);
	if(InfoLogLength > 0 && linkValue == GL_INVALID_VALUE) {
		char[] FragmentShaderErrorMessage = new char[InfoLogLength+1];
		glGetShaderInfoLog(FragmentShaderID, InfoLogLength, null, FragmentShaderErrorMessage.ptr);
		log("%d %s", InfoLogLength, FragmentShaderErrorMessage.idup);
		throw new Exception("Creating FragmentShader Failed");
	}

	// Link the program
	log("Linking program");
	GLuint ProgramID = glCreateProgram();
	glAttachShader(ProgramID, VertexShaderID);
	glAttachShader(ProgramID, FragmentShaderID);
	glLinkProgram(ProgramID);

	// Check the program
	glGetProgramiv(ProgramID, GL_LINK_STATUS, &Result);
	glGetProgramiv(ProgramID, GL_INFO_LOG_LENGTH, &InfoLogLength);
	glGetProgramiv(ProgramID, GL_LINK_STATUS, &linkValue);
	if(InfoLogLength > 0 && linkValue == GL_INVALID_VALUE) {
		char[] ProgramErrorMessage = new char[InfoLogLength+1];
		glGetProgramInfoLog(ProgramID, InfoLogLength, null, ProgramErrorMessage.ptr);
		log("%d %s", InfoLogLength, ProgramErrorMessage.idup);
		throw new Exception("Creating Program Failed");
	}

	glDeleteShader(VertexShaderID);
	glDeleteShader(FragmentShaderID);

	log("program build succesfully");

	return ProgramID;
}
