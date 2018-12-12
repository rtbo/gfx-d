#! /bin/bash

VKDGEN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VKDGEN=$VKDGEN_DIR/vkdgen.py
VK_MOD=gfx.bindings.vulkan.vk
VK_OUT=$VKDGEN_DIR/../source/gfx/bindings/vulkan/vk.d

python3 $VKDGEN -m $VK_MOD -o $VK_OUT
