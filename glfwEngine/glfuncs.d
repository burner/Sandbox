/*

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/
module glfuncs;

import gltypes;

extern(C) {
void glClearIndex(GLfloat c);
void glClearColor(GLclampf,GLclampf,GLclampf,GLclampf);
void glClear(GLbitfield);
void glIndexMask(GLuint);
void glColorMask(GLboolean,GLboolean,GLboolean,GLboolean);
void glAlphaFunc(GLenum,GLclampf);
void glBlendFunc(GLenum,GLenum);
void glLogicOp(GLenum);
void glCullFace(GLenum);
void glFrontFace(GLenum);
void glPointSize(GLfloat);
void glLineWidth(GLfloat);
void glLineStipple(GLint,GLushort);
void glPolygonMode(GLenum,GLenum);
void glPolygonOffset(GLfloat,GLfloat);
void glPolygonStipple(in GLubyte*);
void glGetPolygonStipple(GLubyte*);
void glEdgeFlag(GLboolean);
void glEdgeFlagv(in GLboolean*);
void glScissor(GLint,GLint,GLsizei,GLsizei);
void glClipPlane(GLenum,in GLdouble*);
void glGetClipPlane(GLenum,GLdouble*);
void glDrawBuffer(GLenum);
void glReadBuffer(GLenum);
void glEnable(GLenum);
void glDisable(GLenum);
GLboolean glIsEnabled(GLenum);
void glEnableClientState(GLenum);
void glDisableClientState(GLenum);
void glGetBooleanv(GLenum,GLboolean*);
void glGetDoublev(GLenum,GLdouble*);
void glGetFloatv(GLenum,GLfloat*);
void glGetIntegerv(GLenum,GLint*);
void glPushAttrib(GLbitfield);
void glPopAttrib();
void glPushClientAttrib(GLbitfield);
void glPopClientAttrib();
GLint glRenderMode(GLenum);
GLenum glGetError();
const(char)* glGetString(GLenum);
void glFinish();
void glFlush();
void glHint(GLenum,GLenum);

void glClearDepth(GLclampd);
void glDepthFunc(GLenum);
void glDepthMask(GLboolean);
void glDepthRange(GLclampd,GLclampd);

void glClearAccum(GLfloat,GLfloat,GLfloat,GLfloat);
void glAccum(GLenum,GLfloat);

void glMatrixMode(GLenum);
void glOrtho(GLdouble,GLdouble,GLdouble,GLdouble,GLdouble,GLdouble);
void glFrustum(GLdouble,GLdouble,GLdouble,GLdouble,GLdouble,GLdouble);
void glViewport(GLint,GLint,GLsizei,GLsizei);
void glPushMatrix();
void glPopMatrix();
void glLoadIdentity();
void glLoadMatrixd(in GLdouble*);
void glLoadMatrixf(in GLfloat*);
void glMultMatrixd(in GLdouble*);
void glMultMatrixf(in GLfloat*);
void glRotated(GLdouble,GLdouble,GLdouble,GLdouble);
void glRotatef(GLfloat,GLfloat,GLfloat,GLfloat);
void glScaled(GLdouble,GLdouble,GLdouble);
void glScalef(GLfloat,GLfloat,GLfloat);
void glTranslated(GLdouble,GLdouble,GLdouble);
void glTranslatef(GLfloat,GLfloat,GLfloat);

GLboolean glIsList(GLuint);
void glDeleteLists(GLuint,GLsizei);
GLuint glGenLists(GLsizei);
void glNewList(GLuint,GLenum);
void glEndList();
void glCallList(GLuint);
void glCallLists(GLsizei,GLenum,in void*);
void glListBase(GLuint);

void glBegin(GLenum);
void glEnd();
void glVertex2d(GLdouble,GLdouble);
void glVertex2f(GLfloat,GLfloat);
void glVertex2i(GLint,GLint);
void glVertex2s(GLshort,GLshort);
void glVertex3d(GLdouble,GLdouble,GLdouble);
void glVertex3f(GLfloat,GLfloat,GLfloat);
void glVertex3i(GLint,GLint,GLint);
void glVertex3s(GLshort,GLshort,GLshort);
void glVertex4d(GLdouble,GLdouble,GLdouble,GLdouble);
void glVertex4f(GLfloat,GLfloat,GLfloat,GLfloat);
void glVertex4i(GLint,GLint,GLint,GLint);
void glVertex4s(GLshort,GLshort,GLshort,GLshort);
void glVertex2dv(in GLdouble*);
void glVertex2fv(in GLfloat*);
void glVertex2iv(in GLint*);
void glVertex2sv(in GLshort*);
void glVertex3dv(in GLdouble*);
void glVertex3fv(in GLfloat*);
void glVertex3iv(in GLint*);
void glVertex3sv(in GLshort*);
void glVertex4dv(in GLdouble*);
void glVertex4fv(in GLfloat*);
void glVertex4iv(in GLint*);
void glVertex4sv(in GLshort*);
void glNormal3b(GLbyte,GLbyte,GLbyte);
void glNormal3d(GLdouble,GLdouble,GLdouble);
void glNormal3f(GLfloat,GLfloat,GLfloat);
void glNormal3i(GLint,GLint,GLint);
void glNormal3s(GLshort,GLshort,GLshort);
void glNormal3bv(in GLbyte*);
void glNormal3dv(in GLdouble*);
void glNormal3fv(in GLfloat*);
void glNormal3iv(in GLint*);
void glNormal3sv(in GLshort*);
void glIndexd(GLdouble);
void glIndexf(GLfloat);
void glIndexi(GLint);
void glIndexs(GLshort);
void glIndexub(GLubyte);
void glIndexdv(in GLdouble*);
void glIndexfv(in GLfloat*);
void glIndexiv(in GLint*);
void glIndexsv(in GLshort*);
void glIndexubv(in GLubyte*);
void glColor3b(GLbyte,GLbyte,GLbyte);
void glColor3d(GLdouble,GLdouble,GLdouble);
void glColor3f(GLfloat,GLfloat,GLfloat);
void glColor3i(GLint,GLint,GLint);
void glColor3s(GLshort,GLshort,GLshort);
void glColor3ub(GLubyte,GLubyte,GLubyte);
void glColor3ui(GLuint,GLuint,GLuint);
void glColor3us(GLushort,GLushort,GLushort);
void glColor4b(GLbyte,GLbyte,GLbyte,GLbyte);
void glColor4d(GLdouble,GLdouble,GLdouble,GLdouble);
void glColor4f(GLfloat,GLfloat,GLfloat,GLfloat);
void glColor4i(GLint,GLint,GLint,GLint);
void glColor4s(GLshort,GLshort,GLshort,GLshort);
void glColor4ub(GLubyte,GLubyte,GLubyte,GLubyte);
void glColor4ui(GLuint,GLuint,GLuint,GLuint);
void glColor4us(GLushort,GLushort,GLushort,GLushort);
void glColor3bv(in GLbyte*);
void glColor3dv(in GLdouble*);
void glColor3fv(in GLfloat*);
void glColor3iv(in GLint*);
void glColor3sv(in GLshort*);
void glColor3ubv(in GLubyte*);
void glColor3uiv(in GLuint*);
void glColor3usv(in GLushort*);
void glColor4bv(in GLbyte*);
void glColor4dv(in GLdouble*);
void glColor4fv(in GLfloat*);
void glColor4iv(in GLint*);
void glColor4sv(in GLshort*);
void glColor4ubv(in GLubyte*);
void glColor4uiv(in GLuint*);
void glColor4usv(in GLushort*);
void glTexCoord1d(GLdouble);
void glTexCoord1f(GLfloat);
void glTexCoord1i(GLint);
void glTexCoord1s(GLshort);
void glTexCoord2d(GLdouble,GLdouble);
void glTexCoord2f(GLfloat,GLfloat);
void glTexCoord2i(GLint,GLint);
void glTexCoord2s(GLshort,GLshort);
void glTexCoord3d(GLdouble,GLdouble,GLdouble);
void glTexCoord3f(GLfloat,GLfloat,GLfloat);
void glTexCoord3i(GLint,GLint,GLint);
void glTexCoord3s(GLshort,GLshort,GLshort);
void glTexCoord4d(GLdouble,GLdouble,GLdouble,GLdouble);
void glTexCoord4f(GLfloat,GLfloat,GLfloat,GLfloat);
void glTexCoord4i(GLint,GLint,GLint,GLint);
void glTexCoord4s(GLshort,GLshort,GLshort,GLshort);
void glTexCoord1dv(in GLdouble*);
void glTexCoord1fv(in GLfloat*);
void glTexCoord1iv(in GLint*);
void glTexCoord1sv(in GLshort*);
void glTexCoord2dv(in GLdouble*);
void glTexCoord2fv(in GLfloat*);
void glTexCoord2iv(in GLint*);
void glTexCoord2sv(in GLshort*);
void glTexCoord3dv(in GLdouble*);
void glTexCoord3fv(in GLfloat*);
void glTexCoord3iv(in GLint*);
void glTexCoord3sv(in GLshort*);
void glTexCoord4dv(in GLdouble*);
void glTexCoord4fv(in GLfloat*);
void glTexCoord4iv(in GLint*);
void glTexCoord4sv(in GLshort*);
void glRasterPos2d(GLdouble,GLdouble);
void glRasterPos2f(GLfloat,GLfloat);
void glRasterPos2i(GLint,GLint);
void glRasterPos2s(GLshort,GLshort);
void glRasterPos3d(GLdouble,GLdouble,GLdouble);
void glRasterPos3f(GLfloat,GLfloat,GLfloat);
void glRasterPos3i(GLint,GLint,GLint);
void glRasterPos3s(GLshort,GLshort,GLshort);
void glRasterPos4d(GLdouble,GLdouble,GLdouble,GLdouble);
void glRasterPos4f(GLfloat,GLfloat,GLfloat,GLfloat);
void glRasterPos4i(GLint,GLint,GLint,GLint);
void glRasterPos4s(GLshort,GLshort,GLshort,GLshort);
void glRasterPos2dv(in GLdouble*);
void glRasterPos2fv(in GLfloat*);
void glRasterPos2iv(in GLint*);
void glRasterPos2sv(in GLshort*);
void glRasterPos3dv(in GLdouble*);
void glRasterPos3fv(in GLfloat*);
void glRasterPos3iv(in GLint*);
void glRasterPos3sv(in GLshort*);
void glRasterPos4dv(in GLdouble*);
void glRasterPos4fv(in GLfloat*);
void glRasterPos4iv(in GLint*);
void glRasterPos4sv(in GLshort*);
void glRectd(GLdouble,GLdouble,GLdouble,GLdouble);
void glRectf(GLfloat,GLfloat,GLfloat,GLfloat);
void glRecti(GLint,GLint,GLint,GLint);
void glRects(GLshort,GLshort,GLshort,GLshort);
void glRectdv(in GLdouble*, in GLdouble*);
void glRectfv(in GLfloat*, in GLfloat*);
void glRectiv(in GLint*, in GLint*);
void glRectsv(in GLshort*, in GLshort*);

void glShadeModel(GLenum);
void glLightf(GLenum,GLenum,GLfloat);
void glLighti(GLenum,GLenum,GLint);
void glLightfv(GLenum,GLenum,in GLfloat*);
void glLightiv(GLenum,GLenum,in GLint*);
void glGetLightfv(GLenum,GLenum,GLfloat*);
void glGetLightiv(GLenum,GLenum,GLint*);
void glLightModelf(GLenum,GLfloat);
void glLightModeli(GLenum,GLint);
void glLightModelfv(GLenum,in GLfloat*);
void glLightModeliv(GLenum,in GLint*);
void glMaterialf(GLenum,GLenum,GLfloat);
void glMateriali(GLenum,GLenum,GLint);
void glMaterialfv(GLenum,GLenum,in GLfloat*);
void glMaterialiv(GLenum,GLenum,in GLint*);
void glGetMaterialfv(GLenum,GLenum,GLfloat*);
void glGetMaterialiv(GLenum,GLenum,GLint*);
void glColorMaterial(GLenum,GLenum);

void glPixelZoom(GLfloat,GLfloat);
void glPixelStoref(GLenum,GLfloat);
void glPixelStorei(GLenum,GLint);
void glPixelTransferf(GLenum,GLfloat);
void glPixelTransferi(GLenum,GLint);
void glPixelMapfv(GLenum,GLint,in GLfloat*);
void glPixelMapuiv(GLenum,GLint,in GLuint*);
void glPixelMapusv(GLenum,GLint,in GLushort*);
void glGetPixelMapfv(GLenum,GLfloat*);
void glGetPixelMapuiv(GLenum,GLuint*);
void glGetPixelMapusv(GLenum,GLushort*);
void glBitmap(GLsizei,GLsizei,GLfloat,GLfloat,GLfloat,GLfloat,in GLubyte*);
void glReadPixels(GLint,GLint,GLsizei,GLsizei,GLenum,GLenum,void*);
void glDrawPixels(GLsizei,GLsizei,GLenum,GLenum,in void*);
void glCopyPixels(GLint,GLint,GLsizei,GLsizei,GLenum);

void glStencilFunc(GLenum,GLint,GLuint);
void glStencilMask(GLuint);
void glStencilOp(GLenum,GLenum,GLenum);
void glClearStencil(GLint);

void glTexGend(GLenum,GLenum,GLdouble);
void glTexGenf(GLenum,GLenum,GLfloat);
void glTexGeni(GLenum,GLenum,GLint);
void glTexGendv(GLenum,GLenum,in GLdouble*);
void glTexGenfv(GLenum,GLenum,in GLfloat*);
void glTexGeniv(GLenum,GLenum,in GLint*);
void glGetTexGendv(GLenum,GLenum,GLdouble*);
void glGetTexGenfv(GLenum,GLenum,GLfloat*);
void glGetTexGeniv(GLenum,GLenum,GLint*);
void glTexEnvf(GLenum,GLenum,GLfloat);
void glTexEnvi(GLenum,GLenum,GLint);
void glTexEnvfv(GLenum,GLenum,in GLfloat*);
void glTexEnviv(GLenum,GLenum,in GLint*);
void glGetTexEnvfv(GLenum,GLenum,GLfloat*);
void glGetTexEnviv(GLenum,GLenum,GLint*);
void glTexParameterf(GLenum,GLenum,GLfloat);
void glTexParameteri(GLenum,GLenum,GLint);
void glTexParameterfv(GLenum,GLenum,in GLfloat*);
void glTexParameteriv(GLenum,GLenum,in GLint*);
void glGetTexParameterfv(GLenum,GLenum,GLfloat*);
void glGetTexParameteriv(GLenum,GLenum,GLint*);
void glGetTexLevelParameterfv(GLenum,GLint,GLenum,GLfloat*);
void glGetTexLevelParameteriv(GLenum,GLint,GLenum,GLint*);
void glTexImage1D(GLenum,GLint,GLint,GLsizei,GLint,GLenum,GLenum,void*);
void glTexImage2D(GLenum,GLint,GLint,GLsizei,GLsizei,GLint,GLenum,GLenum,void*);
void glGetTexImage(GLenum,GLint,GLenum,GLenum,void*);

void glMap1d(GLenum,GLdouble,GLdouble,GLint,GLint,in GLdouble*);
void glMap1f(GLenum,GLfloat,GLfloat,GLint,GLint,in GLfloat*);
void glMap2d(GLenum,GLdouble,GLdouble,GLint,GLint,GLdouble,GLdouble,GLint,GLint,GLdouble*);
void glMap2f(GLenum,GLfloat,GLfloat,GLint,GLint,GLfloat,GLfloat,GLint,GLint,GLfloat*);
void glGetMapdv(GLenum,GLenum,GLdouble*);
void glGetMapfv(GLenum,GLenum,GLfloat*);
void glGetMapiv(GLenum,GLenum,GLint*);
void glEvalCoord1d(GLdouble);
void glEvalCoord1f(GLfloat);
void glEvalCoord1dv(in GLdouble*);
void glEvalCoord1fv(in GLfloat*);
void glEvalCoord2d(GLdouble,GLdouble);
void glEvalCoord2f(GLfloat,GLfloat);
void glEvalCoord2dv(in GLdouble*);
void glEvalCoord2fv(in GLfloat*);
void glMapGrid1d(GLint,GLdouble,GLdouble);
void glMapGrid1f(GLint,GLfloat,GLfloat);
void glMapGrid2d(GLint,GLdouble,GLdouble,GLint,GLdouble,GLdouble);
void glMapGrid2f(GLint,GLfloat,GLfloat,GLint,GLfloat,GLfloat);
void glEvalPoint1(GLint);
void glEvalPoint2(GLint,GLint);
void glEvalMesh1(GLenum,GLint,GLint);
void glEvalMesh2(GLenum,GLint,GLint,GLint,GLint);

void glFogf(GLenum,GLfloat);
void glFogi(GLenum,GLint);
void glFogfv(GLenum,in GLfloat*);
void glFogiv(GLenum,in GLint*);

void glFeedbackBuffer(GLsizei,GLenum,GLfloat*);
void glPassThrough(GLfloat);
void glSelectBuffer(GLsizei,GLuint*);
void glInitNames();
void glLoadName(GLuint);
void glPushName(GLuint);
void glPopName();

void glGenTextures(GLsizei,GLuint*);
void glDeleteTextures(GLsizei,in GLuint*);
void glBindTexture(GLenum,GLuint);
void glPrioritizeTextures(GLsizei,in GLuint*,in GLclampf*);
GLboolean glAreTexturesResident(GLsizei,in GLuint*,GLboolean*);
GLboolean glIsTexture(GLuint);

void glTexSubImage1D(GLenum,GLint,GLint,GLsizei,GLenum,GLenum,in void*);
void glTexSubImage2D(GLenum,GLint,GLint,GLint,GLsizei,GLsizei,GLenum,GLenum,in void*);
void glCopyTexImage1D(GLenum,GLint,GLenum,GLint,GLint,GLsizei,GLint);
void glCopyTexImage2D(GLenum,GLint,GLenum,GLint,GLint,GLsizei,GLsizei,GLint);
void glCopyTexSubImage1D(GLenum,GLint,GLint,GLint,GLint,GLsizei);
void glCopyTexSubImage2D(GLenum,GLint,GLint,GLint,GLint,GLint,GLsizei,GLsizei);

void glVertexPointer(GLint,GLenum,GLsizei,in void*);
void glNormalPointer(GLenum,GLsizei,in void*);
void glColorPointer(GLint,GLenum,GLsizei,in void*);
void glIndexPointer(GLenum,GLsizei,in void*);
void glTexCoordPointer(GLint,GLenum,GLsizei,in void*);
void glEdgeFlagPointer(GLsizei,in void*);
void glGetPointerv(GLenum,void**);
void glArrayElement(GLint);
void glDrawArrays(GLenum,GLint,GLsizei);
void glDrawElements(GLenum,GLsizei,GLenum,in void*);
void glInterleavedArrays(GLenum,GLsizei,in void*);

// gl 1.2
void glDrawRangeElements(GLenum, GLuint, GLuint, GLsizei, GLenum, in void*);
void glTexImage3D(GLenum, GLint, GLint, GLsizei, GLsizei, GLsizei, GLint, GLenum, GLenum, void*);
void glTexSubImage3D(GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLenum, void*);
void glCopyTexSubImage3D(GLenum, GLint, GLint, GLint, GLint, GLint, GLint, GLsizei, GLsizei);

// gl 1.3
void glActiveTexture(GLenum);
void glClientActiveTexture(GLenum);
void glMultiTexCoord1d(GLenum, GLdouble);
void glMultiTexCoord1dv(GLenum, in GLdouble*);
void glMultiTexCoord1f(GLenum, GLfloat);
void glMultiTexCoord1fv(GLenum, in GLfloat*);
void glMultiTexCoord1i(GLenum, GLint);
void glMultiTexCoord1iv(GLenum, in GLint*);
void glMultiTexCoord1s(GLenum, GLshort);
void glMultiTexCoord1sv(GLenum, in GLshort*);
void glMultiTexCoord2d(GLenum, GLdouble, GLdouble);
void glMultiTexCoord2dv(GLenum, in GLdouble*);
void glMultiTexCoord2f(GLenum, GLfloat, GLfloat);
void glMultiTexCoord2fv(GLenum, in GLfloat*);
void glMultiTexCoord2i(GLenum, GLint, GLint);
void glMultiTexCoord2iv(GLenum, in GLint*);
void glMultiTexCoord2s(GLenum, GLshort, GLshort);
void glMultiTexCoord2sv(GLenum, in GLshort*);
void glMultiTexCoord3d(GLenum, GLdouble, GLdouble, GLdouble);
void glMultiTexCoord3dv(GLenum, in GLdouble*);
void glMultiTexCoord3f(GLenum, GLfloat, GLfloat, GLfloat);
void glMultiTexCoord3fv(GLenum, in GLfloat*);
void glMultiTexCoord3i(GLenum, GLint, GLint, GLint);
void glMultiTexCoord3iv(GLenum, in GLint*);
void glMultiTexCoord3s(GLenum, GLshort, GLshort, GLshort);
void glMultiTexCoord3sv(GLenum, in GLshort*);
void glMultiTexCoord4d(GLenum, GLdouble, GLdouble, GLdouble, GLdouble);
void glMultiTexCoord4dv(GLenum, in GLdouble*);
void glMultiTexCoord4f(GLenum, GLfloat, GLfloat, GLfloat, GLfloat);
void glMultiTexCoord4fv(GLenum, in GLfloat*);
void glMultiTexCoord4i(GLenum, GLint, GLint, GLint, GLint);
void glMultiTexCoord4iv(GLenum, in GLint*);
void glMultiTexCoord4s(GLenum, GLshort, GLshort, GLshort, GLshort);
void glMultiTexCoord4sv(GLenum, in GLshort*);
void glLoadTransposeMatrixd(GLdouble*);
void glLoadTransposeMatrixf(in GLfloat*);
void glMultTransposeMatrixd(in GLdouble*);
void glMultTransposeMatrixf(in GLfloat*);
void glSampleCoverage(in GLclampf, GLboolean);
void glCompressedTexImage1D(GLenum, GLint, GLenum, GLsizei, GLint, GLsizei, in void*);
void glCompressedTexImage2D(GLenum, GLint, GLenum, GLsizei, GLsizei, GLint, GLsizei, in void*);
void glCompressedTexImage3D(GLenum, GLint, GLenum, GLsizei, GLsizei, GLsizei depth, GLint, GLsizei, in void*);
void glCompressedTexSubImage1D(GLenum, GLint, GLint, GLsizei, GLenum, GLsizei, in void*);
void glCompressedTexSubImage2D(GLenum, GLint, GLint, GLint, GLsizei, GLsizei, GLenum, GLsizei, in void*);
void glCompressedTexSubImage3D(GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLsizei, in void*);
void glGetCompressedTexImage(GLenum, GLint, void*);

// gl 1.4
void glBlendFuncSeparate(GLenum, GLenum, GLenum, GLenum);
void glFogCoordf(GLfloat);
void glFogCoordfv(in GLfloat*);
void glFogCoordd(GLdouble);
void glFogCoorddv(in GLdouble*);
void glFogCoordPointer(GLenum, GLsizei,in void*);
void glMultiDrawArrays(GLenum, GLint*, GLsizei*, GLsizei);
void glMultiDrawElements(GLenum, GLsizei*, GLenum, in void**, GLsizei);
void glPointParameterf(GLenum, GLfloat);
void glPointParameterfv(GLenum, GLfloat*);
void glPointParameteri(GLenum, GLint);
void glPointParameteriv(GLenum, GLint*);
void glSecondaryColor3b(GLbyte, GLbyte, GLbyte);
void glSecondaryColor3bv(in GLbyte*);
void glSecondaryColor3d(GLdouble, GLdouble, GLdouble);
void glSecondaryColor3dv(in GLdouble*);
void glSecondaryColor3f(GLfloat, GLfloat, GLfloat);
void glSecondaryColor3fv(in GLfloat*);
void glSecondaryColor3i(GLint, GLint, GLint);
void glSecondaryColor3iv(in GLint*);
void glSecondaryColor3s(GLshort, GLshort, GLshort);
void glSecondaryColor3sv(in GLshort*);
void glSecondaryColor3ub(GLubyte, GLubyte, GLubyte);
void glSecondaryColor3ubv(in GLubyte*);
void glSecondaryColor3ui(GLuint, GLuint, GLuint);
void glSecondaryColor3uiv(in GLuint*);
void glSecondaryColor3us(GLushort, GLushort, GLushort);
void glSecondaryColor3usv(in GLushort*);
void glSecondaryColorPointer(GLint, GLenum, GLsizei, void*);
void glWindowPos2d(GLdouble, GLdouble);
void glWindowPos2dv(in GLdouble*);
void glWindowPos2f(GLfloat, GLfloat);
void glWindowPos2fv(in GLfloat*);
void glWindowPos2i(GLint, GLint);
void glWindowPos2iv(in GLint*);
void glWindowPos2s(GLshort, GLshort);
void glWindowPos2sv(in GLshort*);
void glWindowPos3d(GLdouble, GLdouble, GLdouble);
void glWindowPos3dv(in GLdouble*);
void glWindowPos3f(GLfloat, GLfloat, GLfloat);
void glWindowPos3fv(in GLfloat*);
void glWindowPos3i(GLint, GLint, GLint);
void glWindowPos3iv(in GLint*);
void glWindowPos3s(GLshort, GLshort, GLshort);
void glWindowPos3sv(in GLshort*);
void glBlendColor(GLclampf, GLclampf, GLclampf, GLclampf);
void glBlendEquation(GLenum);

// gl 1.5
void glGenQueries(GLsizei, GLuint*);
void glDeleteQueries(GLsizei,in GLuint*);
GLboolean glIsQuery(GLuint);
void glBeginQuery(GLenum, GLuint);
void glEndQuery(GLenum);
void glGetQueryiv(GLenum, GLenum, GLint*);
void glGetQueryObjectiv(GLuint, GLenum, GLint*);
void glGetQueryObjectuiv(GLuint, GLenum, GLuint*);
void glBindBuffer(GLenum, GLuint);
void glDeleteBuffers(GLsizei, in GLuint*);
void glGenBuffers(GLsizei, GLuint*);
GLboolean glIsBuffer(GLuint);
void glBufferData(GLenum, GLsizeiptr, in void*, GLenum);
void glBufferSubData(GLenum, GLintptr, GLsizeiptr,in void*);
void glGetBufferSubData(GLenum, GLintptr, GLsizeiptr, void*);
void* glMapBuffer(GLenum, GLenum);
GLboolean glUnmapBuffer(GLenum);
void glGetBufferParameteriv(GLenum, GLenum, GLint*);
void glGetBufferPointerv(GLenum, GLenum, void**);

// gl 2.0
void glBlendEquationSeparate(GLenum, GLenum);
void glDrawBuffers(GLsizei, in GLenum*);
void glStencilOpSeparate(GLenum, GLenum, GLenum, GLenum);
void glStencilFuncSeparate(GLenum, GLenum, GLint, GLuint);
void glStencilMaskSeparate(GLenum, GLuint);
void glAttachShader(GLuint, GLuint);
void glBindAttribLocation(GLuint, GLuint, in GLchar*);
void glCompileShader(GLuint);
GLuint glCreateProgram();
GLuint glCreateShader(GLenum);
void glDeleteProgram(GLuint);
void glDeleteShader(GLuint);
void glDetachShader(GLuint, GLuint);
void glDisableVertexAttribArray(GLuint);
void glEnableVertexAttribArray(GLuint);
void glGetActiveAttrib(GLuint, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLchar*);
void glGetActiveUniform(GLuint, GLuint, GLsizei, GLsizei*, GLint*, GLenum*, GLchar*);
void glGetAttachedShaders(GLuint, GLsizei, GLsizei*, GLuint*);
GLint glGetAttribLocation(GLuint, in GLchar*);
void glGetProgramiv(GLuint, GLenum, GLint*);
void glGetProgramInfoLog(GLuint, GLsizei, GLsizei*, GLchar*);
void glGetShaderiv(GLuint, GLenum, GLint *);
void glGetShaderInfoLog(GLuint, GLsizei, GLsizei*, GLchar*);
void glGetShaderSource(GLuint, GLsizei, GLsizei*, GLchar*);
GLint glGetUniformLocation(GLuint, in GLchar*);
void glGetUniformfv(GLuint, GLint, GLfloat*);
void glGetUniformiv(GLuint, GLint, GLint*);
void glGetVertexAttribdv(GLuint, GLenum, GLdouble*);
void glGetVertexAttribfv(GLuint, GLenum, GLfloat*);
void glGetVertexAttribiv(GLuint, GLenum, GLint*);
void glGetVertexAttribPointerv(GLuint, GLenum, void**);
GLboolean glIsProgram(GLuint);
GLboolean glIsShader(GLuint);
void glLinkProgram(GLuint);
void glShaderSource(GLuint, GLsizei, in GLchar**, in GLint*);
void glUseProgram(GLuint);
void glUniform1f(GLint, GLfloat);
void glUniform2f(GLint, GLfloat, GLfloat);
void glUniform3f(GLint, GLfloat, GLfloat, GLfloat);
void glUniform4f(GLint, GLfloat, GLfloat, GLfloat, GLfloat);
void glUniform1i(GLint, GLint);
void glUniform2i(GLint, GLint, GLint);
void glUniform3i(GLint, GLint, GLint, GLint);
void glUniform4i(GLint, GLint, GLint, GLint, GLint);
void glUniform1fv(GLint, GLsizei, in GLfloat*);
void glUniform2fv(GLint, GLsizei, in GLfloat*);
void glUniform3fv(GLint, GLsizei, in GLfloat*);
void glUniform4fv(GLint, GLsizei, in GLfloat*);
void glUniform1iv(GLint, GLsizei, in GLint*);
void glUniform2iv(GLint, GLsizei, in GLint*);
void glUniform3iv(GLint, GLsizei, in GLint*);
void glUniform4iv(GLint, GLsizei, in GLint*);
void glUniformMatrix2fv(GLint, GLsizei, GLboolean, in GLfloat*);
void glUniformMatrix3fv(GLint, GLsizei, GLboolean, in GLfloat*);
void glUniformMatrix4fv(GLint, GLsizei, GLboolean, in GLfloat*);
void glValidateProgram(GLuint);
void glVertexAttrib1d(GLuint, GLdouble);
void glVertexAttrib1dv(GLuint, in GLdouble*);
void glVertexAttrib1f(GLuint, GLfloat);
void glVertexAttrib1fv(GLuint, in GLfloat*);
void glVertexAttrib1s(GLuint, GLshort);
void glVertexAttrib1sv(GLuint, in GLshort*);
void glVertexAttrib2d(GLuint, GLdouble, GLdouble);
void glVertexAttrib2dv(GLuint, in GLdouble*);
void glVertexAttrib2f(GLuint, GLfloat, GLfloat);
void glVertexAttrib2fv(GLuint, in GLfloat*);
void glVertexAttrib2s(GLuint, GLshort, GLshort);
void glVertexAttrib2sv(GLuint, in GLshort*);
void glVertexAttrib3d(GLuint, GLdouble, GLdouble, GLdouble);
void glVertexAttrib3dv(GLuint, in GLdouble*);
void glVertexAttrib3f(GLuint, GLfloat, GLfloat, GLfloat);
void glVertexAttrib3fv(GLuint, in GLfloat*);
void glVertexAttrib3s(GLuint, GLshort, GLshort, GLshort);
void glVertexAttrib3sv(GLuint, in GLshort*);
void glVertexAttrib4Nbv(GLuint, in GLbyte*);
void glVertexAttrib4Niv(GLuint, in GLint*);
void glVertexAttrib4Nsv(GLuint, in GLshort*);
void glVertexAttrib4Nub(GLuint, GLubyte, GLubyte, GLubyte, GLubyte);
void glVertexAttrib4Nubv(GLuint, in GLubyte*);
void glVertexAttrib4Nuiv(GLuint, in GLuint*);
void glVertexAttrib4Nusv(GLuint, in GLushort*);
void glVertexAttrib4bv(GLuint, in GLbyte*);
void glVertexAttrib4d(GLuint, GLdouble, GLdouble, GLdouble, GLdouble);
void glVertexAttrib4dv(GLuint, in GLdouble*);
void glVertexAttrib4f(GLuint, GLfloat, GLfloat, GLfloat, GLfloat);
void glVertexAttrib4fv(GLuint, in GLfloat*);
void glVertexAttrib4iv(GLuint, in GLint*);
void glVertexAttrib4s(GLuint, GLshort, GLshort, GLshort, GLshort);
void glVertexAttrib4sv(GLuint, in GLshort*);
void glVertexAttrib4ubv(GLuint, in GLubyte*);
void glVertexAttrib4uiv(GLuint, in GLuint*);
void glVertexAttrib4usv(GLuint, in GLushort*);
void glVertexAttribPointer(GLuint, GLint, GLenum, GLboolean, GLsizei, in void*);

// gl 2.1
void glUniformMatrix2x3fv(GLint, GLsizei, GLboolean, in GLfloat*);
void glUniformMatrix3x2fv(GLint, GLsizei, GLboolean, in GLfloat*);
void glUniformMatrix2x4fv(GLint, GLsizei, GLboolean, in GLfloat*);
void glUniformMatrix4x2fv(GLint, GLsizei, GLboolean, in GLfloat*);
void glUniformMatrix3x4fv(GLint, GLsizei, GLboolean, in GLfloat*);
void glUniformMatrix4x3fv(GLint, GLsizei, GLboolean, in GLfloat*);

// gl 3.0
void glBeginConditionalRender(GLuint, GLenum);
void glBeginTransformFeedback(GLenum);
void glBindFragDataLocation(GLuint, GLuint, in GLchar*);
void glClampColor(GLenum, GLenum);
void glClearBufferfi(GLenum, GLint, GLfloat, GLint);
void glClearBufferfv(GLenum, GLint, in GLfloat*);
void glClearBufferiv(GLenum, GLint, in GLint*);
void glClearBufferuiv(GLenum, GLint, in GLuint*);
void glColorMaski(GLuint, GLboolean, GLboolean, GLboolean, GLboolean);
void glDisablei(GLenum, GLuint);
void glEnablei(GLenum, GLuint);
void glEndConditionalRender();
void glEndTransformFeedback();
void glGetBooleani_v(GLenum, GLuint, GLboolean*);
GLint glGetFragDataLocation(GLuint, in GLchar*);
const(ubyte)* glGetStringi(GLenum, GLuint);
void glGetTexParameterIiv(GLuint, GLenum, GLint*);
void glGetTexParameterIuiv(GLuint, GLenum, GLuint*);
GLboolean glIsEnabledi(GLenum, GLuint);
void glTexParameterIiv(GLenum, GLenum, in GLint*);
void glTexParameterIuiv(GLenum, GLenum, in GLuint*);
void glTransformFeedbackVaryings(GLuint, GLsizei, in GLchar**, GLenum);
void glUniform1ui(GLint, GLuint);
void glUniform1uiv(GLint, GLsizei, in GLuint*);
void glUniform2ui(GLint, GLuint, GLuint);
void glUniform2uiv(GLint, GLsizei, in GLuint*);
void glUniform3ui(GLint, GLuint, GLuint, GLuint);
void glUniform3uiv(GLint, GLsizei, in GLuint*);
void glUniform4ui(GLint, GLuint, GLuint, GLuint, GLuint);
void glUniform4uiv(GLint, GLsizei, in GLuint*);
void glVertexAttribI1i(GLuint, GLint);
void glVertexAttribI1iv(GLuint, in GLint*);
void glVertexAttribI1ui(GLuint, GLuint);
void glVertexAttribI1uiv(GLuint, in GLuint*);
void glVertexAttribI2i(GLuint, GLint, GLint);
void glVertexAttribI2iv(GLuint, in GLint*);
void glVertexAttribI2ui(GLuint, GLuint, GLuint);
void glVertexAttribI2uiv(GLuint, in GLuint*);
void glVertexAttribI3i(GLuint, GLint, GLint, GLint);
void glVertexAttribI3iv(GLuint, in GLint*);
void glVertexAttribI3ui(GLuint, GLuint, GLuint);
void glVertexAttribI3uiv(GLuint, in GLuint*);
void glVertexAttribI4bv(GLuint, in GLbyte*);
void glVertexAttribI4i(GLuint, GLint, GLint, GLint, GLint);
void glVertexAttribI4iv(GLuint, in GLint*);
void glVertexAttribI4sv(GLuint, in GLshort*);
void glVertexAttribI4ubv(GLuint, in GLubyte*);
void glVertexAttribI4ui(GLuint, GLuint, GLuint, GLuint, GLuint);
void glVertexAttribI4uiv(GLuint, in GLuint*);
void glVertexAttribI4usv(GLuint, in GLushort*);
void glVertexAttribIPointer(GLuint, GLint, GLenum, GLsizei, in GLvoid*);

// gl 3.1
void glDrawArraysInstanced(GLenum, GLint, GLsizei, GLsizei);
void glDrawElementsInstanced(GLenum, GLsizei, GLenum, in GLvoid*, GLsizei);
void glPrimitiveRestartIndex(GLuint);
void glTexBuffer(GLenum, GLenum, GLuint);

// gl 3.2
void glFramebufferTexture(GLenum, GLenum, GLuint, GLuint);
void glGetBufferParameteri64v(GLenum, GLenum, GLint64*);
void glGetInteger64i_v(GLenum, GLuint, GLint64*);

// gl 3.3
void glVertexAttribDivisor(GLuint, GLuint);

// gl 4.0
void glBlendEquationSeparatei(GLuint, GLenum, GLenum);
void glBlendEquationi(GLuint, GLenum);
void glBlendFuncSeparatei(GLuint, GLenum, GLenum, GLenum, GLenum);
void glBlendFunci(GLuint, GLenum, GLenum);
void glMinSampleShading(GLclampf);
}
