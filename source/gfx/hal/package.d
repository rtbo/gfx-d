module gfx.hal;

import gfx.core.rc;
import gfx.hal.device;

/// A backend instance
interface Instance : AtomicRefCounted {
    PhysicalDevice[] devices();
}
