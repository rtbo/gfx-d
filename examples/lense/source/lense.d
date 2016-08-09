module lense;

import gfx.core : Primitive, Rect;
import gfx.core.rc : rc, makeRc, Rc;
import gfx.core.typecons : none, some;
import gfx.core.format : Rgba8, Depth, newSwizzle;
import gfx.core.buffer : VertexBuffer, IndexBuffer, VertexBufferSlice, ConstBuffer;
import gfx.core.program : Program, ShaderSet;
import gfx.core.texture : Texture, Texture2D, Sampler, FilterMethod, WrapMode;
import gfx.core.view : ShaderResourceView, RenderTargetView, DepthStencilView;
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


struct VertexPNT {
    @GfxName("a_Pos")       float[3] pos;
    @GfxName("a_Normal")    float[3] normal;
    @GfxName("a_TexCoord")  float[2] texCoord;
}

struct VertexPT {
    @GfxName("a_Pos")       float[3] pos;
    @GfxName("a_TexCoord")  float[2] texCoord;
}

struct VertexPN {
    @GfxName("a_Pos")       float[3] pos;
    @GfxName("a_Normal")    float[3] normal;
}

struct Matrices {
    float[4][4] mvp;
    float[4][4] normal;
}

struct Light {
    float[4] direction;
    float[4] color;
}


struct MeshPipeMeta {
    VertexInput!VertexPNT   input;

    @GfxName("Matrices")
    ConstantBlock!Matrices  matrices;

    @GfxName("Light")
    ConstantBlock!Light     light;

    @GfxName("t_Sampler")
    ResourceView!Rgba8      texture;

    @GfxName("t_Sampler")
    ResourceSampler         sampler;

    @GfxName("o_Color")
    ColorOutput!Rgba8       outColor;

    @GfxDepth(s.Depth.lessEqualWrite)
    DepthOutput!Depth       outDepth;
}

struct BlitPipeMeta {
    VertexInput!VertexPT    input;

    @GfxName("t_BlitTex")
    ResourceView!Rgba8      texture;

    @GfxName("o_Color")
    ColorOutput!Rgba8       output;
}


struct LensePipeMeta {
    VertexInput!VertexPN    input;

    @GfxName("Matrices")
    ConstantBlock!Matrices  matrices;

    @GfxName("Light")
    ConstantBlock!Light     light;

    @GfxName("t_Sampler")
    ResourceView!Rgba8      texture;

    @GfxName("t_Sampler")
    ResourceSampler         sampler;

    @GfxName("o_Color")
    ColorOutput!Rgba8       outColor;

    @GfxDepth(s.Depth.lessEqualWrite)
    DepthOutput!Depth       outDepth;
}

alias MeshPipeline = PipelineState!MeshPipeMeta;
alias BlitPipeline = PipelineState!BlitPipeMeta;
alias LensePipeline = PipelineState!LensePipeMeta;


immutable crateVertices = [
    // top (0, 0, 1)
    VertexPNT([-1, -1,  1],    [ 0,  0,  1],   [0, 0]),
    VertexPNT([ 1, -1,  1],    [ 0,  0,  1],   [1, 0]),
    VertexPNT([ 1,  1,  1],    [ 0,  0,  1],   [1, 1]),
    VertexPNT([-1,  1,  1],    [ 0,  0,  1],   [0, 1]),
    // bottom (0, 0, -1)
    VertexPNT([-1,  1, -1],    [ 0,  0, -1],   [1, 0]),
    VertexPNT([ 1,  1, -1],    [ 0,  0, -1],   [0, 0]),
    VertexPNT([ 1, -1, -1],    [ 0,  0, -1],   [0, 1]),
    VertexPNT([-1, -1, -1],    [ 0,  0, -1],   [1, 1]),
    // right (1, 0, 0)
    VertexPNT([ 1, -1, -1],    [ 1,  0,  0],   [0, 0]),
    VertexPNT([ 1,  1, -1],    [ 1,  0,  0],   [1, 0]),
    VertexPNT([ 1,  1,  1],    [ 1,  0,  0],   [1, 1]),
    VertexPNT([ 1, -1,  1],    [ 1,  0,  0],   [0, 1]),
    // left (-1, 0, 0)
    VertexPNT([-1, -1,  1],    [-1,  0,  0],   [1, 0]),
    VertexPNT([-1,  1,  1],    [-1,  0,  0],   [0, 0]),
    VertexPNT([-1,  1, -1],    [-1,  0,  0],   [0, 1]),
    VertexPNT([-1, -1, -1],    [-1,  0,  0],   [1, 1]),
    // front (0, 1, 0)
    VertexPNT([ 1,  1, -1],    [ 0,  1,  0],   [1, 0]),
    VertexPNT([-1,  1, -1],    [ 0,  1,  0],   [0, 0]),
    VertexPNT([-1,  1,  1],    [ 0,  1,  0],   [0, 1]),
    VertexPNT([ 1,  1,  1],    [ 0,  1,  0],   [1, 1]),
    // back (0, -1, 0)
    VertexPNT([ 1, -1,  1],    [ 0, -1,  0],   [0, 0]),
    VertexPNT([-1, -1,  1],    [ 0, -1,  0],   [1, 0]),
    VertexPNT([-1, -1, -1],    [ 0, -1,  0],   [1, 1]),
    VertexPNT([ 1, -1, -1],    [ 0, -1,  0],   [0, 1]),
];

immutable ushort[] crateIndices = [
     0,  1,  2,  2,  3,  0, // top
     4,  5,  6,  6,  7,  4, // bottom
     8,  9, 10, 10, 11,  8, // right
    12, 13, 14, 14, 15, 12, // left
    16, 17, 18, 18, 19, 16, // front
    20, 21, 22, 22, 23, 20, // back
];

immutable squareVertices = [
    VertexPT([-1, -1, 0], [0, 0]),
    VertexPT([ 1, -1, 0], [1, 0]),
    VertexPT([ 1,  1, 0], [1, 1]),

    VertexPT([ 1,  1, 0], [1, 1]),
    VertexPT([-1,  1, 0], [0, 1]),
    VertexPT([-1, -1, 0], [0, 0]),
];


immutable float[4] backColor = [0.1, 0.2, 0.3, 1.0];


Texture2D!Rgba8 loadCrateTexture() {
    import gfx.core.texture : TextureUsage, TexUsageFlags;
    import gfx.core.util : retypeSlice;
    import libjpeg.turbojpeg;
    import core.stdc.config : c_ulong;

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
    TexUsageFlags usage = TextureUsage.ShaderResource;
    return new Texture2D!Rgba8(usage, 1, cast(ushort)w, cast(ushort)h, [pixels]);
}

Texture2D!Rgba8 makeGridTexture(in ushort w, in ushort h) {
    import gfx.core.texture : TextureUsage, TexUsageFlags;
    enum num = 12;
    immutable wn = w / num;
    immutable hn = h / num;
    auto texels = new ubyte[4][w*h];
    foreach (r; 0 .. h) {
        foreach (c; 0 .. w) {
            ubyte[4] val = [235, 235, 235, 255];
            if (r % hn == 0 || c % wn == 0) {
                val = [20, 20, 20, 255];
            }
            texels[r*w+c] = val;
        }
    }
    TexUsageFlags usage = TextureUsage.ShaderResource;
    return new Texture2D!Rgba8(usage, 1, w, h, [texels]);
}

struct MeshViews {
    Rc!(RenderTargetView!Rgba8)     colRtv;
    Rc!(ShaderResourceView!Rgba8)   colSrv;
    Rc!(DepthStencilView!Depth)     depDsv;
    Rc!(ShaderResourceView!Depth)   depSrv;

    static MeshViews make(in ushort w, in ushort h) {
        import gfx.core.texture : TextureUsage, TexUsageFlags;
        import gfx.core.view : DSVReadOnly, DSVReadOnlyFlags;

        Texture!Fmt makeTexture(Fmt)(in ushort w, in ushort h, TextureUsage usage) {
            TexUsageFlags usageFl = TextureUsage.ShaderResource | usage;
            return new Texture2D!Fmt(usageFl, 1, w, h);
        }

        auto colT = rc(makeTexture!Rgba8(w, h, TextureUsage.RenderTarget));
        auto depT = rc(makeTexture!Depth(w, h, TextureUsage.DepthStencil));
        immutable fl = DSVReadOnlyFlags.init;

        return MeshViews (
            rc(colT.viewAsRenderTarget(0, none!ubyte)),
            rc(colT.viewAsShaderResource(0, 0, newSwizzle())),
            rc(depT.viewAsDepthStencil(0, none!ubyte, fl)),
            rc(depT.viewAsShaderResource(0, 0, newSwizzle())),
        );
    }
}


// position: 2 combined rotations pulsations around screen axis
// orientation: a 3rd rotation with varying axis
struct CrateTransform {
    private enum r1         = 2f;
    private enum r2         = 0.5f;
    private enum p1         = 6 * 2*PI / 3600f;
    private enum p2         = 8 * 2*PI / 3600f;
    private enum p3         = 10 * 2*PI / 3600f;

    private enum axis12     = vec3(0, 0, 1);
    private vec3 axis3      = vec3(0, 0, 1);
    private float angle1    = 0f;
    private float angle2    = 0f;
    private float angle3    = 0f;

    @property mat4 get() const {
        mat4 m = mat4.rotation(angle3, axis3.normalized());
        m.translate(r2, 0, 0);
        m.rotate(angle2, axis12);
        m.translate(r1, 0, 0);
        m.rotate(angle1, axis12);
        return m;
    }

    void tick() {
        import std.math : sin, cos;
        angle1 += p1; if (angle1 > 2*PI) angle1 -= 2*PI;
        angle2 += p2; if (angle2 > 2*PI) angle2 -= 2*PI;
        angle3 += p3; if (angle3 > 2*PI) angle3 -= 2*PI;
        axis3 = vec3(sin(angle1), cos(angle2), sin(angle3));
    }
}

struct LenseTransform {
    private float x = 0f;
    private float y = 0f;
    private enum z = 0f;

    void set(in float x, in float y) {
        this.x = x; this.y = y;
    }

    @property mat4 get() const {
        //return mat4.rotation(angle, vec3(0, 1, 0));
        //return mat4.identity;
        return mat4.translation(x, y, z);
    }
}

struct Mesh {
    Rc!(VertexBuffer!VertexPNT)     vbuf;
    VertexBufferSlice               slice;
    Rc!(ConstBuffer!Matrices)       matBlk;
    Rc!(ConstBuffer!Light)          ligBlk;
    Rc!(ShaderResourceView!Rgba8)   srv;
    Rc!Sampler                      sampler;
    Rc!(RenderTargetView!Rgba8)     rtv;
    Rc!(DepthStencilView!Depth)     dsv;

    @property MeshPipeline.Data data() {
        return MeshPipeline.Data (
            vbuf, matBlk, ligBlk, srv, sampler, rtv, dsv
        );
    }
}

struct LenseData {
    VertexPN[] vertices;
    ushort[] indices;
}

LenseData makeLense(in float lenseRadius, in float sphRadius) {
    import std.math : asin, sin, cos;

    enum ushort numPerCircle = 64;
    enum ushort numCircles = 12;

    immutable angleDiff = 2*PI / numPerCircle;
    immutable radAngleDiff = asin(lenseRadius / sphRadius) / numCircles;

    LenseData res;

    // front face
    res.vertices ~= VertexPN([0, 0, 0], [0, 0, 1]);
    foreach(c; 0 .. numCircles) {
        immutable radAngle = (c+1) * radAngleDiff;
        immutable rad = sphRadius * sin(radAngle);
        immutable z = -sphRadius * (1 - cos(radAngle));
        immutable nz = cos(radAngle);
        immutable nxy = sin(radAngle);
        foreach(v; 0 .. numPerCircle) {
            immutable angle = v * angleDiff;
            res.vertices ~= VertexPN(
                [ rad*cos(angle), rad*sin(angle), z ],
                [ nxy*cos(angle), nxy*sin(angle), nz]
            );
        }
    }

    // back face
    immutable radAngle = numCircles * radAngleDiff;
    immutable rad = sphRadius * sin(radAngle);
    immutable z = -sphRadius * (1 - cos(radAngle));
    foreach(v; 0 .. numPerCircle) {
        immutable angle = v * angleDiff;
        res.vertices ~= VertexPN(
            [rad*cos(angle), rad*sin(angle), z], [0, 0, -1]
        );
    }
    res.vertices ~= VertexPN([0, 0, z], [0, 0, -1]);

    // indices
    foreach (ushort v; 0 .. numPerCircle) {
        ushort i2 = cast(ushort)((v == numPerCircle-1) ? 1 : v + 2);
        res.indices ~= [0, cast(ushort)(v+1), i2];
    }
    foreach (ushort c; 0 .. numCircles) {
        immutable ushort c1start = cast(ushort)(c * numPerCircle + 1);
        immutable ushort c2start = cast(ushort)((c+1) * numPerCircle + 1);
        foreach (ushort v; 0 .. numPerCircle) {
            ushort c1i2 = cast(ushort)((v == numPerCircle-1) ? c1start : c1start+v+1);
            ushort c2i2 = cast(ushort)((v == numPerCircle-1) ? c2start : c2start+v+1);
            res.indices ~= [
                cast(ushort)(c1start+v), cast(ushort)(c2start+v), c2i2,
                cast(ushort)(c1start+v), c2i2, c1i2
            ];
        }
    }
    ushort base = numCircles*numPerCircle+1;
    ushort last = (numCircles+1)*numPerCircle+1;
    foreach (ushort v; 0 .. numPerCircle) {
        ushort i2 = cast(ushort)((v == numPerCircle-1) ? base : v + base + 1);
        res.indices ~= [ last, i2, cast(ushort)(base + v)];
    }

    return res;
}


struct FPSProbe {
    import std.datetime : StopWatch;

    size_t frameCount;
    StopWatch sw;

    void start() { sw.start(); }
    void tick() { frameCount += 1; }
    @property float fps() const {
        auto msecs = sw.peek().msecs();
        return 1000f * frameCount / msecs;
    }
}


void main()
{
    enum winW = 640; enum winH = 480;
    enum aspect = float(winW) / float(winH);

	auto window = rc(gfxGlfwWindow!(Rgba8, Depth)("gfx-d - Lense example", winW, winH, 4));
    auto winRtv = rc(window.colorSurface.viewAsRenderTarget());
    auto winDsv = rc(window.depthStencilSurface.viewAsDepthStencil());

    auto meshViews = MeshViews.make(2*winW, 2*winH);
    auto meshProg = makeRc!Program(ShaderSet.vertexPixel(
        import("330-mesh.v.glsl"), import("330-mesh.f.glsl"),
    ));
    auto meshPso = makeRc!MeshPipeline(meshProg, Primitive.Triangles, Rasterizer.fill);

    auto ligBlk = makeRc!(ConstBuffer!Light)(1);

    auto crateSrv = rc(loadCrateTexture().viewAsShaderResource(0, 0, newSwizzle()));
    auto crate = Mesh(
        makeRc!(VertexBuffer!VertexPNT)(crateVertices),
        VertexBufferSlice(new IndexBuffer!ushort(crateIndices)),
        makeRc!(ConstBuffer!Matrices)(1), ligBlk,
        crateSrv, makeRc!Sampler(crateSrv, FilterMethod.Anisotropic, WrapMode.init),
        meshViews.colRtv, meshViews.depDsv
    );
    auto crateData = crate.data;
    import std.algorithm : map;
    import std.array : array;
    auto gridVertices = squareVertices.map!(v => VertexPNT(v.pos, [0, 0, 1], v.texCoord)).array;
    auto gridSrv = rc(makeGridTexture(640, 480).viewAsShaderResource(0, 0, newSwizzle()));
    auto grid = Mesh(
        makeRc!(VertexBuffer!VertexPNT)(gridVertices),
        VertexBufferSlice(squareVertices.length),
        makeRc!(ConstBuffer!Matrices)(1), ligBlk,
        gridSrv, makeRc!Sampler(gridSrv, FilterMethod.Bilinear, WrapMode.init),
        meshViews.colRtv, meshViews.depDsv
    );
    auto gridData = grid.data;

    auto blitProg = makeRc!Program(ShaderSet.vertexPixel(
        import("330-blit.v.glsl"), import("330-blit.f.glsl")
    ));
    auto blitPso = makeRc!BlitPipeline(blitProg, Primitive.Triangles, Rasterizer.fill);
    auto blitSlice = VertexBufferSlice(squareVertices.length);
    auto blitData = BlitPipeline.Data(
        makeRc!(VertexBuffer!VertexPT)(squareVertices), meshViews.colSrv, winRtv
    );

    auto lenseProg = makeRc!Program(ShaderSet.vertexPixel(
        import("330-lense.v.glsl"), import("330-lense.f.glsl")
    ));
    auto lensePso = makeRc!LensePipeline(lenseProg, Primitive.Triangles, Rasterizer.fill);
    auto lenseMeshData = makeLense(1, 3);
    auto lenseSlice = VertexBufferSlice(new IndexBuffer!ushort(lenseMeshData.indices));
    auto lenseData = LensePipeline.Data(
        makeRc!(VertexBuffer!VertexPN)(lenseMeshData.vertices),
        makeRc!(ConstBuffer!Matrices)(1), ligBlk,
        meshViews.colSrv, makeRc!Sampler(meshViews.colSrv, FilterMethod.Anisotropic, WrapMode.init),
        winRtv, winDsv
    );


    auto encoder = Encoder(window.device.makeCommandBuffer());

    // setting lights
    auto normalize(float[4] vec) {
        return vec4(vec).normalized().vector;
    }
    encoder.updateConstBuffer(ligBlk,
        Light(normalize([0.3, 0.3, -1.0, 0.0]),    [1f, 1f, 1f, 1f]),
    );

    immutable view = mat4.look_at(vec3(0, 0, 8), vec3(0, 0, 0), vec3(0, 1, 0));
    immutable proj = mat4.perspective(winW, winH, 45, 1, 20);
    immutable viewProj = proj*view;

    void updateMatrices(in mat4 model, ConstBuffer!Matrices blk) {
        immutable mvp = viewProj*model;
        immutable normals = model.inverse().transposed();
        immutable matrices = Matrices(
            mvp.transposed().matrix,
            normals.transposed().matrix
        );
        encoder.updateConstBuffer(blk, matrices);
    }

    CrateTransform crateTransform;
    LenseTransform lenseTransform;

    // grid will be at -4 in Z and cam at +8
    // must scale it to fill screen
    updateMatrices(mat4.scaling(5*aspect, 5, 1).translate(0, 0, -4), grid.matBlk);
    // setting initial lense pos
    updateMatrices(lenseTransform.get, lenseData.matrices);

    // will quit on any key hit (as well as on close by 'x' click)
    window.onKey = (int, int, int, int) {
        window.shouldClose = true;
    };
    // set the lense position
    window.onCursorPos = (double xpos, double ypos) {
        immutable x = (2*xpos / winW) - 1;
        immutable y = (2*(winH-ypos) / winH) - 1;
        lenseTransform.set(3.5*x, 3.5*y);
        updateMatrices(lenseTransform.get, lenseData.matrices);
    };

    FPSProbe fps;
    fps.start();

    /* Loop until the user closes the window */
    while (!window.shouldClose) {

        encoder.clear!Rgba8(winRtv, backColor);
        encoder.clearDepth(winDsv, 1f);

        encoder.clear!Rgba8(meshViews.colRtv, backColor);
        encoder.clearDepth(meshViews.depDsv, 1f);

        // draw grid and crate into texture
        encoder.setViewport(Rect(0, 0, 2*winW, 2*winH));
        encoder.draw!MeshPipeMeta(grid.slice, meshPso, gridData);
        updateMatrices(crateTransform.get, crate.matBlk);
        encoder.draw!MeshPipeMeta(crate.slice, meshPso, crateData);

        // blit texture to window
        encoder.setViewport(Rect(0, 0, winW, winH));
        encoder.draw!BlitPipeMeta(blitSlice, blitPso, blitData);

        // draw lense
        updateMatrices(lenseTransform.get, lenseData.matrices);
        encoder.draw!LensePipeMeta(lenseSlice, lensePso, lenseData);

        encoder.flush(window.device);
        window.swapBuffers();
        window.pollEvents();

        crateTransform.tick();
        fps.tick();
    }

    writeln("FPS: ", fps.fps);
}
