# gfx-d

[![Build Status](https://travis-ci.com/rtbo/gfx-d.svg?branch=master)](https://travis-ci.com/rtbo/gfx-d)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/rtbo/gfx-d?branch=master&svg=true)](https://ci.appveyor.com/project/rtbo/gfx-d)


Graphics rendering engine for the D programming language.

[Online API reference](https://rtbo.github.io/gfx-d/)

The main idea is to have an abstraction layer (here named Graal - Graphics API abstraction layer)
and several backends implementing it. There are several packages:

 - `gfx:core`:     Core utilities: reference counting, logging...
 - `gfx`:          Main package containing `gfx.graal` module.
 - `gfx:vulkan`:   The Vulkan backend implementation.
 - `gfx:gl3`:      The OpenGL3 backend implementation.
 - `gfx:decl`:     Optional declarative engine for pipeline creation.
 - `gfx:math`:     Optional math library.
 - `gfx:memalloc`: Optional memory allocator.
 - `gfx:window`:   Optional toy window library. Used by examples.

A few examples are also available as DUB subpackages.
To run an example right away, the following should do it.
```sh
$ dub fetch gfx
$ dub run gfx:triangle
```
Some examples need a 3rdparty library available as a submodule. To run these,
you have to clone the repo:
```sh
$ git clone --recursive https://github.com/rtbo/gfx-d.git
$ cd gfx-d
$ dub run gfx:texture
```

## gfx:core - Core utilies

The main utility is the reference counting, that is necessary for deterministic
resource management.

```d
import gfx.core.rc;

class SomeResource : IAtomicRefCounted
{
    mixin(atomicRcCode);

    this(/+ ... +/)
    {
        // ...
    }

    override void dispose()
    {
        // ...
    }
}

void fun()
{
    // makeRc makes Rc!SomeResource
    auto res1 = makeRc!SomeResource(/+ ... +/);
    // getResource returns SomeResource. rc turns it into Rc!SomeResource
    auto res2 = getResource().rc; // res

    // res1 and res2 are automatically released at end of scope
}
```
The good thing here is that `IAtomicRefCounted` is an interface, so it is possible
to build completely abstract API with reference counting enabled.
The implementation is provided by a one liner mixin.
Another useful thing is that the counter is embedded in each object,
so objects can be passed around by reference in the most natural way and still
be referenced where it is needed.
A smart pointer (`Rc`) is provided. A more traditional API is also provided (`retainObj`, `releaseObj`, ...)

## Graal - Graphics API abstraction layer

One of gfx-d targets is to allow using the full power of Vulkan.
Therefore Graal API is closely modeled on Vulkan to enable the use of all low-level
Vulkan features.
It results that Graal itself is a low level library.
Ideally, a higher level API will be built one day on top of Graal.

Graal loads only SPIR-V shader programs. NDC system is the one of the
backend (`gfx:math` is NDC agnostic and provides projection matrices for
different NDCs).

## gfx:vulkan - Vulkan backend

This is the Vulkan backend implementation that translates almost directly from
Graal to Vulkan. This should be the preferred and natural backend when using gfx-d.

## gfx:gl3 - OpenGL backend

If Vulkan is not available on a target machine, `gfx:gl3` is available as backup.
SPIRV-Cross is used to translate shaders to GLSL. Many shaders will be
compatible for both Vulkan and OpenGL backends out of the box, but there are
limitations:
 - push constants are not available
 - depth map need range adaptation
There are probably many more...

## gfx:decl

Allow to setup render passes and pipelines with SDL description. (It is planned
to move to Lua at some point in the future)

A pipeline SDL description look as follow:
```sdl
graal:DescriptorSetLayout {
    // store is the mechanism to reference other objects
    store "dsl"
    bindings {
        0 descriptorType="uniformBufferDynamic" descriptorCount=1 stages="vertex"
        1 descriptorType="uniformBuffer" descriptorCount=1 stages="fragment"
    }
}
// ...
graal:ShaderModule {
    local-store "vertSh"
    // source can also be asset or binary base64 (although that is discouraged)
    source "view:shader.vert.spv"
    entryPoint "main" // this is the default and can be omitted
}
graal:Pipeline {
    store "pl"
    shaders {
        // shaders can be attached from the store
        vertex "store:vertSh"
        // or created inline
        fragment source="view:shader.frag.spv" entryPoint="main" store="fragSh"
    }
    inputBindings {
        0 stride="sizeof:Vertex" instanced=off
    }
    inputAttribs {
        // three ways to specify input attribs
        0 binding=0 format="rgb32_sFloat" offset=0
        1 binding=0 format="formatof:Vertex.normal" offset="offsetof:Vertex.normal"
        2 binding=0 member="Vertex.color" // shortcut to formatof and offsetof
    }
    assembly primitive="triangleList" primitiveRestart=off
    // if depthBias needed, specify it in a children of rasterizer
    rasterizer polygonMode="fill" cull="back" front="ccw" lineWidth=1 depthClamp=off {
        depthBias slope=2f const=1f
    }
    viewports {
        // ...
    }
    depthInfo on write=on compareOp="less"
    blendInfo {
        attachments {
            // ...
        }
    }
    dynamicStates "viewport" "scissor"
    layout "store:layout"
    renderPass "store:rp" subpass=0
}
```

## gfx:math - Math library

 - matrices (row major)
 - vectors
 - transforms
 - projections (for different coordinate systems and depth ranges)
 - inverse matrix
 - floating point utility

## gfx:memalloc - A graphics memory allocator

```d
import gfx.core.rc : rc;
import gfx.graal.buffer : BufferUsage;
import gfx.memalloc : AllocatorOptions, AllocOptions, HeapOptions, MemoryUsage;

AllocatorOptions options;
options.heapOptions = // one HeapOption per heap in the device, specifying default block size for each

auto allocator = createAllocator(device, options).rc;

auto stagBuf = allocator.allocateBuffer(
    BufferUsage.transferSrc, size, AllocOptions.forUsage(MemoryUsage.cpuToGpu)
).rc;
```

## gfx:window - A toy windowing system

3 backends:
 - Win32
 - Xcb
 - Wayland (without decorations)

```d
Backend[] backendLoadOrder = [
    Backend.vulkan, Backend.gl3
];
// Create a display for the running platform
// The instance is created by the display. Backend is chosen at runtime
// depending on detected API support. (i.e. Vulkan is preferred)
auto display = createDisplay(backendLoadOrder).rc;
// Retrieve the Graal instance that is used to list and open device(s)
auto instance = display.instance.rc;
// Create a window. The surface is created during the call to show.
auto window = display.createWindow();
window.show(640, 480);

```
