module gfx.graal;

public import gfx.graal.buffer;
public import gfx.graal.cmd;
public import gfx.graal.device;
public import gfx.graal.error;
public import gfx.graal.format;
public import gfx.graal.image;
public import gfx.graal.memory;
public import gfx.graal.pipeline;
public import gfx.graal.presentation;
public import gfx.graal.queue;
public import gfx.graal.renderpass;
public import gfx.graal.sync;
public import gfx.graal.types;

import gfx.core.rc : IAtomicRefCounted;
import gfx.math : NDC;

/// Backend identifier
enum Backend
{
    /// Vulkan backend
    vulkan,
    /// Open GL 3 backend
    gl3,
}

/// Property of the API used to implement a Graal instance.
struct ApiProps
{
    /// name of the API
    string name;
    /// Normalized Device Coordinates of the backend
    NDC ndc;
}

/// Severity of debug message.
/// These are flags as performance can be signaled with other severity
enum Severity {
    info            = 0x01,
    warning         = 0x02,
    performance     = 0x04,
    error           = 0x08,
    debug_          = 0x10,
}

/// Debug callback type
alias DebugCallback = void delegate(Severity severity, string message);

/// A backend instance
interface Instance : IAtomicRefCounted
{
    /// Backend identifier
    @property Backend backend();

    /// Properties of the backend API
    @property ApiProps apiProps();

    /// The devices that are installed on the system.
    PhysicalDevice[] devices();

    /// Sets the debug callback for the instance and associated devices.
    /// Must be set before creating devices.
    /// Depending on backend, it might only be effective if the instance was
    /// created with the right extensions.
    void setDebugCallback(DebugCallback callback);
}
