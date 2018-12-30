/// High-level utilities module
module gfx.hl.util;

/// Frames-per-second measurement probe
struct FpsProbe
{
    import std.datetime : Duration;
    import std.datetime.stopwatch : StopWatch;

    private StopWatch sw;
    private size_t lastUsecs;
    private size_t lastFc;
    private size_t fc;

    /// Start the probe
    void start()
    {
        sw.start();
    }

    /// Stop the probe and reset internal state
    void stop()
    {
        sw.stop();
        lastUsecs = 0;
        lastFc = 0;
        fc = 0;
    }

    /// Call this once per frame to indicate a frame tick
    void tick()
    {
        fc += 1;
    }

    /// Number of frames ticked since start
    size_t framecount() const
    {
        return fc;
    }

    /// Elapsed time since start
    Duration elapsed() const
    {
        return sw.peek();
    }

    /// Compute the numbers of frames per seconds since the previous call
    /// of computeFps, or since start if it wasn't call before.
    float computeFps()
    {
        const usecs = sw.peek().total!"usecs"();
        const fps = 1000_000f * (fc - lastFc) / (usecs-lastUsecs);
        lastFc = fc;
        lastUsecs = usecs;
        return fps;
    }
}
