module bench;


alias Func = int function(int iter);

struct Measurement {
    ulong singleNSecs;
    ulong[] multiNSecs;
    ulong iters;

    @property double singlePerSec() const {
        return iters * 1_000_000_000 / cast(double)singleNSecs;
    }
    @property double multiPerSec() const {
        double sum=0;
        foreach(nsecs; multiNSecs) {
            sum += iters * 1_000_000_000 / cast(double)nsecs;
        }
        return sum / multiNSecs.length;
    }
}

Measurement measure(Func f, const int iter)
{
    import std.datetime.stopwatch : StopWatch;
    import std.parallelism : parallel, totalCPUs;

    Measurement mes;

    {
        StopWatch sw;
        sw.start();
        mes.iters = f(iter);
        sw.stop();
        mes.singleNSecs = sw.peek.total!"nsecs";
    }

    mes.multiNSecs = new ulong[ 2 * totalCPUs ];
    foreach (ref nsecs; parallel(mes.multiNSecs)) {
        StopWatch sw;
        sw.start();
        f(iter);
        sw.stop();
        nsecs = sw.peek.total!"nsecs";
    }
    return mes;
}

void benchmark(string name, string dc, string cc, Func gfxF, Func gl3nF, Func glmF, const int iter)
{
    const gfx = measure(gfxF, iter);
    const gl3n = measure(gl3nF, iter);
    const glm = measure(glmF, iter);

    import std.stdio : writefln;
    writefln("Benchmark: %s", name);
    writefln("%16s\t%16s\t%16s\t%16s", "Lib", "gfx:math", "gl3n", "glm");
    writefln("%16s\t%16s\t%16s\t%16s", "Compiler", dc, dc, cc);
    writefln("%16s\t%16s\t%16s\t%16s", "Iter/s single", gfx.singlePerSec, gl3n.singlePerSec, glm.singlePerSec);
    writefln("%16s\t%16s\t%16s\t%16s", "Iter/s parallel", gfx.multiPerSec, gl3n.multiPerSec, glm.multiPerSec);
    writefln("");
}
