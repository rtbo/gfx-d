#! /bin/sh

if [ "$#" -eq 0 ] || [ ! -d "$1" ]; then
    echo "Must pass gfx-d project dir as first argument of gen_wld_protocol.sh"
    exit 1
fi

PROJ_DIR=$1
RES_DIR=$PROJ_DIR/resources
SRC_DIR=$PROJ_DIR/source


gen_protocol () {
    module=$1
    xml=$2
    src=$3

    if [ ! -f "$src" ] || [ "$src" -ot "$xml" ]; then
        echo "Generating $module from $xml"
        dub run wayland:scanner -- -m $module -i $xml -o $src
    else
        echo "$module is up-to-date"
    fi
}

gen_protocol \
    gfx.window.wayland.xdg_shell \
    $RES_DIR/xdg-shell.xml \
    $SRC_DIR/gfx/window/wayland/xdg_shell.d
