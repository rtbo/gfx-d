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

ZXDG_XML=$RES_DIR/xdg-shell-unstable-v6.xml
ZXDG_SRC=$SRC_DIR/gfx/window/wayland/zxdg_shell_v6.d

gen_protocol gfx.window.wayland.zxdg_shell_v6 $ZXDG_XML $ZXDG_SRC
