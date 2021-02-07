module gfx;

import gfx.core.log : LogTag;

enum gfxLogMask = 0xF000_0000;
package immutable gfxLog = LogTag("GFX", gfxLogMask);

enum uint gfxVersionMaj = 0;
enum uint gfxVersionMin = 1;
enum uint gfxVersionMic = 2;
