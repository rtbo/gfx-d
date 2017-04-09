module gfx.pipeline.draw;

import gfx.foundation.rc : RefCounted;
import gfx.foundation.typecons : SafeUnion, Option;
import gfx.pipeline.buffer : RawBuffer, IndexType;
import gfx.pipeline.texture : RawTexture, ImageSliceInfo;
import gfx.pipeline.pso :   RawPipelineState, VertexBufferSet, ConstantBlockSet,
                        ResourceViewSet, SamplerSet, PixelTargetSet;
import gfx.pipeline.view : RawShaderResourceView, RawRenderTargetView, RawDepthStencilView;

import std.traits : isStaticArray;

/// A universal clear color supporting integet formats
/// as well as the standard floating-point.
alias ClearColor = SafeUnion!(
    "Float", float[4],
    "Int",   int[4],
    "Uint",  uint[4],
);

template isClearColorCompType(T) {
    enum isClearColorCompType = is(T == float) || is(T == int) || is(T == uint);
}

ClearColor clearColor(T)(in T[4] col) if (isClearColorCompType!T) {
    static if (is(T == float)) {
        return ClearColor.makeFloat(col);
    }
    else static if (is(T == int)) {
        return ClearColor.makeInt(col);
    }
    else static if (is(T == uint)) {
        return ClearColor.makeUint(col);
    }
}

ClearColor clearColor(T)(in T[3] col) if (isClearColorCompType!T) {
    return clearColor([col[0], col[1], col[2], T(0)]);
}

ClearColor clearColor(T)(in T[2] col) if (isClearColorCompType!T) {
    return clearColor([col[0], col[1], T(0), T(0)]);
}

ClearColor clearColor(T)(in T col) if (isClearColorCompType!T) {
    return clearColor([col, T(0), T(0), T(0)]);
}



struct Instance {
    uint count;
    uint base;
}

/// An interface of the abstract command buffer. It collects commands in an
/// efficient API-specific manner, to be ready for execution on the device.
interface CommandBuffer : RefCounted {
    /+ /// Clone as an empty buffer
    CommandBuffer cloneEmpty() const;
    /// Reset the command buffer contents, retain the allocated storage
    void reset();
    +/
    /// Bind a pipeline state object
    void bindPipelineState(RawPipelineState);
    /// Bind a complete set of vertex buffers
    void bindVertexBuffers(VertexBufferSet);
    /// Bind a complete set of constant buffers
    void bindConstantBuffers(ConstantBlockSet);
    /+
    /// Bind a global constant
    void bindGlobalConstant(Location, UniformValue);
    +/
    /// Bind a complete set of shader resource views
    void bindResourceViews(ResourceViewSet);
    /+
    /// Bind a complete set of unordered access views
    void bindUnorderedViews(UnorderedViewParam[]);
    +/
    /// Bind a complete set of samplers
    void bindSamplers(SamplerSet);
    /// Bind a complete set of pixel targets, including multiple
    /// colors views and an optional depth/stencil view.
    void bindPixelTargets(PixelTargetSet);
    /// Bind an index buffer
    void bindIndex(RawBuffer, IndexType);
    /// Set viewport rect
    void setViewport(ushort x, ushort y, ushort w, ushort h);
    /// Set scissor rectangle
    void setScissor(ushort x, ushort y, ushort w, ushort h);
    /// Set reference values for the blending and stencil front/back
    void setRefValues(float[4] blend, ubyte[2] stencil);
    /// Update a vertex/index/uniform buffer
    void updateBuffer(RawBuffer, const(ubyte)[] data, size_t offset);
    /// Update a texture
    void updateTexture(RawTexture tex, ImageSliceInfo info, const(ubyte)[] data);
    void generateMipmap(RawShaderResourceView view);
    /// Clear color target
    void clearColor(RawRenderTargetView, ClearColor);
    /// Clear depth-stencil targets
    void clearDepthStencil(RawDepthStencilView, Option!float, Option!ubyte);
    /// Draw a primitive
    void draw(uint start, uint count, Option!Instance);
    // Draw a primitive with index buffer
    void drawIndexed(uint start, uint count, uint base, Option!Instance);
}

