module gfx.core.typecons;

/// A transition from one state to another
struct Trans(T) {
    /// state before
    T from;
    /// state after
    T to;
}

/// Transition build helper
auto trans(T)(T from, T to) {
    return Trans!T(from, to);
}
