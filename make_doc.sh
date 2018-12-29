#! /bin/bash

find docs -type f -not -path "*/\.*" -delete
rm -rf docs/gfx
dub build --build=ddox --root=docbld
