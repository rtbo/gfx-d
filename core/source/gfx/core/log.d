/// Logging module
///
/// This module provides logging functionality.
/// Everything is thread-safe at the exception of global severity and mask
/// getters/setters. This is done so to avoid paying for synchronization of log
/// entries that will be filtered out.
module gfx.core.log;

import core.sync.mutex : Mutex;
import std.datetime : SysTime;

/// LogTag encapsulate a string tag and a bitmask.
/// It a also have helpers to log entries with the given tag and mask.
struct LogTag
{
    string tag;
    uint mask = 0xffff_ffff;

    /// add a log entry with this tag
    void log (in Severity sev, scope lazy string msg) const
    {
        .log (sev, mask, tag, msg);
    }

    /// add a formatted log entry with this tag
    void logf (Args...)(in Severity sev, in string fmt, Args args) const
    {
        .logf (sev, mask, tag, fmt, args);
    }

    /// add a trace log entry with this tag
    void trace (scope lazy string msg) const
    {
        .log (Severity.trace, mask, tag, msg);
    }

    /// add a formatted trace log entry with this tag
    void tracef (Args...)(in string fmt, Args args) const
    {
        .logf (Severity.trace, mask, tag, fmt, args);
    }

    /// add a debug log entry with this tag
    void debug_ (scope lazy string msg) const
    {
        .log (Severity.debug_, mask, tag, msg);
    }

    /// add a formatted debug log entry with this tag
    void debugf (Args...)(in string fmt, Args args) const
    {
        .logf (Severity.debug_, mask, tag, fmt, args);
    }

    /// add a info log entry with this tag
    void info (scope lazy string msg) const
    {
        .log (Severity.info, mask, tag, msg);
    }

    /// add a formatted info log entry with this tag
    void infof (Args...)(in string fmt, Args args) const
    {
        .logf (Severity.info, mask, tag, fmt, args);
    }

    /// add a warning log entry with this tag
    void warning (scope lazy string msg) const
    {
        .log (Severity.warning, mask, tag, msg);
    }

    /// add a formatted warning log entry with this tag
    void warningf (Args...)(in string fmt, Args args) const
    {
        .logf (Severity.warning, mask, tag, fmt, args);
    }

    /// add a error log entry with this tag
    void error (scope lazy string msg) const
    {
        .log (Severity.error, mask, tag, msg);
    }

    /// add a formatted error log entry with this tag
    void errorf (Args...)(in string fmt, Args args) const
    {
        .logf (Severity.error, mask, tag, fmt, args);
    }
}

/// Log messages severity
enum Severity
{
    ///
    trace,
    /// debug messages
    debug_,
    ///
    info,
    ///
    warning,
    ///
    error,
}

debug {
    /// The default severity
    enum defaultSeverity = Severity.debug_;
}
else {
    /// The default severity
    enum defaultSeverity = Severity.info;
}

/// The default filter mask
enum uint defaultMask = 0xffff_ffff;

/// add a log entry
void log (in Severity sev, in string tag, scope lazy string msg)
{
    if (cast(int)sev >= cast(int)s_sev) {
        s_mutex.lock();
        scope(exit) s_mutex.unlock();

        s_logger.print(s_msgFmt.formatMsg(sev, tag, msg));
    }
}
/// ditto
void log (in Severity sev, in uint mask, in string tag, scope lazy string msg)
{
    if (cast(int)sev >= cast(int)s_sev && (mask & s_mask) != 0) {
        s_mutex.lock();
        scope(exit) s_mutex.unlock();

        s_logger.print(s_msgFmt.formatMsg(sev, tag, msg));
    }
}
/// ditto
void logf (Args...) (in Severity sev, in string tag, in string fmt, Args args)
{
    import std.format : format;

    if (cast(int)sev >= cast(int)s_sev) {
        s_mutex.lock();
        scope(exit) s_mutex.unlock();

        s_logger.print(s_msgFmt.formatMsg(sev, tag, format(fmt, args)));
    }
}
/// ditto
void logf (Args...) (in Severity sev, in uint mask, in string tag, in string fmt, Args args)
{
    import std.format : format;

    if (cast(int)sev >= cast(int)s_sev && (mask & s_mask) != 0) {
        s_mutex.lock();
        scope(exit) s_mutex.unlock();

        s_logger.print(s_msgFmt.formatMsg(sev, tag, format(fmt, args)));
    }
}

/// add a log entry with trace severity
void trace (in string tag, scope lazy string msg)
{
    log (Severity.trace, tag, msg);
}
/// ditto
void trace (in uint mask, in string tag, scope lazy string msg)
{
    log (Severity.trace, mask, tag, msg);
}
/// ditto
void tracef (Args...)(in string tag, in string fmt, Args args)
{
    logf (Severity.trace, tag, fmt, args);
}
/// ditto
void tracef (Args...)(in uint mask, in string tag, in string fmt, Args args)
{
    logf (Severity.trace, mask, tag, fmt, args);
}

/// add a log entry with debug severity
void debug_ (in string tag, scope lazy string msg)
{
    log (Severity.debug_, tag, msg);
}
/// ditto
void debug_ (in uint mask, in string tag, scope lazy string msg)
{
    log (Severity.debug_, mask, tag, msg);
}
/// ditto
void debugf (Args...)(in string tag, in string fmt, Args args)
{
    logf (Severity.debug_, tag, fmt, args);
}
/// ditto
void debugf (Args...)(in uint mask, in string tag, in string fmt, Args args)
{
    logf (Severity.debug_, mask, tag, fmt, args);
}

/// add a log entry with info severity
void info (in string tag, scope lazy string msg)
{
    log (Severity.info, tag, msg);
}
/// ditto
void info (in uint mask, in string tag, scope lazy string msg)
{
    log (Severity.info, mask, tag, msg);
}
/// ditto
void infof (Args...)(in string tag, in string fmt, Args args)
{
    logf (Severity.info, tag, fmt, args);
}
/// ditto
void infof (Args...)(in uint mask, in string tag, in string fmt, Args args)
{
    logf (Severity.info, mask, tag, fmt, args);
}

/// add a log entry with warning severity
void warning (in string tag, scope lazy string msg)
{
    log (Severity.warning, tag, msg);
}
/// ditto
void warning (in uint mask, in string tag, scope lazy string msg)
{
    log (Severity.warning, mask, tag, msg);
}
/// ditto
void warningf (Args...)(in string tag, in string fmt, Args args)
{
    logf (Severity.warning, tag, fmt, args);
}
/// ditto
void warningf (Args...)(in uint mask, in string tag, in string fmt, Args args)
{
    logf (Severity.warning, mask, tag, fmt, args);
}

/// add a log entry with error severity
void error (in string tag, scope lazy string msg)
{
    log (Severity.error, tag, msg);
}
/// ditto
void error (in uint mask, in string tag, scope lazy string msg)
{
    log (Severity.error, mask, tag, msg);
}
/// ditto
void errorf (Args...)(in string tag, in string fmt, Args args)
{
    logf (Severity.error, tag, fmt, args);
}
/// ditto
void errorf (Args...)(in uint mask, in string tag, in string fmt, Args args)
{
    logf (Severity.error, mask, tag, fmt, args);
}

/// An abstract logger. All log operations are synchronized by a global mutex.
/// Implementations do not need to bother about thread safety.
interface Logger
{
    /// print msg into the log
    void print(in string msg);
    /// release resource associated with the logger
    void close();
}

/// A logger that prints into a file
class FileLogger : Logger
{
    import std.stdio : File;

    private File file;

    /// open file pointed to by name with mode
    this (in string name, in string mode="a")
    {
        file = File(name, mode);
    }

    override void print(in string msg)
    {
        file.writeln(msg);
    }

    override void close()
    {
        file.close();
    }
}

/// A logger that prints to stdout
class StdOutLogger : Logger
{
    override void print (in string msg)
    {
        import std.stdio : stdout;

        stdout.writeln(msg);
    }

    override void close() {}
}

/// A logger that prints to stderr
class StdErrLogger : Logger
{
    override void print (in string msg)
    {
        import std.stdio : stderr;

        stderr.writeln(msg);
    }

    override void close() {}
}

/// The installed logger.
/// By default StdOutLogger.
/// Assigning null re-assign the default
@property Logger logger()
{
    s_mutex.lock();
    scope(exit) s_mutex.unlock();

    return s_logger;
}
/// ditto
@property void logger (Logger logger)
{
    s_mutex.lock();
    scope(exit) s_mutex.unlock();

    if (logger !is s_logger) {
        s_logger.close();
    }
    s_logger = logger;
    if (!s_logger) {
        s_logger = new StdOutLogger;
    }
}

/// Minimum Severity for message filtering.
/// All messages with lower severity are filtered out.
/// By default Severity.info in release builds and Severity.debug_ in debug builds.
@property Severity severity()
{
    return s_sev;
}
/// ditto
@property void severity (in Severity sev)
{
    s_sev = sev;
}

/// A mask for bypassing some messages.
/// By default 0xffffffff
@property uint mask()
{
    return s_mask;
}
/// ditto
@property void mask(in uint mask)
{
    s_mask = mask;
}

/// the default format string for log messages
enum string defaultMsgFormat = "%d %p%s: %t %m";

/// The format string for log messages
/// The entries are as follow:
///  - %d: datetime (formatted according timeFormat)
///  - %s: severity
///  - %p: padding of severity
///  - %t: tag
///  - %m: msg
/// The default format string is defaultMsgFormat
@property string msgFormat()
{
    s_mutex.lock();
    scope(exit) s_mutex.unlock();

    return s_msgFmt.fmt;
}
/// ditto
@property void msgFormat(in string fmt)
{
    import std.utf : validate;

    validate(fmt);

    s_mutex.lock();
    scope(exit) s_mutex.unlock();

    s_msgFmt = MessageFmt(fmt);
}

/// the default format string for date-time
enum string defaultTimeFormat = "HH:ii:ss.FFF";

/// The format string for date-time in log message
/// The format of this string is the same as smjg.libs.util.datetime:
/// http://pr.stewartsplace.org.uk/d/sutil/doc/datetimeformat.html
@property string timeFormat()
{
    s_mutex.lock();
    scope(exit) s_mutex.unlock();

    return s_timeFmt;
}
/// ditto
@property void timeFormat(in string fmt)
{
    import std.utf : validate;

    validate(fmt);

    s_mutex.lock();
    scope(exit) s_mutex.unlock();

    s_timeFmt = fmt;
}

private:

__gshared {
    Mutex s_mutex;
    Logger s_logger;
    Severity s_sev;
    uint s_mask;
    string s_timeFmt;
    MessageFmt s_msgFmt;
}

shared static this()
{
    s_mutex = new Mutex();
    s_logger = new StdOutLogger;
    s_sev = defaultSeverity;
    s_mask = defaultMask;
    s_timeFmt = defaultTimeFormat;
    s_msgFmt = MessageFmt(defaultMsgFormat);
}

shared static ~this()
{
    s_logger.close();
}

struct MessageFmt
{
    enum EntryType {
        str, datetime, sev, pad, tag, msg,
    }
    struct Entry {
        EntryType typ;
        string str;
    }

    this (string fmt)
    {
        this.fmt = fmt;

        string curStr;
        bool percent;
        foreach (char c; fmt) {
            if (percent) {
                switch (c) {
                case 'd': entries ~= Entry(EntryType.datetime); break;
                case 's': entries ~= Entry(EntryType.sev); break;
                case 'p': entries ~= Entry(EntryType.pad); break;
                case 't': entries ~= Entry(EntryType.tag); break;
                case 'm': entries ~= Entry(EntryType.msg); break;
                default: throw new Exception("unknown log format entry: %"~c);
                }
                percent = false;
            }
            else if (c == '%') {
                if (curStr.length) {
                    entries ~= Entry(EntryType.str, curStr);
                    curStr = null;
                }
                percent = true;
            }
            else {
                curStr ~= c;
            }
        }
        if (curStr.length) {
            entries ~= Entry(EntryType.str, curStr);
        }
    }

    string fmt;
    Entry[] entries;

    string formatMsg(in Severity sev, in string tag, in string msg)
    {
        import std.datetime : Clock;

        string res;
        foreach (entry; entries) {
            final switch (entry.typ) {
            case EntryType.str:  res ~= entry.str;                      break;
            case EntryType.datetime: res ~= formatTime(Clock.currTime); break;
            case EntryType.sev: res ~= sevString(sev);                  break;
            case EntryType.pad: res ~= sevPadString(sev);               break;
            case EntryType.tag : res ~= tag;                            break;
            case EntryType.msg : res ~= msg;                            break;
            }
        }
        return res;
    }
}

string sevString(in Severity sev) pure
{
    final switch (sev)
    {
    case Severity.trace: return "TRACE";
    case Severity.debug_: return "DEBUG";
    case Severity.info: return "INFO";
    case Severity.warning: return "WARN";
    case Severity.error: return "ERROR";
    }
}

string sevPadString(in Severity sev) pure
{
    final switch (sev)
    {
    case Severity.trace: return null;
    case Severity.debug_: return null;
    case Severity.info: return " ";
    case Severity.warning: return " ";
    case Severity.error: return null;
    }
}

string formatTime(SysTime time)
{
    import gfx.priv.datetimeformat : format;

    return format(time, s_timeFmt);
}
