module gfx.core.state;

import gfx.core.typecons : SafeUnion, Option, none;

import std.typecons : BitFlags, Yes;


enum FrontFace {
    ClockWise, CounterClockWise,
}

enum CullFace {
    None, Front, Back,
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

    static Rasterizer newFill() {
        return Rasterizer(
            FrontFace.CounterClockWise,
            CullFace.None,
            RasterMethod.makeFill(),
            none!Offset,
            false
        );
    }

    Rasterizer withCullBack() const {
        Rasterizer res = this;
        res.cullFace = CullFace.Back;
        return res;
    }

    Rasterizer withOffset(OffsetSlope slope, OffsetUnits units) const {
        Rasterizer res = this;
        res.offset = Offset(slope, units);
        return res;
    }
}



/// A pixel-wise comparison function.
enum Comparison {
    /// `false`
    Never,
    /// `x < y`
    Less,
    /// `x <= y`
    LessEqual,
    /// `x == y`
    Equal,
    /// `x >= y`
    GreaterEqual,
    /// `x > y`
    Greater,
    /// `x != y`
    NotEqual,
    /// `true`
    Always,
}

/// Stencil mask operation.
enum StencilOp {
    /// Keep the current value in the stencil buffer (no change).
    Keep,
    /// Set the value in the stencil buffer to zero.
    Zero,
    /// Set the stencil buffer value to `value` from `StencilSide`
    Replace,
    /// Increment the stencil buffer value, clamping to its maximum value.
    IncrementClamp,
    /// Increment the stencil buffer value, wrapping around to 0 on overflow.
    IncrementWrap,
    /// Decrement the stencil buffer value, clamping to its minimum value.
    DecrementClamp,
    /// Decrement the stencil buffer value, wrapping around to the maximum value on overflow.
    DecrementWrap,
    /// Bitwise invert the current value in the stencil buffer.
    Invert,
}

/// Complete stencil state for a given side of a face.
struct StencilSide {
    /// Comparison function to use to determine if the stencil test passes.
    Comparison fun;
    /// A mask that is ANDd with both the stencil buffer value and the reference value when they
    /// are read before doing the stencil test.
    ubyte maskRead;
    /// A mask that is ANDd with the stencil value before writing to the stencil buffer.
    ubyte maskWrite;
    /// What operation to do if the stencil test fails.
    StencilOp opFail;
    /// What operation to do if the stenil test passes but the depth test fails.
    StencilOp opDepthFail;
    /// What operation to do if both the depth and stencil test pass.
    StencilOp opPass;


    static StencilSide makeDefault() {
        return StencilSide(
            Comparison.Always,
            ubyte.max,
            ubyte.max,
            StencilOp.Keep,
            StencilOp.Keep,
            StencilOp.Keep,
        );
    }
}


/// Complete stencil state, specifying how to handle the front and back side of a face.
struct Stencil {
    StencilSide front;
    StencilSide back;

    static Stencil makeDefault() {
        auto def = StencilSide.makeDefault();
        return Stencil(
            def, def
        );
    }

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
struct Depth {
    /// Comparison function to use.
    Comparison fun;
    /// Specify whether to write to the depth buffer or not.
    bool write;

    static Depth makeDefault() {
        return Depth(Comparison.Always, false);
    }
}

enum Equation {
    /// Adds source and destination.
    /// Source and destination are multiplied by blending parameters before addition.
    Add,
    /// Subtracts destination from source.
    /// Source and destination are multiplied by blending parameters before subtraction.
    Sub,
    /// Subtracts source from destination.
    /// Source and destination are multiplied by blending parameters before subtraction.
    RevSub,
    /// Component-wise minimum value of source and destination.
    /// Blending parameters are ignored.
    Min,
    /// Component-wise maximum value of source and destination.
    /// Blending parameters are ignored.
    Max,
}

enum BlendValue {
    SourceColor,
    SourceAlpha,
    DestColor,
    DestAlpha,
    ConstColor,
    ConstAlpha,
}


alias Factor = SafeUnion!(
    "Zero",
    "One",
    "SourceAlphaSaturated",
    "ZeroPlus", BlendValue,
    "OneMinus", BlendValue,
);

struct BlendChannel {
    Equation equation   = Equation.Add;
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
    None        = 0x00,
    Red         = 0x01,
    Green       = 0x02,
    Blue        = 0x04,
    Alpha       = 0x08,
    All         = 0x0f,
}
alias ColorMask = BitFlags!(ColorFlags, Yes.unsafe);


/// The state of an active color render target
struct Color {
    /// Color mask to use.
    ColorMask mask;
    /// Optional blending.
    Option!Blend blend;

    static Color makeDefault() {
        return Color(cast(ColorMask)ColorFlags.All, none!Blend);
    }
}

/// The complete set of the rasterizer reference values.
/// Switching these doesn't roll the hardware context.
struct RefValues {
    /// Stencil front and back values.
    ubyte[2] stencil;
    /// Constant blend color.
    float[4] blend;

    RefValues makeDefault() {
        return RefValues([0, 0], [0, 0, 0, 0]);
    }
}