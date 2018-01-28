module gfx.graal;

import gfx.core.rc;
import gfx.graal.device;

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
    @property ApiProps apiProps();
    PhysicalDevice[] devices();
}
