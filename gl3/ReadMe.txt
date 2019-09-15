OpenGl bindings are generated with gldgen (https://github.com/rtbo/gldgen)
The command is something like:

$ cd $GLDGEN_DIR
$ ./gen_d_files.py \
        --package=gfx.bindings.opengl \
        --dest=$GFXD_DIR/gl3/source \
        --gl-addext-file=$GFXD_DIR/gl3/add-gl-exts.txt
