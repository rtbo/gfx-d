module crate;

import gfx.core : Primitive;
import gfx.core.rc : rc, makeRc;
import gfx.core.typecons : none, some;
import gfx.core.format : Rgba8, Depth, newSwizzle;
import gfx.core.buffer : VertexBuffer, IndexBuffer, VertexBufferSlice, ConstBuffer;
import gfx.core.program : Program, ShaderSet;
import gfx.core.texture : Texture2D, Sampler, SamplerInfo, FilterMethod, WrapMode;
import gfx.core.draw : clearColor, Instance;
import s = gfx.core.state : Rasterizer;
import gfx.core.pso.meta;
import gfx.core.pso : PipelineState;
import gfx.core.encoder : Encoder;
import gfx.window.glfw : gfxGlfwWindow;

import gl3n.linalg : mat4, mat3, vec3, vec4;
import derelict.opengl3.gl3;

import std.stdio : writeln;
import std.math : PI;

enum maxNumLights = 5;

struct Vertex {
    @GfxName("a_Pos")       float[3] pos;
    @GfxName("a_Normal")    float[3] normal;
    @GfxName("a_TexCoord")  float[2] texCoord;
}

struct Matrices {
    float[4][4] mvp;
    float[4][4] normal;
}

struct Light {
    float[4] direction;
    float[4] color;
}

struct NumLights {
    int numLights;
}

struct CratePipeMeta {
    VertexInput!Vertex      input;

    @GfxName("Matrices")
    ConstantBlock!Matrices  matrices;

    @GfxName("NumLights")
    ConstantBlock!NumLights numLights;

    @GfxName("Lights")
    ConstantBlock!Light     lights;

    @GfxName("t_Sampler")
    ResourceView!Rgba8      texture;

    @GfxName("t_Sampler")
    ResourceSampler         sampler;

    @GfxName("o_Color")
    ColorOutput!Rgba8       outColor;

    @GfxDepth(s.Depth.lessEqualWrite)
    DepthOutput!Depth       outDepth;
}

alias CratePipeline = PipelineState!CratePipeMeta;


immutable crate = [
    // top (0, 0, 1)
    Vertex([-1, -1,  1],    [ 0,  0,  1],   [0, 0]),
    Vertex([ 1, -1,  1],    [ 0,  0,  1],   [1, 0]),
    Vertex([ 1,  1,  1],    [ 0,  0,  1],   [1, 1]),
    Vertex([-1,  1,  1],    [ 0,  0,  1],   [0, 1]),
    // bottom (0, 0, -1)
    Vertex([-1,  1, -1],    [ 0,  0, -1],   [1, 0]),
    Vertex([ 1,  1, -1],    [ 0,  0, -1],   [0, 0]),
    Vertex([ 1, -1, -1],    [ 0,  0, -1],   [0, 1]),
    Vertex([-1, -1, -1],    [ 0,  0, -1],   [1, 1]),
    // right (1, 0, 0)
    Vertex([ 1, -1, -1],    [ 1,  0,  0],   [0, 0]),
    Vertex([ 1,  1, -1],    [ 1,  0,  0],   [1, 0]),
    Vertex([ 1,  1,  1],    [ 1,  0,  0],   [1, 1]),
    Vertex([ 1, -1,  1],    [ 1,  0,  0],   [0, 1]),
    // left (-1, 0, 0)
    Vertex([-1, -1,  1],    [-1,  0,  0],   [1, 0]),
    Vertex([-1,  1,  1],    [-1,  0,  0],   [0, 0]),
    Vertex([-1,  1, -1],    [-1,  0,  0],   [0, 1]),
    Vertex([-1, -1, -1],    [-1,  0,  0],   [1, 1]),
    // front (0, 1, 0)
    Vertex([ 1,  1, -1],    [ 0,  1,  0],   [1, 0]),
    Vertex([-1,  1, -1],    [ 0,  1,  0],   [0, 0]),
    Vertex([-1,  1,  1],    [ 0,  1,  0],   [0, 1]),
    Vertex([ 1,  1,  1],    [ 0,  1,  0],   [1, 1]),
    // back (0, -1, 0)
    Vertex([ 1, -1,  1],    [ 0, -1,  0],   [0, 0]),
    Vertex([-1, -1,  1],    [ 0, -1,  0],   [1, 0]),
    Vertex([-1, -1, -1],    [ 0, -1,  0],   [1, 1]),
    Vertex([ 1, -1, -1],    [ 0, -1,  0],   [0, 1]),
];

immutable ushort[] crateIndices = [
     0,  1,  2,  2,  3,  0, // top
     4,  5,  6,  6,  7,  4, // bottom
     8,  9, 10, 10, 11,  8, // right
    12, 13, 14, 14, 15, 12, // left
    16, 17, 18, 18, 19, 16, // front
    20, 21, 22, 22, 23, 20, // back
];


immutable float[4] backColor = [0.1, 0.2, 0.3, 1.0];


Texture2D!Rgba8 loadTexture() {
    import gfx.core.texture : TextureUsage, TexUsageFlags;
    import gfx.core.util : retypeSlice;
    import libjpeg.turbojpeg;

    auto jpeg = tjInitDecompress();
    auto jpegData = cast(ubyte[])(import("crate.jpg").dup);
    int w; int h; int subsamp;
    if (tjDecompressHeader2(jpeg, jpegData.ptr, jpegData.length, &w, &h, &subsamp) == -1) {
        throw new Exception("cannot decompress jpeg header");
    }
    auto bytes = new ubyte[w*h*4];
    if (tjDecompress2(jpeg, jpegData.ptr, jpegData.length, bytes.ptr, w, 0, h, TJPF.TJPF_RGBA, TJFLAG_FASTDCT) == -1) {
        throw new Exception("cannot decompress jpeg");
    }
    tjDestroy(jpeg);

    auto pixels = retypeSlice!(ubyte[4])(bytes);
    TexUsageFlags usage = TextureUsage.ShaderResource;
    return new Texture2D!Rgba8(usage, 1, cast(ushort)w, cast(ushort)h, [pixels]);
}


void main()
{
	auto window = rc(gfxGlfwWindow!(Rgba8, Depth)("gfx-d - Crate example", 640, 480, 4));
    auto colRtv = rc(window.colorSurface.viewAsRenderTarget());
    auto dsv = rc(window.depthStencilSurface.viewAsDepthStencil());

    auto vbuf = makeRc!(VertexBuffer!Vertex)(crate);
    auto slice = VertexBufferSlice(new IndexBuffer!ushort(crateIndices));
    auto srv = rc(loadTexture().viewAsShaderResource(0, 0, newSwizzle()));
    auto sampler = makeRc!Sampler(srv, SamplerInfo(FilterMethod.Anisotropic, WrapMode.init));

    auto matBlk = makeRc!(ConstBuffer!Matrices)(1);
    auto nlBlk = makeRc!(ConstBuffer!NumLights)(1);
    auto ligBlk = makeRc!(ConstBuffer!Light)(maxNumLights);
    auto prog = makeRc!Program(ShaderSet.vertexPixel(
        import("330-crate.v.glsl"),
        import("330-crate.f.glsl"),
    ));
    auto pso = makeRc!CratePipeline(prog.obj, Primitive.Triangles, Rasterizer.fill.withSamples());
    auto data = CratePipeline.Data(
        vbuf, matBlk, nlBlk, ligBlk, srv, sampler, colRtv, dsv
    );

    auto encoder = Encoder(window.device.makeCommandBuffer());

    // setting lights
    auto normalize(float[4] vec) {
        return vec4(vec).normalized().vector;
    }
    encoder.updateConstBuffer(nlBlk, NumLights(2));
    encoder.updateConstBuffer(ligBlk, [
        Light(normalize([1.0, 1.0, -1.0, 0.0]),    [0.8, 0.5, 0.2, 1.0]),
        Light(normalize([-1.0, 1.0, -1.0, 0.0]),    [0.2, 0.5, 0.8, 1.0]),
    ]);

    // will quit on any key hit (as well as on close by 'x' click)
    window.onKey = (int, int, int, int) {
        window.shouldClose = true;
    };

    // 6 RPM at 60 FPS
    immutable puls = 6 * 2*PI / 3600f;
    auto angle = 0f;
    immutable view = mat4.look_at(vec3(0, -5, 3), vec3(0, 0, 0), vec3(0, 0, 1));
    immutable proj = mat4.perspective(640, 480, 45, 1, 10);
    immutable viewProj = proj*view;

    import std.datetime : StopWatch;
    size_t frameCount;
    StopWatch sw;
    sw.start();

    /* Loop until the user closes the window */
    while (!window.shouldClose) {

        immutable model = mat4.rotation(angle, vec3(0, 0, 1));
        immutable mvp = viewProj*model;
        immutable normals = model.inverse().transposed();
        immutable matrices = Matrices(
            mvp.transposed().matrix,
            normals.transposed().matrix
        );
        encoder.updateConstBuffer(matBlk, matrices);

        encoder.clear!Rgba8(colRtv, backColor);
        encoder.clearDepth(dsv, 1f);
        encoder.draw!CratePipeMeta(slice, pso, data);
        encoder.flush(window.device);

        /* Swap front and back buffers */
        window.swapBuffers();

        /* Poll for and process events */
        window.pollEvents();

        frameCount += 1;
        angle += puls;
    }

    auto msecs = sw.peek().msecs();
    writeln("FPS: ", 1000.0f*frameCount / msecs);
}
