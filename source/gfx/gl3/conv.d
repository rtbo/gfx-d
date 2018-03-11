module gfx.gl3.conv;

package:

import gfx.bindings.opengl.gl;
import gfx.graal.buffer : BufferUsage;

GLenum toGl(in BufferUsage usage) pure {
    switch (usage) {
    case BufferUsage.transferSrc: return GL_COPY_READ_BUFFER;
    case BufferUsage.transferDst: return GL_COPY_WRITE_BUFFER;
    case BufferUsage.uniform: return GL_UNIFORM_BUFFER;
    case BufferUsage.index: return GL_ELEMENT_ARRAY_BUFFER;
    case BufferUsage.vertex: return GL_ARRAY_BUFFER;
    case BufferUsage.indirect: return GL_DRAW_INDIRECT_BUFFER;
    default: return 0;
    }
}
