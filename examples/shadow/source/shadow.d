module shadow;

import gfx.core : Primitive, Rect, Device;
import gfx.core.rc : rc, makeRc, Rc, rcCode, RefCounted;
import gfx.core.typecons : none, some;
import gfx.core.format : Rgba8, Depth, newSwizzle;
import gfx.core.buffer : VertexBuffer, IndexBuffer, VertexBufferSlice, ConstBuffer;
import gfx.core.program : Program, ShaderSet;
import gfx.core.texture : Texture, Texture2D, Sampler, SamplerInfo, FilterMethod, WrapMode;
import gfx.core.view : ShaderResourceView, RenderTargetView, DepthStencilView;
import gfx.core.draw : clearColor, Instance;
import s = gfx.core.state : Rasterizer;
import gfx.core.pso.meta;
import gfx.core.pso : PipelineState;
import gfx.core.encoder : Encoder;
import gfx.window.glfw : Window, gfxGlfwWindow;

import gl3n.linalg : mat4, mat3, vec3, vec4, quat, Vector;

import std.stdio : writeln, writefln;
import std.math : PI;

enum maxNumLights = 5;

struct Vertex {
    @GfxName("a_Pos")       float[3] pos;
    @GfxName("a_Normal")    float[3] normal;
}

struct ShadowVsLocals {
    float[4][4] transform;
}

struct MeshVsLocals {
    float[4][4] modelViewProj;
    float[4][4] model;
}
struct MeshPsLocals {
    float[4]    matColor;
    int         numLights;
    int[3]      padding;
    this(float[4] mc, int nl) {
        matColor = mc; numLights = nl;
    }
}
struct LightParam {
    float[4]    pos;
    float[4]    color;
    float[4][4] proj;
}


// shadow pass pipeline: render into z-buffer what is viewed from light
struct ShadowPipeMeta {
    VertexInput!Vertex              input;

    @GfxName("Locals")
    ConstantBlock!ShadowVsLocals    locals;

    @GfxDepth(s.Depth.lessEqualWrite)
    DepthOutput!Depth               output;
}

// render pass pipeline: render lighted meshes and sample shadow from z-buffer texture
struct MeshPipeMeta {
    VertexInput!Vertex              input;

    @GfxName("VsLocals")
    ConstantBlock!MeshVsLocals      vsLocals;

    @GfxName("PsLocals")
    ConstantBlock!MeshPsLocals      psLocals;

    @GfxName("Lights")
    ConstantBlock!LightParam        lights;

    @GfxName("u_Shadow")
    ResourceView!Depth              shadow;

    @GfxName("u_Shadow")
    ResourceSampler                 shadowSampler;

    @GfxName("o_Color")
    ColorOutput!Rgba8               colorOutput;

    @GfxDepth(s.Depth.lessEqualWrite)
    DepthOutput!Depth               depthOutput;
}


alias ShadowPipeline = PipelineState!ShadowPipeMeta;
alias MeshPipeline = PipelineState!MeshPipeMeta;


immutable float[4] background = [0.1, 0.2, 0.3, 1.0];


immutable cubeVertices = [
    // top (0, 0, 1)
    Vertex([-1, -1,  1],    [ 0,  0,  1]),
    Vertex([ 1, -1,  1],    [ 0,  0,  1]),
    Vertex([ 1,  1,  1],    [ 0,  0,  1]),
    Vertex([-1,  1,  1],    [ 0,  0,  1]),
    // bottom (0, 0, -1)
    Vertex([-1,  1, -1],    [ 0,  0, -1]),
    Vertex([ 1,  1, -1],    [ 0,  0, -1]),
    Vertex([ 1, -1, -1],    [ 0,  0, -1]),
    Vertex([-1, -1, -1],    [ 0,  0, -1]),
    // right (1, 0, 0)
    Vertex([ 1, -1, -1],    [ 1,  0,  0]),
    Vertex([ 1,  1, -1],    [ 1,  0,  0]),
    Vertex([ 1,  1,  1],    [ 1,  0,  0]),
    Vertex([ 1, -1,  1],    [ 1,  0,  0]),
    // left (-1, 0, 0)
    Vertex([-1, -1,  1],    [-1,  0,  0]),
    Vertex([-1,  1,  1],    [-1,  0,  0]),
    Vertex([-1,  1, -1],    [-1,  0,  0]),
    Vertex([-1, -1, -1],    [-1,  0,  0]),
    // front (0, 1, 0)
    Vertex([ 1,  1, -1],    [ 0,  1,  0]),
    Vertex([-1,  1, -1],    [ 0,  1,  0]),
    Vertex([-1,  1,  1],    [ 0,  1,  0]),
    Vertex([ 1,  1,  1],    [ 0,  1,  0]),
    // back (0, -1, 0)
    Vertex([ 1, -1,  1],    [ 0, -1,  0]),
    Vertex([-1, -1,  1],    [ 0, -1,  0]),
    Vertex([-1, -1, -1],    [ 0, -1,  0]),
    Vertex([ 1, -1, -1],    [ 0, -1,  0]),
];

immutable ushort[] cubeIndices = [
     0,  1,  2,  2,  3,  0, // top
     4,  5,  6,  6,  7,  4, // bottom
     8,  9, 10, 10, 11,  8, // right
    12, 13, 14, 14, 15, 12, // left
    16, 17, 18, 18, 19, 16, // front
    20, 21, 22, 22, 23, 20, // back
];


immutable planeVertices = [
    Vertex([-1, -1,  0],    [ 0,  0,  1]),
    Vertex([ 1, -1,  0],    [ 0,  0,  1]),
    Vertex([ 1,  1,  0],    [ 0,  0,  1]),
    Vertex([-1,  1,  0],    [ 0,  0,  1]),
];

immutable ushort[] planeIndices = [
     0,  1,  2,  2,  3,  0,
];

struct Mesh {
    mat4                modelMat;
    vec4                color;
    ShadowPipeline.Data shadowData;
    MeshPipeline.Data   meshData;
    VertexBufferSlice   slice;
    bool                dynamic;
}

struct Light {
    vec4                        position;
    mat4                        viewMat;
    mat4                        projMat;
    vec4                        color;
    Rc!(DepthStencilView!Depth) shadow;
    Encoder                     encoder;
}

class Scene : RefCounted {
    mixin(rcCode);

    Rc!(ConstBuffer!LightParam) lightBlk;
    Light[]                     lights;
    Mesh[]                      meshes;

    this(Device device, RenderTargetView!Rgba8 winRtv, DepthStencilView!Depth winDsv) {
        import std.algorithm : map;
        import std.array : array;

        auto makeShadowTex() {
            import gfx.core.texture : TextureUsage, TexUsageFlags, Texture2DArray;

            TexUsageFlags usage = TextureUsage.DepthStencil | TextureUsage.ShaderResource;
            return new Texture2DArray!Depth(usage, 1, 1024, 1024, maxNumLights);
        }
        auto shadowTex = makeShadowTex().rc;
        auto shadowSrv = shadowTex.viewAsShaderResource(0, 0, newSwizzle()).rc;
        auto shadowSampler = new Sampler(shadowSrv,
                    SamplerInfo(FilterMethod.Bilinear, WrapMode.Clamp)
                    .withComparison(s.Comparison.LessEqual)).rc;

        enum near = 1f;
        enum far = 20f;

        auto makeLight(ubyte layer, float[3] pos, float[4] color, float fov) {
            import gfx.core.texture : DSVReadOnlyFlags;
            return Light(
                vec4(pos, 1),
                mat4.look_at(vec3(pos), vec3(0, 0, 0), vec3(0, 0, 1)),
                mat4.perspective(100, 100, fov, near, far),
                vec4(color),
                shadowTex.viewAsDepthStencil(0, some(layer), DSVReadOnlyFlags.init).rc,
                Encoder(device.makeCommandBuffer())
            );
        }

        auto lights = [
            makeLight(0, [7, -5, 10], [0.5, 0.65, 0.5, 1], 60),
            makeLight(1, [-5, 7, 10], [0.65, 0.5, 0.5, 1], 45),
        ];

        auto cubeBuf = makeRc!(VertexBuffer!Vertex)(cubeVertices);
        auto cubeSlice = VertexBufferSlice(new IndexBuffer!ushort(cubeIndices));
        auto planeBuf = makeRc!(VertexBuffer!Vertex)(planeVertices.map!(
            v => Vertex((vec3(v.pos)*7).vector, v.normal)
        ).array());
        auto planeSlice = VertexBufferSlice(new IndexBuffer!ushort(planeIndices));

        auto shadowLocals = makeRc!(ConstBuffer!ShadowVsLocals)(1);
        auto meshVsLocals = makeRc!(ConstBuffer!MeshVsLocals)(1);
        auto meshPsLocals = makeRc!(ConstBuffer!MeshPsLocals)(1);
        auto lightBlk = makeRc!(ConstBuffer!LightParam)(maxNumLights);

        auto makeMesh(in mat4 modelMat, in float[4] color, VertexBuffer!Vertex vbuf,
                VertexBufferSlice slice, bool dynamic) {
            ShadowPipeline.Data shadowData;
            shadowData.input = vbuf;
            shadowData.locals = shadowLocals;
            // shadowData.output will be set for each light at render time

            auto meshData = MeshPipeline.Data (
                vbuf.rc, meshVsLocals, meshPsLocals, lightBlk,
                shadowSrv, shadowSampler, winRtv.rc, winDsv.rc
            );

            return Mesh(modelMat, vec4(color), shadowData, meshData, slice, dynamic);
        }

        auto makeCube(in float[3] pos, in float scale, in float angle, in float[4] color) {
            immutable offset = vec3(pos);

            immutable r = quat.axis_rotation(angle*PI/180.0, offset.normalized).to_matrix!(4, 4);
            immutable t = mat4.translation(offset);
            immutable s = mat4.scaling(scale, scale, scale);
            immutable model = t * s * r;
            return makeMesh(model, color, cubeBuf, cubeSlice, true);
        }

        this.lightBlk = lightBlk;
        this.lights = lights;
        this.meshes = [
            makeCube([-2, -2, 2], 0.7, 10, [0.8, 0.2, 0.2, 1]),
            makeCube([2, -2, 2], 1.3, 50, [0.2, 0.8, 0.2, 1]),
            makeCube([-2, 2, 2], 1.1, 140, [0.2, 0.2, 0.8, 1]),
            makeCube([2, 2, 2], 0.9, 210, [0.8, 0.8, 0.2, 1]),
            makeMesh(mat4.identity, [1, 1, 1, 1], planeBuf, planeSlice, false)
        ];
    }

    void drop() {
        foreach(ref l; lights) {
            l.shadow.unload();
            l.encoder = Encoder.init;
        }
        foreach(ref m; meshes) {
            m.shadowData = ShadowPipeline.Data.init;
            m.meshData = MeshPipeline.Data.init;
            m.slice = VertexBufferSlice.init;
        }
    }

    void tick() {
        import std.algorithm : filter, each;
        immutable axis = vec3(0, 0, 1);
        immutable angle = 0.3 * PI / 180;
        immutable r = quat.axis_rotation(angle, axis).to_matrix!(4, 4);
        meshes.filter!(m => m.dynamic).each!((ref Mesh m) {
            m.modelMat *= r;
        });
    }
}

struct FPSProbe {
    import std.datetime : StopWatch;

    private size_t frameCount;
    private StopWatch sw;

    void start() { sw.start(); }
    void tick() { frameCount += 1; }
    @property float fps() const {
        auto msecs = sw.peek().msecs();
        return 1000f * frameCount / msecs;
    }
}


void main() {
    enum winW = 800; enum winH = 520;
    enum aspect = float(winW) / float(winH);

	auto window = gfxGlfwWindow!(Rgba8, Depth)("gfx-d - Shadow example", winW, winH, 4).rc;
    auto winRtv = window.colorSurface.viewAsRenderTarget().rc;
    auto winDsv = window.depthStencilSurface.viewAsDepthStencil().rc;

    auto shadowProg = makeRc!Program(ShaderSet.vertexPixel(
        import("330-shadow.v.glsl"), import("330-shadow.f.glsl")
    ));
    auto shadowPso = makeRc!ShadowPipeline(shadowProg.obj, Primitive.Triangles,
            Rasterizer.fill .withSamples()
                            .withCullBack()
                            .withOffset(2.0, 1)
    );

    auto meshProg = makeRc!Program(ShaderSet.vertexPixel(
        import("330-mesh.v.glsl"), import("330-mesh.f.glsl")
    ));
    auto meshPso = makeRc!MeshPipeline(meshProg.obj, Primitive.Triangles,
            Rasterizer.fill .withSamples()
                            .withCullBack()
    );

    auto sc = new Scene(window.device, winRtv, winDsv).rc;
    immutable bool parallelLightCmds = true;

    auto encoder = Encoder(window.device.makeCommandBuffer());

    immutable projMat = mat4.perspective(winW, winH, 45, 1f, 20f);
    immutable viewProjMat = projMat * mat4.look_at(vec3(3, -10, 6), vec3(0, 0, 0), vec3(0, 0, 1));


    float[4][4] columnMajor(in mat4 m) { return m.transposed().matrix; }

    import std.algorithm : map;
    import std.array : array;

    LightParam[] lights = sc.lights.map!(
        l => LightParam(l.position.vector, l.color.vector, columnMajor(l.projMat*l.viewMat))
    ).array();
    encoder.updateConstBuffer(sc.lightBlk, lights);

    encoder.flush(window.device);

    // will quit on any key hit (as well as on close by 'x' click)
    window.onKey = (int, int, int, int) { window.shouldClose = true; };

    FPSProbe fps;
    fps.start();

    while (!window.shouldClose) {


        encoder.setViewport(Rect(0, 0, 1024, 1024));
        if (parallelLightCmds) {
            import std.parallelism : parallel;

            foreach (light; parallel(sc.lights)) {
                encoder.clearDepth(light.shadow, 1);
                foreach (m; sc.meshes) {
                    m.shadowData.output = light.shadow;

                    immutable locals = ShadowVsLocals (
                        columnMajor(light.projMat * light.viewMat * m.modelMat)
                    );
                    light.encoder.updateConstBuffer(m.shadowData.locals, locals);
                    light.encoder.draw!ShadowPipeMeta(m.slice, shadowPso, m.shadowData);
                }
            }

            encoder.flush(window.device);
            foreach (light; sc.lights) {
                light.encoder.flush(window.device);
            }
        }
        else {
            foreach (i, light; sc.lights) {
                encoder.clearDepth(light.shadow, 1);
                foreach (m; sc.meshes) {
                    m.shadowData.output = light.shadow;

                    immutable locals = ShadowVsLocals (
                        columnMajor(light.projMat * light.viewMat * m.modelMat)
                    );
                    encoder.updateConstBuffer(m.shadowData.locals, locals);
                    encoder.draw!ShadowPipeMeta(m.slice, shadowPso, m.shadowData);
                }
            }
        }

        encoder.setViewport(Rect(0, 0, winW, winH));
        encoder.clear!Rgba8(winRtv, background);
        encoder.clearDepth(winDsv, 1f);

        foreach (m; sc.meshes) {
            immutable vsLocals = MeshVsLocals (
                columnMajor(viewProjMat * m.modelMat),
                columnMajor(m.modelMat),
            );
            immutable psLocals = MeshPsLocals(
                m.color.vector, cast(int)lights.length
            );

            encoder.updateConstBuffer(m.meshData.vsLocals, vsLocals);
            encoder.updateConstBuffer(m.meshData.psLocals, psLocals);
            encoder.draw!MeshPipeMeta(m.slice, meshPso, m.meshData);
        }

        encoder.flush(window.device);

        window.swapBuffers();
        window.pollEvents();

        sc.tick();
        fps.tick();
    }

    writeln("FPS: ", fps.fps);
}