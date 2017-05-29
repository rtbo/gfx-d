module crate;

import gfx.foundation.rc;
import gfx.foundation.typecons;
import gfx.pipeline;
import gfx.window.glfw;

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

    @GfxDepth(DepthTest.lessEqualWrite)
    DepthOutput!Depth       outDepth;
}

alias CratePipeline = PipelineState!CratePipeMeta;


immutable float[4] backColor = [0.1, 0.2, 0.3, 1.0];


Texture2D!Rgba8 loadTexture() {
    import gfx.pipeline.texture : TextureUsage, TexUsageFlags;
    import gfx.foundation.util : retypeSlice;
    import libjpeg.turbojpeg;

    auto jpeg = tjInitDecompress();
    auto jpegData = cast(ubyte[])(import("crate.jpg").dup);
    int w; int h; int subsamp;
    if (tjDecompressHeader2(jpeg, jpegData.ptr, cast(c_ulong)jpegData.length, &w, &h, &subsamp) == -1) {
        throw new Exception("cannot decompress jpeg header");
    }
    auto bytes = new ubyte[w*h*4];
    if (tjDecompress2(jpeg, jpegData.ptr, cast(c_ulong)jpegData.length, bytes.ptr, w, 0, h, TJPF.TJPF_RGBA, TJFLAG_FASTDCT) == -1) {
        throw new Exception("cannot decompress jpeg");
    }
    tjDestroy(jpeg);

    auto pixels = retypeSlice!(ubyte[4])(bytes);
    TexUsageFlags usage = TextureUsage.shaderResource;
    return new Texture2D!Rgba8(usage, 1, cast(ushort)w, cast(ushort)h, [pixels]);
}


void main()
{
    import gfx.genmesh.cube : genCube;
    import gfx.genmesh.poly : quad;
    import gfx.genmesh.algorithm;
    import std.algorithm : map;

	auto window = rc(gfxGlfwWindow!(Rgba8, Depth)("gfx-d - Crate example", 640, 480, 4));
    auto colRtv = rc(window.colorSurface.viewAsRenderTarget());
    auto dsv = rc(window.depthStencilSurface.viewAsDepthStencil());

    auto crate = genCube()
            .map!(f => quad(
                Vertex(f[0].p, f[0].n, [0f, 0f]),
                Vertex(f[1].p, f[1].n, [1f, 0f]),
                Vertex(f[2].p, f[2].n, [1f, 1f]),
                Vertex(f[3].p, f[3].n, [0f, 1f]),
            ))
            .triangulate()
            .vertices()
            .indexCollectMesh();

    auto vbuf = makeRc!(VertexBuffer!Vertex)(crate.vertices);
    auto slice = VertexBufferSlice(new IndexBuffer!ushort(crate.indices));
    auto srv = rc(loadTexture().viewAsShaderResource(0, 0, newSwizzle()));
    auto sampler = makeRc!Sampler(srv, SamplerInfo(FilterMethod.anisotropic, WrapMode.init));

    auto matBlk = makeRc!(ConstBuffer!Matrices)(1);
    auto nlBlk = makeRc!(ConstBuffer!NumLights)(1);
    auto ligBlk = makeRc!(ConstBuffer!Light)(maxNumLights);
    auto prog = makeRc!Program(ShaderSet.vertexPixel(
        import("330-crate.v.glsl"),
        import("330-crate.f.glsl"),
    ));
    auto pso = makeRc!CratePipeline(prog.obj, Primitive.triangles, Rasterizer.fill.withSamples());
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
