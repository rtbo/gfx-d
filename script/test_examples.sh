#! /bin/bash

DC=dmd

dub test --compiler=${DC}
dub test gfx:core --compiler=${DC}
dub test gfx:decl --compiler=${DC}
dub test gfx:genmesh --compiler=${DC}
dub test gfx:gl3 --compiler=${DC}
dub test gfx:math --compiler=${DC}
dub test gfx:memalloc --compiler=${DC}
dub test gfx:vulkan --compiler=${DC}
dub build gfx:declapi --compiler=${DC}
dub build gfx:deferred --compiler=${DC}
dub build gfx:depth --compiler=${DC}
dub build gfx:shadow --compiler=${DC}
dub build gfx:stencil --compiler=${DC}
dub build gfx:swapchain --compiler=${DC}
dub build gfx:texture --compiler=${DC}
dub build gfx:triangle --compiler=${DC}
dub build --build=ddox --compiler=${DC} --root=docbld
