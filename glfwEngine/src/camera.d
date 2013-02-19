module camera;

import gl3n.math;
import gl3n.linalg;

import slog;

struct Camera {
	private vec3 pos;
	private quat ori;
	private mat4 viewMatrix;

	void init() {
		this.ori = quat(1.0, 0.0, 0.0, 0.0);
	}

	void rotateAroundAxis(int whichAxis, double degree) {
		// Convert to radiant
		double radiant = degree * (PI / 180.0);

		// Find the rotation-axis for this operation
		mat4 currentAxes = this.ori.to_matrix!(4,4)();
		float[] axisLine = currentAxes[whichAxis];
		vec3 axis = vec3(axisLine[0], axisLine[1], axisLine[2]);
		axis.normalize();

		// Build the Quat4 according to:
		// http://en.wikipedia.org/wiki/Quaternion_rotation
		quat mult = quat(axis, radiant);

		// Now multiply our existing quaternion with the new one.
		this.ori = this.ori * mult;
		this.ori.normalize();
		this.updateViewMatrix();
	}

	void updateViewMatrix() {
		this.viewMatrix = this.ori.to_matrix!(4,4)();
	}

	mat4 getViewMatrix() const {
		return this.viewMatrix;
	}
}
