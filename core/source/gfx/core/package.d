module gfx.core;

import gfx.core.log : LogTag;

enum gfxCoreLogMask = 0x8000_0000;
package(gfx) immutable gfxCoreLog = LogTag("GFX-CORE", gfxCoreLogMask);
