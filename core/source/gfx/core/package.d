module gfx.core;

public import gfx.core.log;
public import gfx.core.rc;
public import gfx.core.typecons;
public import gfx.core.util;

enum gfxCoreLogMask = 0x8000_0000;
package(gfx) immutable gfxCoreLog = LogTag("GFX-CORE", gfxCoreLogMask);
