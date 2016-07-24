module gfx.core.command;

import gfx.core : Rect;
import gfx.core.rc : RefCounted;
import gfx.core.typecons : SafeUnion, Option;
import gfx.core.pso : RawPipelineState, VertexBufferSet, PixelTargetSet;
import gfx.core.view : RawRenderTargetView;

import std.traits : isStaticArray;

/// A universal clear color supporting integet formats
/// as well as the standard floating-point.
alias ClearColor = SafeUnion!(
    "Float", float[4],
    "Int",   int[4],
    "Uint",  uint[4],
);

ClearColor clearColor(T)(in T[4] col) {
    static if (is(T == float)) {
        return ClearColor.makeFloat(col);
    }
    else static if (is(T == int)) {
        return ClearColor.makeInt(col);
    }
    else static if (is(T == uint)) {
        return ClearColor.makeUint(col);
    }
    else {
        static assert(false, T.stringof ~ " is not a valid clear color type");
    }
}


struct Instance {
    uint instanceCount;
    uint vertexCount;
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
    /+
    /// Bind a complete set of constant buffers
    void bindConstantBuffers(ConstantBufferParam[]);
    /// Bind a global constant
    void bindGlobalConstant(Location, UniformValue);
    /// Bind a complete set of shader resource views
    void bindResourceViews(ResourceViewParam[]);
    /// Bind a complete set of unordered access views
    void bindUnorderedViews(UnorderedViewParam[]);
    /// Bind a complete set of samplers
    void bindSamplers(SamplerParam[]);
    +/
    /// Bind a complete set of pixel targets, including multiple
    /// colors views and an optional depth/stencil view.
    void bindPixelTargets(PixelTargetSet);
    /+
    /// Bind an index buffer
    void bindIndex(RawBuffer, IndexType);
    +/
    void setViewport(Rect r);
    /+
    /// Set scissor rectangle
    void setScissor(target.Rect);
    /// Set reference values for the blending and stencil front/back
    void setRefValues(s.RefValues);
    /// Update a vertex/index/uniform buffer
    void updateBuffer(RawBuffer, ubyte[] data, size_t offset);
    /// Update a texture
    void updateTexture(RawTexture, tex.Kind, Option!(tex.CubeFace), ubyte[] data, tex.RawImageInfo);
    void generateMipmap(RawShaderResourceView);
    +/
    /// Clear color target
    void clearColor(RawRenderTargetView, ClearColor);
    /+
    void clearDepthStencil(RawDepthStencilView, Option!(target.Depth), Option!(target.Stencil));
    +/
    /// Draw a primitive
    void callDraw(uint start, uint count, Option!Instance);
    /+/// Draw a primitive with index buffer
    void callDrawIndexed(uint start, uint count, uint base, Option!Instance);
    +/
}

