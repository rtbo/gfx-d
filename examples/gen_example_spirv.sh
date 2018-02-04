#! /bin/sh

if [ "$#" -eq 0 ] || [ ! -d "$1" ]; then
    echo "Must pass example dir as first argument of gen_example_spirv.sh"
    exit 2
fi

EX_DIR=$1
VIEWS_DIR=$EX_DIR/views

function gen_spirv() {
    glsl=$1
    spirv=$2

    if [ ! -f "$spirv" ] || [ "$spirv" -ot "$glsl" ]; then
        echo "Generating $spirv"
        glslangValidator -V $glsl -o $spirv || exit 1

    else
        echo "$spirv is up-to-date"
    fi
}

for shader in $VIEWS_DIR/*.vert; do
    gen_spirv $shader $shader.spv
done
for shader in $VIEWS_DIR/*.frag; do
    gen_spirv $shader $shader.spv
done
