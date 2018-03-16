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

/// A backend instance
interface Instance : AtomicRefCounted {
    @property Backend backend();
    @property ApiProps apiProps();
    PhysicalDevice[] devices();
}
