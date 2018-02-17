#! /bin/bash

GLDGEN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GLDGEN=$GLDGEN_DIR/gldgen.py
GL_MOD=gfx.bindings.opengl.gl
GL_OUT=$GLDGEN_DIR/../source/gfx/bindings/opengl/gl.d

python3 $GLDGEN -m $GL_MOD -o $GL_OUT
