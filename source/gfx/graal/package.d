module gfx.graal;

import gfx.core.rc;
import gfx.graal.device;

enum Backend {
    vulkan,
    gl3,
}

enum CoordSystem {
    rightHanded,
    leftHanded,
}

struct ApiProps {
    string name;
    CoordSystem coordSystem;
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
interface Instance : IAtomicRefCounted {
    @property Backend backend();
    @property ApiProps apiProps();
    PhysicalDevice[] devices();

    /// Sets the debug callback for the instance and associated devices.
    /// Must be set before creating devices.
    /// Depending on backend, it might only be effective if the instance was
    /// created with the right extensions.
    void setDebugCallback(DebugCallback callback);
}
