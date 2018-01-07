module gfx.graal;

import gfx.core.rc;
import gfx.graal.device;

/// A backend instance
interface Instance : AtomicRefCounted {
    PhysicalDevice[] devices();
}
