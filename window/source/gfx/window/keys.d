/// Key enumeration module.
module gfx.window.keys;


/// Modifier mask
enum KeyMods
{
    none    = 0,

    ctrlMask        = 0x01,
    shiftMask       = 0x02,
    superMask       = 0x04,
    altMask         = 0x08,

    leftMask        = 0x20,
    rightMask       = 0x40,

    leftCtrl    = ctrlMask  | leftMask,
    rightCtrl   = ctrlMask  | rightMask,
    leftShift   = shiftMask | leftMask,
    rightShift  = shiftMask | rightMask,
    leftAlt     = altMask   | leftMask,
    rightAlt    = altMask   | rightMask,
    leftSuper   = superMask | leftMask,
    rightSuper  = superMask | rightMask,

    ctrl        = leftCtrl  | rightCtrl,
    alt         = leftAlt   | rightAlt,
    super_      = leftSuper | rightSuper,
    shift       = leftShift | rightShift,
}


/// Represents a physical key (or scancode), using QWERTY US keymap as basis.
/// I.e. the key "A" on an AZERTY keyboard is represented by `Code.Q`.
/// This enum has 256 values and is a perfect candidate for index based
/// look-up table.
/// Values of enumerants are from the USB HID scancodes table.
enum KeyCode : ubyte
{
    none                = 0,
    errorRollOver       = 1,
    postFail            = 2,
    errorUndefined      = 3,
    a                   = 4,
    b                   = 5,
    c                   = 6,
    d                   = 7,
    e                   = 8,
    f                   = 9,
    g                   = 10,
    h                   = 11,
    i                   = 12,
    j                   = 13,
    k                   = 14,
    l                   = 15,
    m                   = 16,
    n                   = 17,
    o                   = 18,
    p                   = 19,
    q                   = 20,
    r                   = 21,
    s                   = 22,
    t                   = 23,
    u                   = 24,
    v                   = 25,
    w                   = 26,
    x                   = 27,
    y                   = 28,
    z                   = 29,
    d1                  = 30,
    d2                  = 31,
    d3                  = 32,
    d4                  = 33,
    d5                  = 34,
    d6                  = 35,
    d7                  = 36,
    d8                  = 37,
    d9                  = 38,
    d0                  = 39,
    enter               = 40,
    escape              = 41,
    backspace           = 42,
    tab                 = 43,
    space               = 44,
    minus               = 45,
    equals              = 46,
    leftBracket         = 47,
    rightBracket        = 48,
    backslash           = 49,
    uK_Hash             = 50,
    semicolon           = 51,
    quote               = 52,
    grave               = 53,
    comma               = 54,
    period              = 55,
    slash               = 56,
    capsLock            = 57,
    f1                  = 58,
    f2                  = 59,
    f3                  = 60,
    f4                  = 61,
    f5                  = 62,
    f6                  = 63,
    f7                  = 64,
    f8                  = 65,
    f9                  = 66,
    f10                 = 67,
    f11                 = 68,
    f12                 = 69,
    printScreen         = 70,
    scrollLock          = 71,
    pause               = 72,
    insert              = 73,
    home                = 74,
    pageUp              = 75,
    delete_             = 76,
    end                 = 77,
    pageDown            = 78,
    right               = 79,
    left                = 80,
    down                = 81,
    up                  = 82,
    kp_NumLock          = 83,
    kp_Divide           = 84,
    kp_Multiply         = 85,
    kp_Subtract         = 86,
    kp_Add              = 87,
    kp_Enter            = 88,
    kp_1                = 89,
    kp_2                = 90,
    kp_3                = 91,
    kp_4                = 92,
    kp_5                = 93,
    kp_6                = 94,
    kp_7                = 95,
    kp_8                = 96,
    kp_9                = 97,
    kp_0                = 98,
    kp_Period           = 99,
    uK_Backslash        = 100,
    kp_Equal            = 103,
    f13                 = 104,
    f14                 = 105,
    f15                 = 106,
    f16                 = 107,
    f17                 = 108,
    f18                 = 109,
    f19                 = 110,
    f20                 = 111,
    f21                 = 112,
    f22                 = 113,
    f23                 = 114,
    f24                 = 115,
    execute             = 116,
    help                = 117,
    menu                = 118,
    select              = 119,
    stop                = 120,
    again               = 121,
    undo                = 122,
    cut                 = 123,
    copy                = 124,
    paste               = 125,
    find                = 126,
    mute                = 127,
    volumeUp            = 128,
    volumeDown          = 129,
    lockingCapsLock     = 130,
    lockingNumLock      = 131,
    lockingScrollLock   = 132,
    kp_Comma            = 133,
    kp_EqualSign        = 134,
    international1      = 135,
    international2      = 136,
    international3      = 137,
    international4      = 138,
    international5      = 139,
    international6      = 140,
    international7      = 141,
    international8      = 142,
    international9      = 143,
    lang1               = 144,  // Hangul / English toggle
    lang2               = 145,  // Hanja conversion
    lang3               = 146,  // Katakana
    lang4               = 147,  // Hiragana
    lang5               = 148,  // Zenkaku/Hankaku
    lang6               = 149,
    lang7               = 150,
    lang8               = 151,
    lang9               = 152,
    altErase            = 153,
    sysReq              = 154,
    cancel              = 155,
    clear               = 156,
    prior               = 157,
    return_             = 158,
    separator           = 159,
    out_                = 160,
    oper                = 161,
    clearAgain          = 162,
    crSelProps          = 163,
    exSel               = 164,

    kp_00               = 176,
    kp_000              = 177,
    thousandsSep        = 178,
    decimalSep          = 179,
    currencyUnit        = 180,
    currencySubUnit     = 181,
    kp_LeftParent       = 182,
    kp_RightParent      = 183,
    kp_LeftCurly        = 184,
    kp_RightCurly       = 185,
    kp_Tab              = 186,
    kp_Backspace        = 187,
    kp_A                = 188,
    kp_B                = 189,
    kp_C                = 190,
    kp_D                = 191,
    kp_E                = 192,
    kp_F                = 193,
    kp_XOR              = 194,
    kp_Pow              = 195,
    kp_Percent          = 196,
    kp_LeftAngle        = 197,
    kp_RightAngle       = 198,
    kp_BitAnd           = 199,
    kp_LogicAnd         = 200,
    kp_BitOr            = 201,
    kp_LogicOr          = 202,
    kp_Colon            = 203,
    kp_Hash             = 204,
    kp_Space            = 205,
    kp_At               = 206,
    kp_Not              = 207,
    kp_MemStore         = 208,
    kp_MemRecall        = 209,
    kp_MemClear         = 210,
    kp_MemAdd           = 211,
    kp_MemSubtract      = 212,
    kp_MemMultiply      = 213,
    kp_MemDivide        = 214,
    kp_PlusMinus        = 215,
    kp_Clear            = 216,
    kp_ClearEntry       = 217,
    kp_Binary           = 218,
    kp_Octal            = 219,
    kp_Decimal          = 220,
    kp_Hexadecimal      = 221,

    leftCtrl            = 224,
    leftShift           = 225,
    leftAlt             = 226,
    leftSuper           = 227,
    rightCtrl           = 228,
    rightShift          = 229,
    rightAlt            = 230,
    rightSuper          = 231,

    unknown             = 255
}

/// Represent a virtual key, which is a key translated with a keymap.
enum KeySym : uint
{
    none                    = 0,

    controlMask             = 0x8000_0000,
    keypadMask              = 0x4000_0000,
    mediaMask               = 0x2000_0000,
    imeMask                 = 0x1000_0000,

    modMask                 = 0x0080_0000,

    ctrlMask                = 0x0001_0000,
    shiftMask               = 0x0002_0000,
    metaMask                = 0x0004_0000,
    altMask                 = 0x0008_0000,
    superMask               = 0x0010_0000,
    leftMask                = 0x0020_0000,
    rightMask               = 0x0040_0000,

    latin1SmallMask         = 0x0000_0020,

    unknown                 = 0x0000_ffdf,


    escape                  = controlMask | 1,
    tab,
    leftTab,
    backspace,
    return_,
    delete_,
    sysRq,
    pause,
    clear,

    capsLock,
    numLock,
    scrollLock,

    left,
    up,
    right,
    down,
    pageUp,
    pageDown,
    home,
    end,

    print,
    insert,
    menu,
    help,
    break_,

    f1,
    f2,
    f3,
    f4,
    f5,
    f6,
    f7,
    f8,
    f9,
    f10,
    f11,
    f12,
    f13,
    f14,
    f15,
    f16,
    f17,
    f18,
    f19,
    f20,
    f21,
    f22,
    f23,
    f24,

    kp_Enter                = keypadMask | 1,
    kp_Delete,
    kp_Home,
    kp_Begin,
    kp_End,
    kp_PageUp,
    kp_PageDown,
    kp_Up,
    kp_Down,
    kp_Left,
    kp_Right,
    kp_Equal,
    kp_Multiply,
    kp_Add,
    kp_Divide,
    kp_Subtract,
    kp_Decimal,
    kp_Separator,

    kp_0,
    kp_1,
    kp_2,
    kp_3,
    kp_4,
    kp_5,
    kp_6,
    kp_7,
    kp_8,
    kp_9,

    leftCtrl                = ctrlMask  | leftMask  | modMask,
    rightCtrl               = ctrlMask  | rightMask | modMask,
    leftShift               = shiftMask | leftMask  | modMask,
    rightShift              = shiftMask | rightMask | modMask,
    leftAlt                 = altMask   | leftMask  | modMask,
    rightAlt                = altMask   | rightMask | modMask,
    leftSuper               = superMask | leftMask  | modMask,
    rightSuper              = superMask | rightMask | modMask,

    ctrl                    = leftCtrl  | rightCtrl,
    shift                   = leftShift | rightShift,
    alt                     = leftAlt   | rightAlt,
    super_                  = leftSuper | rightSuper,

    altGr                   = rightAlt,

    /*
     * Latin 1
     * (ISO/IEC 8859-1 = Unicode U+0020..U+00FF)
     * Byte 3 = 0
     */
    space                   = 0x0000_0020,  /* U+0020 SPACE */
    exclam                  = 0x0000_0021,  /* U+0021 EXCLAMATION MARK */
    quoteDbl                = 0x0000_0022,  /* U+0022 QUOTATION MARK */
    numbersign              = 0x0000_0023,  /* U+0023 NUMBER SIGN */
    dollar                  = 0x0000_0024,  /* U+0024 DOLLAR SIGN */
    percent                 = 0x0000_0025,  /* U+0025 PERCENT SIGN */
    ampersand               = 0x0000_0026,  /* U+0026 AMPERSAND */
    apostrophe              = 0x0000_0027,  /* U+0027 APOSTROPHE */
    parenleft               = 0x0000_0028,  /* U+0028 LEFT PARENTHESIS */
    parenright              = 0x0000_0029,  /* U+0029 RIGHT PARENTHESIS */
    asterisk                = 0x0000_002a,  /* U+002A ASTERISK */
    plus                    = 0x0000_002b,  /* U+002B PLUS SIGN */
    comma                   = 0x0000_002c,  /* U+002C COMMA */
    minus                   = 0x0000_002d,  /* U+002D HYPHEN-MINUS */
    period                  = 0x0000_002e,  /* U+002E FULL STOP */
    slash                   = 0x0000_002f,  /* U+002F SOLIDUS */
    d0                      = 0x0000_0030,  /* U+0030 DIGIT ZERO */
    d1                      = 0x0000_0031,  /* U+0031 DIGIT ONE */
    d2                      = 0x0000_0032,  /* U+0032 DIGIT TWO */
    d3                      = 0x0000_0033,  /* U+0033 DIGIT THREE */
    d4                      = 0x0000_0034,  /* U+0034 DIGIT FOUR */
    d5                      = 0x0000_0035,  /* U+0035 DIGIT FIVE */
    d6                      = 0x0000_0036,  /* U+0036 DIGIT SIX */
    d7                      = 0x0000_0037,  /* U+0037 DIGIT SEVEN */
    d8                      = 0x0000_0038,  /* U+0038 DIGIT EIGHT */
    d9                      = 0x0000_0039,  /* U+0039 DIGIT NINE */
    colon                   = 0x0000_003a,  /* U+003A COLON */
    semicolon               = 0x0000_003b,  /* U+003B SEMICOLON */
    less                    = 0x0000_003c,  /* U+003C LESS-THAN SIGN */
    equal                   = 0x0000_003d,  /* U+003D EQUALS SIGN */
    greater                 = 0x0000_003e,  /* U+003E GREATER-THAN SIGN */
    question                = 0x0000_003f,  /* U+003F QUESTION MARK */
    at                      = 0x0000_0040,  /* U+0040 COMMERCIAL AT */
    a                       = 0x0000_0041,  /* U+0041 LATIN CAPITAL LETTER A */
    b                       = 0x0000_0042,  /* U+0042 LATIN CAPITAL LETTER B */
    c                       = 0x0000_0043,  /* U+0043 LATIN CAPITAL LETTER C */
    d                       = 0x0000_0044,  /* U+0044 LATIN CAPITAL LETTER D */
    e                       = 0x0000_0045,  /* U+0045 LATIN CAPITAL LETTER E */
    f                       = 0x0000_0046,  /* U+0046 LATIN CAPITAL LETTER F */
    g                       = 0x0000_0047,  /* U+0047 LATIN CAPITAL LETTER G */
    h                       = 0x0000_0048,  /* U+0048 LATIN CAPITAL LETTER H */
    i                       = 0x0000_0049,  /* U+0049 LATIN CAPITAL LETTER I */
    j                       = 0x0000_004a,  /* U+004A LATIN CAPITAL LETTER J */
    k                       = 0x0000_004b,  /* U+004B LATIN CAPITAL LETTER K */
    l                       = 0x0000_004c,  /* U+004C LATIN CAPITAL LETTER L */
    m                       = 0x0000_004d,  /* U+004D LATIN CAPITAL LETTER M */
    n                       = 0x0000_004e,  /* U+004E LATIN CAPITAL LETTER N */
    o                       = 0x0000_004f,  /* U+004F LATIN CAPITAL LETTER O */
    p                       = 0x0000_0050,  /* U+0050 LATIN CAPITAL LETTER P */
    q                       = 0x0000_0051,  /* U+0051 LATIN CAPITAL LETTER Q */
    r                       = 0x0000_0052,  /* U+0052 LATIN CAPITAL LETTER R */
    s                       = 0x0000_0053,  /* U+0053 LATIN CAPITAL LETTER S */
    t                       = 0x0000_0054,  /* U+0054 LATIN CAPITAL LETTER T */
    u                       = 0x0000_0055,  /* U+0055 LATIN CAPITAL LETTER U */
    v                       = 0x0000_0056,  /* U+0056 LATIN CAPITAL LETTER V */
    w                       = 0x0000_0057,  /* U+0057 LATIN CAPITAL LETTER W */
    x                       = 0x0000_0058,  /* U+0058 LATIN CAPITAL LETTER X */
    y                       = 0x0000_0059,  /* U+0059 LATIN CAPITAL LETTER Y */
    z                       = 0x0000_005a,  /* U+005A LATIN CAPITAL LETTER Z */
    bracketLeft             = 0x0000_005b,  /* U+005B LEFT SQUARE BRACKET */
    backslash               = 0x0000_005c,  /* U+005C REVERSE SOLIDUS */
    bracketRight            = 0x0000_005d,  /* U+005D RIGHT SQUARE BRACKET */
    asciicircum             = 0x0000_005e,  /* U+005E CIRCUMFLEX ACCENT */
    underscore              = 0x0000_005f,  /* U+005F LOW LINE */
    grave                   = 0x0000_0060,  /* U+0060 GRAVE ACCENT */
    braceLeft               = 0x0000_007b,  /* U+007B LEFT CURLY BRACKET */
    bar                     = 0x0000_007c,  /* U+007C VERTICAL LINE */
    braceRight              = 0x0000_007d,  /* U+007D RIGHT CURLY BRACKET */
    asciiTilde              = 0x0000_007e,  /* U+007E TILDE */

    browserBack             = mediaMask | 1,
    browserForward,
    browserStop,
    browserRefresh,
    browserHome,
    browserFavorites,
    browserSearch,
    volumeDown,
    volumeMute,
    volumeUp,
    bassBoost,
    bassUp,
    bassDown,
    trebleUp,
    trebleDown,
    mediaPlay,
    mediaStop,
    mediaPrevious,
    mediaNext,
    mediaRecord,
    mediaPause,
    mediaTogglePlayPause,
    standby,
    openUrl,
    myComputer,
    launchMail,
    launchMedia,
    launch0,
    launch1,
    launch2,
    launch3,
    launch4,
    launch5,
    launch6,
    launch7,
    launch8,
    launch9,
    launchA,
    launchB,
    launchC,
    launchD,
    launchE,
    launchF,
    monBrightnessUp,
    monBrightnessDown,
    keyboardLightOnOff,
    keyboardBrightnessUp,
    keyboardBrightnessDown,
    powerOff,
    wakeUp,
    eject,
    screenSaver,
    www,
    memo,
    lightBulb,
    shop,
    history,
    addFavorite,
    hotLinks,
    brightnessAdjust,
    finance,
    community,
    audioRewind, // Media rewind
    backForward,
    applicationLeft,
    applicationRight,
    book,
    cd,
    calculator,
    todoList,
    clearGrab,
    close,
    copy,
    cut,
    display, // Output switch key
    dos,
    documents,
    excel,
    explorer,
    game,
    go,
    iTouch,
    logOff,
    market,
    meeting,
    menuKB,
    menuPB,
    mySites,
    news,
    officeHome,
    option,
    paste,
    phone,
    calendar,
    reply,
    reload,
    rotateWindows,
    rotationPB,
    rotationKB,
    save,
    send,
    spell,
    splitScreen,
    support,
    taskPane,
    terminal,
    tools,
    travel,
    video,
    word,
    xfer,
    zoomIn,
    zoomOut,
    away,
    messenger,
    webCam,
    mailForward,
    pictures,
    music,
    battery,
    bluetooth,
    wlan,
    uwb,
    audioForward, // Media fast-forward
    audioRepeat, // Toggle repeat mode
    audioRandomPlay, // Toggle shuffle mode
    subtitle,
    audioCycleTrack,
    time,
    hibernate,
    view,
    topMenu,
    powerDown,
    suspend,
    contrastAdjust,

    launchG,
    launchH,

    touchpadToggle,
    touchpadOn,
    touchpadOff,

    micMute,

    red,
    green,
    yellow,
    blue,

    channelUp,
    channelDown,

    guide,
    info,
    settings,

    micVolumeUp,
    micVolumeDown,

    new_,
    open,
    find,
    undo,
    redo,

    mediaLast,

    // Keypad navigation keys
    select,
    yes,
    no,

    // Newer misc keys
    cancel,
    printer,
    execute,
    sleep,
    play, // Not the same as MediaPlay
    zoom,
    exit,

    // Device keys
    context1,
    context2,
    context3,
    context4,
    call,      // set absolute state to in a call (do not toggle state)
    hangUp,    // set absolute state to hang up (do not toggle state)
    flip,
    toggleCallHangUp, // a toggle key for answering, or hanging up, based on current call state
    voiceDial,
    lastNumberRedial,

    camera,
    cameraFocus,

    convert                         = imeMask | 1,
    nonConvert,
    accept,
    modeSwitch,
    final_,
    kana,
    hangul,
    junja,
    hanja,
    kanji,
    jisho,
    masshou,
    touroku,
    oyayubiLeft,
    oyayubiRight,
}
