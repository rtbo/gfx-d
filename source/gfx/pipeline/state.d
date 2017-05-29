module gfx.pipeline.state;

import gfx.foundation.typecons : SafeUnion, Option, none;

import std.typecons : BitFlags, Yes;


enum FrontFace {
    cw, ccw,
}

enum CullFace {
    none, front, back,
}

/// Width of a line.
alias LineWidth = float;
/// Slope depth offset factor
alias OffsetSlope = float;
/// Number of units to offset, where
/// the unit is the minimal difference in the depth value
/// dictated by the precision of the depth buffer.
alias OffsetUnits = int;

/// How to offset vertices in screen space, if at all.
struct Offset {
    OffsetSlope slope;
    OffsetUnits units;
}


alias RasterMethod = SafeUnion!(
    "Point",
    "Line", LineWidth,
    "Fill",
);



struct Rasterizer {
    FrontFace frontFace;
    CullFace cullFace;
    RasterMethod method;
    Option!Offset offset;
    bool samples;

    @property static Rasterizer fill() {
        return Rasterizer(
            FrontFace.ccw,
            CullFace.none,
            RasterMethod.makeFill(),
            none!Offset,
            false
        );
    }

    Rasterizer withCullBack() const {
        Rasterizer res = this;
        res.cullFace = CullFace.back;
        return res;
    }

    Rasterizer withOffset(OffsetSlope slope, OffsetUnits units) const {
        Rasterizer res = this;
        res.offset = Offset(slope, units);
        return res;
    }

    Rasterizer withSamples() const {
        Rasterizer res = this;
        res.samples = true;
        return  res;
    }
}



/// A pixel-wise comparison function.
enum Comparison {
    /// `false`
    never,
    /// `x < y`
    less,
    /// `x <= y`
    lessEqual,
    /// `x == y`
    equal,
    /// `x >= y`
    greaterEqual,
    /// `x > y`
    greater,
    /// `x != y`
    notEqual,
    /// `true`
    always,
}

/// Stencil mask operation.
enum StencilOp {
    /// Keep the current value in the stencil buffer (no change).
    keep,
    /// Set the value in the stencil buffer to zero.
    zero,
    /// Set the stencil buffer value to `value` from `StencilSide`
    replace,
    /// Increment the stencil buffer value, clamping to its maximum value.
    incrementClamp,
    /// Increment the stencil buffer value, wrapping around to 0 on overflow.
    incrementWrap,
    /// Decrement the stencil buffer value, clamping to its minimum value.
    decrementClamp,
    /// Decrement the stencil buffer value, wrapping around to the maximum value on overflow.
    decrementWrap,
    /// Bitwise invert the current value in the stencil buffer.
    invert,
}

/// Complete stencil state for a given side of a face.
struct StencilSide {
    /// Comparison function to use to determine if the stencil test passes.
    Comparison fun          = Comparison.always;
    /// A mask that is ANDd with both the stencil buffer value and the reference value when they
    /// are read before doing the stencil test.
    ubyte maskRead          = ubyte.max;
    /// A mask that is ANDd with the stencil value before writing to the stencil buffer.
    ubyte maskWrite         = ubyte.max;
    /// What operation to do if the stencil test fails.
    StencilOp opFail        = StencilOp.keep;
    /// What operation to do if the stenil test passes but the depth test fails.
    StencilOp opDepthFail   = StencilOp.keep;
    /// What operation to do if both the depth and stencil test pass.
    StencilOp opPass        = StencilOp.keep;
}


/// Complete stencil state, specifying how to handle the front and back side of a face.
struct StencilTest {
    StencilSide front;
    StencilSide back;

    this(StencilSide front, StencilSide back) {
        this.front = front;
        this.back = back;
    }

    this(Comparison fun, ubyte mask, StencilOp[3] ops) {
        auto side = StencilSide(fun, mask, mask, ops[0], ops[1], ops[2]);
        this.front = side;
        this.back = side;
    }
}

/// Depth test state.
struct DepthTest {
    /// Comparison function to use.
    Comparison fun = Comparison.always;
    /// Specify whether to write to the depth buffer or not.
    bool write = false;

    enum lessEqualWrite = DepthTest(Comparison.lessEqual, true);
    enum lessEqualTest = DepthTest(Comparison.lessEqual, false);
}

enum Equation {
    /// Adds source and destination.
    /// Source and destination are multiplied by blending parameters before addition.
    add,
    /// Subtracts destination from source.
    /// Source and destination are multiplied by blending parameters before subtraction.
    sub,
    /// Subtracts source from destination.
    /// Source and destination are multiplied by blending parameters before subtraction.
    revSub,
    /// Component-wise minimum value of source and destination.
    /// Blending parameters are ignored.
    min,
    /// Component-wise maximum value of source and destination.
    /// Blending parameters are ignored.
    max,
}

enum BlendValue {
    sourceColor,
    sourceAlpha,
    destColor,
    destAlpha,
    constColor,
    constAlpha,
}


alias Factor = SafeUnion!(
    "zero",
    "one",
    "sourceAlphaSaturated",
    "zeroPlus", BlendValue,
    "oneMinus", BlendValue,
);

struct BlendChannel {
    Equation equation   = Equation.add;
    Factor source       = Factor.makeOne();
    Factor destination  = Factor.makeOne();
}

struct Blend {
    BlendChannel color;
    BlendChannel alpha;

    this(BlendChannel color, BlendChannel alpha) {
        this.color = color;
        this.alpha = alpha;
    }

    this(Equation eq, Factor src, Factor dst) {
        auto chan = BlendChannel(eq, src, dst);
        this(chan, chan);
    }

    //string toString() const pure @safe {
    //    return format("Blend { color: %s, alpha: %s}", color, alpha);
    //}
}


enum ColorFlags: ubyte {
    none        = 0x00,
    red         = 0x01,
    green       = 0x02,
    blue        = 0x04,
    alpha       = 0x08,
    all         = 0x0f,
}
alias ColorMask = BitFlags!(ColorFlags, Yes.unsafe);


/// The state of an active color render target
struct Color {
    /// Color mask to use.
    ColorMask mask      = cast(ColorMask)ColorFlags.all;
    /// Optional blending.
    Option!Blend blend  = none!Blend;
}

/// The complete set of the rasterizer reference values.
/// Switching these doesn't roll the hardware context.
struct RefValues {
    /// Stencil front and back values.
    ubyte[2] stencil    = [0, 0];
    /// Constant blend color.
    float[4] blend      = [0, 0, 0, 0];
}
