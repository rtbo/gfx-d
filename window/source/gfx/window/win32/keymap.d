module gfx.window.win32.keymap;

version (Windows):

import gfx.window.keys;
import core.sys.windows.windows;


static KeySym getKeysym(in WPARAM vkey)
{
    assert(cast(ubyte)vkey == vkey);
    const sym = keysymTable[vkey];
    return (sym == KeySym.none) ? cast(KeySym)vkey : sym;
}

static KeyCode getKeycode(in ubyte scancode)
{
    return keycodeTable[scancode];
}


private
{

    immutable KeySym[256] keysymTable;
    immutable KeyCode[256] keycodeTable;

    shared static this()
    {

        keycodeTable = [
            // 0x00     0
            KeyCode.unknown,
            KeyCode.escape,
            KeyCode.d1,
            KeyCode.d2,
            KeyCode.d3,
            KeyCode.d4,
            KeyCode.d5,
            KeyCode.d6,
            KeyCode.d7,
            KeyCode.d8,
            KeyCode.d9,
            KeyCode.d0,
            KeyCode.minus,
            KeyCode.equals,
            KeyCode.backspace,
            KeyCode.tab,
            // 0x10     16
            KeyCode.q,
            KeyCode.w,
            KeyCode.e,
            KeyCode.r,
            KeyCode.t,
            KeyCode.y,
            KeyCode.u,
            KeyCode.i,
            KeyCode.o,
            KeyCode.p,
            KeyCode.leftBracket,
            KeyCode.rightBracket,
            KeyCode.enter,
            KeyCode.leftCtrl,
            KeyCode.a,
            KeyCode.s,
            // 0x20     32
            KeyCode.d,
            KeyCode.f,
            KeyCode.g,
            KeyCode.h,
            KeyCode.j,
            KeyCode.k,
            KeyCode.l,
            KeyCode.semicolon,
            KeyCode.quote,
            KeyCode.grave,
            KeyCode.leftShift,
            KeyCode.uK_Hash,
            KeyCode.z,
            KeyCode.x,
            KeyCode.c,
            KeyCode.v,
            // 0x30     48
            KeyCode.b,
            KeyCode.n,
            KeyCode.m,
            KeyCode.comma,
            KeyCode.period,
            KeyCode.slash,
            KeyCode.rightShift,
            KeyCode.printScreen,
            KeyCode.leftAlt,
            KeyCode.space,
            KeyCode.capsLock,
            KeyCode.f1,
            KeyCode.f2,
            KeyCode.f3,
            KeyCode.f4,
            KeyCode.f5,
            // 0x40     64
            KeyCode.f6,
            KeyCode.f7,
            KeyCode.f8,
            KeyCode.f9,
            KeyCode.f10,
            KeyCode.kp_NumLock,
            KeyCode.scrollLock,
            KeyCode.home,
            KeyCode.up,
            KeyCode.pageUp,
            KeyCode.kp_Subtract,
            KeyCode.left,
            KeyCode.kp_5,
            KeyCode.right,
            KeyCode.kp_Add,
            KeyCode.end,
            // 0x50     80
            KeyCode.down,
            KeyCode.pageDown,
            KeyCode.insert,
            KeyCode.delete_,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.kp_Add,
            KeyCode.f11,
            KeyCode.f12,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            // 0x60     96
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown, // line feed
            KeyCode.unknown,
            KeyCode.unknown,
            // 0x70     112
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            // 0x80     128
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            // 0x90     144
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            // 0xA0     160
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            // 0xB0     176
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            // 0xC0     192
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            // 0xD0     208
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            // 0xE0     224
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            // 0xF0     240
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown,
            KeyCode.unknown
        ];

        // a little help from Qt for that one
        keysymTable = [
                                            // Dec |  Hex | Windows Virtual key
            KeySym.unknown,                //   0   0x00
            KeySym.unknown,                //   1   0x01   VK_LBUTTON          | Left mouse button
            KeySym.unknown,                //   2   0x02   VK_RBUTTON          | Right mouse button
            KeySym.cancel,                 //   3   0x03   VK_CANCEL           | Control-Break processing
            KeySym.unknown,                //   4   0x04   VK_MBUTTON          | Middle mouse button
            KeySym.unknown,                //   5   0x05   VK_XBUTTON1         | X1 mouse button
            KeySym.unknown,                //   6   0x06   VK_XBUTTON2         | X2 mouse button
            KeySym.unknown,                //   7   0x07   -- unassigned --
            KeySym.backspace,              //   8   0x08   VK_BACK             | BackSpace key
            KeySym.tab,                    //   9   0x09   VK_TAB              | Tab key
            KeySym.unknown,                //  10   0x0A   -- reserved --
            KeySym.unknown,                //  11   0x0B   -- reserved --
            KeySym.clear,                  //  12   0x0C   VK_CLEAR            | Clear key
            KeySym.return_,                //  13   0x0D   VK_RETURN           | Enter key
            KeySym.unknown,                //  14   0x0E   -- unassigned --
            KeySym.unknown,                //  15   0x0F   -- unassigned --
            KeySym.shift,                  //  16   0x10   VK_SHIFT            | Shift key
            KeySym.ctrl,                   //  17   0x11   VK_CONTROL          | Ctrl key
            KeySym.alt,                    //  18   0x12   VK_MENU             | Alt key
            KeySym.pause,                  //  19   0x13   VK_PAUSE            | Pause key
            KeySym.capsLock,               //  20   0x14   VK_CAPITAL          | Caps-Lock
            KeySym.unknown,                //  21   0x15   VK_KANA / VK_HANGUL | IME Kana or Hangul mode
            KeySym.unknown,                //  22   0x16   -- unassigned --
            KeySym.junja,                  //  23   0x17   VK_JUNJA            | IME Junja mode
            KeySym.final_,                 //  24   0x18   VK_FINAL            | IME final mode
            KeySym.hanja,                  //  25   0x19   VK_HANJA / VK_KANJI | IME Hanja or Kanji mode
            KeySym.unknown,                //  26   0x1A   -- unassigned --
            KeySym.escape,                 //  27   0x1B   VK_ESCAPE           | Esc key
            KeySym.unknown,                //  28   0x1C   VK_CONVERT          | IME convert
            KeySym.unknown,                //  29   0x1D   VK_NONCONVERT       | IME non-convert
            KeySym.unknown,                //  30   0x1E   VK_ACCEPT           | IME accept
            KeySym.modeSwitch,             //  31   0x1F   VK_MODECHANGE       | IME mode change request
            KeySym.space,                  //  32   0x20   VK_SPACE            | Spacebar
            KeySym.pageUp,                 //  33   0x21   VK_PRIOR            | Page Up key
            KeySym.pageDown,               //  34   0x22   VK_NEXT             | Page Down key
            KeySym.end,                    //  35   0x23   VK_END              | End key
            KeySym.home,                   //  36   0x24   VK_HOME             | Home key
            KeySym.left,                   //  37   0x25   VK_LEFT             | Left arrow key
            KeySym.up,                     //  38   0x26   VK_UP               | Up arrow key
            KeySym.right,                  //  39   0x27   VK_RIGHT            | Right arrow key
            KeySym.down,                   //  40   0x28   VK_DOWN             | Down arrow key
            KeySym.select,                 //  41   0x29   VK_SELECT           | Select key
            KeySym.printer,                //  42   0x2A   VK_PRINT            | Print key
            KeySym.execute,                //  43   0x2B   VK_EXECUTE          | Execute key
            KeySym.print,                  //  44   0x2C   VK_SNAPSHOT         | Print Screen key
            KeySym.insert,                 //  45   0x2D   VK_INSERT           | Ins key
            KeySym.delete_,                //  46   0x2E   VK_DELETE           | Del key
            KeySym.help,                   //  47   0x2F   VK_HELP             | Help key
            KeySym.none,                   //  48   0x30   (VK_0)              | 0 key
            KeySym.none,                   //  49   0x31   (VK_1)              | 1 key
            KeySym.none,                   //  50   0x32   (VK_2)              | 2 key
            KeySym.none,                   //  51   0x33   (VK_3)              | 3 key
            KeySym.none,                   //  52   0x34   (VK_4)              | 4 key
            KeySym.none,                   //  53   0x35   (VK_5)              | 5 key
            KeySym.none,                   //  54   0x36   (VK_6)              | 6 key
            KeySym.none,                   //  55   0x37   (VK_7)              | 7 key
            KeySym.none,                   //  56   0x38   (VK_8)              | 8 key
            KeySym.none,                   //  57   0x39   (VK_9)              | 9 key
            KeySym.unknown,                //  58   0x3A   -- unassigned --
            KeySym.unknown,                //  59   0x3B   -- unassigned --
            KeySym.unknown,                //  60   0x3C   -- unassigned --
            KeySym.unknown,                //  61   0x3D   -- unassigned --
            KeySym.unknown,                //  62   0x3E   -- unassigned --
            KeySym.unknown,                //  63   0x3F   -- unassigned --
            KeySym.unknown,                //  64   0x40   -- unassigned --
            KeySym.none,                   //  65   0x41   (VK_A)              | A key
            KeySym.none,                   //  66   0x42   (VK_B)              | B key
            KeySym.none,                   //  67   0x43   (VK_C)              | C key
            KeySym.none,                   //  68   0x44   (VK_D)              | D key
            KeySym.none,                   //  69   0x45   (VK_E)              | E key
            KeySym.none,                   //  70   0x46   (VK_F)              | F key
            KeySym.none,                   //  71   0x47   (VK_G)              | G key
            KeySym.none,                   //  72   0x48   (VK_H)              | H key
            KeySym.none,                   //  73   0x49   (VK_I)              | I key
            KeySym.none,                   //  74   0x4A   (VK_J)              | J key
            KeySym.none,                   //  75   0x4B   (VK_K)              | K key
            KeySym.none,                   //  76   0x4C   (VK_L)              | L key
            KeySym.none,                   //  77   0x4D   (VK_M)              | M key
            KeySym.none,                   //  78   0x4E   (VK_N)              | N key
            KeySym.none,                   //  79   0x4F   (VK_O)              | O key
            KeySym.none,                   //  80   0x50   (VK_P)              | P key
            KeySym.none,                   //  81   0x51   (VK_Q)              | Q key
            KeySym.none,                   //  82   0x52   (VK_R)              | R key
            KeySym.none,                   //  83   0x53   (VK_S)              | S key
            KeySym.none,                   //  84   0x54   (VK_T)              | T key
            KeySym.none,                   //  85   0x55   (VK_U)              | U key
            KeySym.none,                   //  86   0x56   (VK_V)              | V key
            KeySym.none,                   //  87   0x57   (VK_W)              | W key
            KeySym.none,                   //  88   0x58   (VK_X)              | X key
            KeySym.none,                   //  89   0x59   (VK_Y)              | Y key
            KeySym.none,                   //  90   0x5A   (VK_Z)              | Z key
            KeySym.leftSuper,              //  91   0x5B   VK_LWIN             | Left Windows  - MS Natural kbd
            KeySym.rightSuper,             //  92   0x5C   VK_RWIN             | Right Windows - MS Natural kbd
            KeySym.menu,                   //  93   0x5D   VK_APPS             | Application key-MS Natural kbd
            KeySym.unknown,                //  94   0x5E   -- reserved --
            KeySym.sleep,                  //  95   0x5F   VK_SLEEP
            KeySym.kp_0,                   //  96   0x60   VK_NUMPAD0          | Numeric keypad 0 key
            KeySym.kp_1,                   //  97   0x61   VK_NUMPAD1          | Numeric keypad 1 key
            KeySym.kp_2,                   //  98   0x62   VK_NUMPAD2          | Numeric keypad 2 key
            KeySym.kp_3,                   //  99   0x63   VK_NUMPAD3          | Numeric keypad 3 key
            KeySym.kp_4,                   // 100   0x64   VK_NUMPAD4          | Numeric keypad 4 key
            KeySym.kp_5,                   // 101   0x65   VK_NUMPAD5          | Numeric keypad 5 key
            KeySym.kp_6,                   // 102   0x66   VK_NUMPAD6          | Numeric keypad 6 key
            KeySym.kp_7,                   // 103   0x67   VK_NUMPAD7          | Numeric keypad 7 key
            KeySym.kp_8,                   // 104   0x68   VK_NUMPAD8          | Numeric keypad 8 key
            KeySym.kp_9,                   // 105   0x69   VK_NUMPAD9          | Numeric keypad 9 key
            KeySym.kp_Multiply,            // 106   0x6A   VK_MULTIPLY         | Multiply key
            KeySym.kp_Add,                 // 107   0x6B   VK_ADD              | Add key
            KeySym.kp_Separator,           // 108   0x6C   VK_SEPARATOR        | Separator key
            KeySym.kp_Subtract,            // 109   0x6D   VK_SUBTRACT         | Subtract key
            KeySym.kp_Decimal,             // 110   0x6E   VK_DECIMAL          | Decimal key
            KeySym.kp_Divide,              // 111   0x6F   VK_DIVIDE           | Divide key
            KeySym.f1,                     // 112   0x70   VK_F1               | F1 key
            KeySym.f2,                     // 113   0x71   VK_F2               | F2 key
            KeySym.f3,                     // 114   0x72   VK_F3               | F3 key
            KeySym.f4,                     // 115   0x73   VK_F4               | F4 key
            KeySym.f5,                     // 116   0x74   VK_F5               | F5 key
            KeySym.f6,                     // 117   0x75   VK_F6               | F6 key
            KeySym.f7,                     // 118   0x76   VK_F7               | F7 key
            KeySym.f8,                     // 119   0x77   VK_F8               | F8 key
            KeySym.f9,                     // 120   0x78   VK_F9               | F9 key
            KeySym.f10,                    // 121   0x79   VK_F10              | F10 key
            KeySym.f11,                    // 122   0x7A   VK_F11              | F11 key
            KeySym.f12,                    // 123   0x7B   VK_F12              | F12 key
            KeySym.f13,                    // 124   0x7C   VK_F13              | F13 key
            KeySym.f14,                    // 125   0x7D   VK_F14              | F14 key
            KeySym.f15,                    // 126   0x7E   VK_F15              | F15 key
            KeySym.f16,                    // 127   0x7F   VK_F16              | F16 key
            KeySym.f17,                    // 128   0x80   VK_F17              | F17 key
            KeySym.f18,                    // 129   0x81   VK_F18              | F18 key
            KeySym.f19,                    // 130   0x82   VK_F19              | F19 key
            KeySym.f20,                    // 131   0x83   VK_F20              | F20 key
            KeySym.f21,                    // 132   0x84   VK_F21              | F21 key
            KeySym.f22,                    // 133   0x85   VK_F22              | F22 key
            KeySym.f23,                    // 134   0x86   VK_F23              | F23 key
            KeySym.f24,                    // 135   0x87   VK_F24              | F24 key
            KeySym.unknown,                // 136   0x88   -- unassigned --
            KeySym.unknown,                // 137   0x89   -- unassigned --
            KeySym.unknown,                // 138   0x8A   -- unassigned --
            KeySym.unknown,                // 139   0x8B   -- unassigned --
            KeySym.unknown,                // 140   0x8C   -- unassigned --
            KeySym.unknown,                // 141   0x8D   -- unassigned --
            KeySym.unknown,                // 142   0x8E   -- unassigned --
            KeySym.unknown,                // 143   0x8F   -- unassigned --
            KeySym.numLock,                // 144   0x90   VK_NUMLOCK          | Num Lock key
            KeySym.scrollLock,             // 145   0x91   VK_SCROLL           | Scroll Lock key
                                            // Fujitsu/OASYS kbd --------------------
            KeySym.jisho,                  // 146   0x92   VK_OEM_FJ_JISHO     | 'Dictionary' key /
                                            //              VK_OEM_NEC_EQUAL  = key on numpad on NEC PC-9800 kbd
            KeySym.masshou,                // 147   0x93   VK_OEM_FJ_MASSHOU   | 'Unregister word' key
            KeySym.touroku,                // 148   0x94   VK_OEM_FJ_TOUROKU   | 'Register word' key
            KeySym.oyayubiLeft,            // 149   0x95   VK_OEM_FJ_LOYA      | 'Left OYAYUBI' key
            KeySym.oyayubiRight,           // 150   0x96   VK_OEM_FJ_ROYA      | 'Right OYAYUBI' key
            KeySym.unknown,                // 151   0x97   -- unassigned --
            KeySym.unknown,                // 152   0x98   -- unassigned --
            KeySym.unknown,                // 153   0x99   -- unassigned --
            KeySym.unknown,                // 154   0x9A   -- unassigned --
            KeySym.unknown,                // 155   0x9B   -- unassigned --
            KeySym.unknown,                // 156   0x9C   -- unassigned --
            KeySym.unknown,                // 157   0x9D   -- unassigned --
            KeySym.unknown,                // 158   0x9E   -- unassigned --
            KeySym.unknown,                // 159   0x9F   -- unassigned --
            KeySym.leftShift,              // 160   0xA0   VK_LSHIFT           | Left Shift key
            KeySym.rightShift,             // 161   0xA1   VK_RSHIFT           | Right Shift key
            KeySym.leftCtrl,               // 162   0xA2   VK_LCONTROL         | Left Ctrl key
            KeySym.rightCtrl,              // 163   0xA3   VK_RCONTROL         | Right Ctrl key
            KeySym.leftAlt,                // 164   0xA4   VK_LMENU            | Left Menu key
            KeySym.rightAlt,               // 165   0xA5   VK_RMENU            | Right Menu key
            KeySym.browserBack,            // 166   0xA6   VK_BROWSER_BACK     | Browser Back key
            KeySym.browserForward,         // 167   0xA7   VK_BROWSER_FORWARD  | Browser Forward key
            KeySym.browserRefresh,         // 168   0xA8   VK_BROWSER_REFRESH  | Browser Refresh key
            KeySym.browserStop,            // 169   0xA9   VK_BROWSER_STOP     | Browser Stop key
            KeySym.browserSearch,          // 170   0xAA   VK_BROWSER_SEARCH   | Browser Search key
            KeySym.browserFavorites,       // 171   0xAB   VK_BROWSER_FAVORITES| Browser Favorites key
            KeySym.browserHome,            // 172   0xAC   VK_BROWSER_HOME     | Browser Start and Home key
            KeySym.volumeMute,             // 173   0xAD   VK_VOLUME_MUTE      | Volume Mute key
            KeySym.volumeDown,             // 174   0xAE   VK_VOLUME_DOWN      | Volume Down key
            KeySym.volumeUp,               // 175   0xAF   VK_VOLUME_UP        | Volume Up key
            KeySym.mediaNext,              // 176   0xB0   VK_MEDIA_NEXT_TRACK | Next Track key
            KeySym.mediaPrevious,          // 177   0xB1   VK_MEDIA_PREV_TRACK | Previous Track key
            KeySym.mediaStop,              // 178   0xB2   VK_MEDIA_STOP       | Stop Media key
            KeySym.mediaPlay,              // 179   0xB3   VK_MEDIA_PLAY_PAUSE | Play/Pause Media key
            KeySym.launchMail,             // 180   0xB4   VK_LAUNCH_MAIL      | Start Mail key
            KeySym.launchMedia,            // 181   0xB5   VK_LAUNCH_MEDIA_SELECT Select Media key
            KeySym.launch0,                // 182   0xB6   VK_LAUNCH_APP1      | Start Application 1 key
            KeySym.launch1,                // 183   0xB7   VK_LAUNCH_APP2      | Start Application 2 key
            KeySym.unknown,                // 184   0xB8   -- reserved --
            KeySym.unknown,                // 185   0xB9   -- reserved --
            KeySym.semicolon,              // 186   0xBA   VK_OEM_1            | ';:' for US
            KeySym.plus,                   // 187   0xBB   VK_OEM_PLUS         | '+' any country
            KeySym.comma,                  // 188   0xBC   VK_OEM_COMMA        | ',' any country
            KeySym.minus,                  // 189   0xBD   VK_OEM_MINUS        | '-' any country
            KeySym.period,                 // 190   0xBE   VK_OEM_PERIOD       | '.' any country
            KeySym.slash,                  // 191   0xBF   VK_OEM_2            | '/?' for US
            KeySym.asciiTilde,             // 192   0xC0   VK_OEM_3            | '`~' for US
            KeySym.unknown,                // 193   0xC1   -- reserved --
            KeySym.unknown,                // 194   0xC2   -- reserved --
            KeySym.unknown,                // 195   0xC3   -- reserved --
            KeySym.unknown,                // 196   0xC4   -- reserved --
            KeySym.unknown,                // 197   0xC5   -- reserved --
            KeySym.unknown,                // 198   0xC6   -- reserved --
            KeySym.unknown,                // 199   0xC7   -- reserved --
            KeySym.unknown,                // 200   0xC8   -- reserved --
            KeySym.unknown,                // 201   0xC9   -- reserved --
            KeySym.unknown,                // 202   0xCA   -- reserved --
            KeySym.unknown,                // 203   0xCB   -- reserved --
            KeySym.unknown,                // 204   0xCC   -- reserved --
            KeySym.unknown,                // 205   0xCD   -- reserved --
            KeySym.unknown,                // 206   0xCE   -- reserved --
            KeySym.unknown,                // 207   0xCF   -- reserved --
            KeySym.unknown,                // 208   0xD0   -- reserved --
            KeySym.unknown,                // 209   0xD1   -- reserved --
            KeySym.unknown,                // 210   0xD2   -- reserved --
            KeySym.unknown,                // 211   0xD3   -- reserved --
            KeySym.unknown,                // 212   0xD4   -- reserved --
            KeySym.unknown,                // 213   0xD5   -- reserved --
            KeySym.unknown,                // 214   0xD6   -- reserved --
            KeySym.unknown,                // 215   0xD7   -- reserved --
            KeySym.unknown,                // 216   0xD8   -- unassigned --
            KeySym.unknown,                // 217   0xD9   -- unassigned --
            KeySym.unknown,                // 218   0xDA   -- unassigned --
            KeySym.bracketLeft,            // 219   0xDB   VK_OEM_4            | '[{' for US
            KeySym.bar,                    // 220   0xDC   VK_OEM_5            | '\|' for US
            KeySym.bracketRight,           // 221   0xDD   VK_OEM_6            | ']}' for US
            KeySym.quoteDbl,               // 222   0xDE   VK_OEM_7            | ''"' for US
            KeySym.unknown,                // 223   0xDF   VK_OEM_8
            KeySym.unknown,                // 224   0xE0   -- reserved --
            KeySym.unknown,                // 225   0xE1   VK_OEM_AX           | 'AX' key on Japanese AX kbd
            KeySym.unknown,                // 226   0xE2   VK_OEM_102          | "<>" or "\|" on RT 102-key kbd
            KeySym.unknown,                // 227   0xE3   VK_ICO_HELP         | Help key on ICO
            KeySym.unknown,                // 228   0xE4   VK_ICO_00           | 00 key on ICO
            KeySym.unknown,                // 229   0xE5   VK_PROCESSKEY       | IME Process key
            KeySym.unknown,                // 230   0xE6   VK_ICO_CLEAR        |
            KeySym.unknown,                // 231   0xE7   VK_PACKET           | Unicode char as keystrokes
            KeySym.unknown,                // 232   0xE8   -- unassigned --
                                            // Nokia/Ericsson definitions ---------------
            KeySym.unknown,                // 233   0xE9   VK_OEM_RESET
            KeySym.unknown,                // 234   0xEA   VK_OEM_JUMP
            KeySym.unknown,                // 235   0xEB   VK_OEM_PA1
            KeySym.unknown,                // 236   0xEC   VK_OEM_PA2
            KeySym.unknown,                // 237   0xED   VK_OEM_PA3
            KeySym.unknown,                // 238   0xEE   VK_OEM_WSCTRL
            KeySym.unknown,                // 239   0xEF   VK_OEM_CUSEL
            KeySym.unknown,                // 240   0xF0   VK_OEM_ATTN
            KeySym.unknown,                // 241   0xF1   VK_OEM_FINISH
            KeySym.unknown,                // 242   0xF2   VK_OEM_COPY
            KeySym.unknown,                // 243   0xF3   VK_OEM_AUTO
            KeySym.unknown,                // 244   0xF4   VK_OEM_ENLW
            KeySym.unknown,                // 245   0xF5   VK_OEM_BACKTAB
            KeySym.unknown,                // 246   0xF6   VK_ATTN             | Attn key
            KeySym.unknown,                // 247   0xF7   VK_CRSEL            | CrSel key
            KeySym.unknown,                // 248   0xF8   VK_EXSEL            | ExSel key
            KeySym.unknown,                // 249   0xF9   VK_EREOF            | Erase EOF key
            KeySym.play,                   // 250   0xFA   VK_PLAY             | Play key
            KeySym.zoom,                   // 251   0xFB   VK_ZOOM             | Zoom key
            KeySym.unknown,                // 252   0xFC   VK_NONAME           | Reserved
            KeySym.unknown,                // 253   0xFD   VK_PA1              | PA1 key
            KeySym.clear,                  // 254   0xFE   VK_OEM_CLEAR        | Clear key
            KeySym.unknown,
        ];

    }

}
