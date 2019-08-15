module gfx.graal.types;

import std.traits : isIntegral;

/// An integer interval from a start until an end.
/// end is one past last, such as end-start = length
struct Interval(T)
if (isIntegral!T)
{
    /// start of interval
    T start;
    /// one past last
    T end;

    /// end-start
    @property T length() const {
        return end - start;
    }
}

/// Interval build helper
auto interval(T)(T start, T end)
if (isIntegral!T)
{
    import std.traits : Unqual;
    return Interval!(Unqual!T)(start, end);
}

/// A transition from one state to another
struct Trans(T) {
    /// state before
    T from;
    /// state after
    T to;
}

/// Transition build helper
auto trans(T)(T from, T to)
if (!is(T : Object))
{
    import std.traits : Unqual;
    return Trans!(Unqual!T)(from, to);
}

struct Offset2D {
    uint x;
    uint y;
}

struct Extent2D {
    uint width;
    uint height;
}

struct Rect {
    uint x;
    uint y;
    uint width;
    uint height;
}

struct Viewport {
    float x;
    float y;
    float width;
    float height;
    float minDepth  = 0f;
    float maxDepth  = 1f;
}
