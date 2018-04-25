import gfx.math.mat;
import std.datetime.stopwatch;
import std.math;
import std.stdio;

enum long numIters = 10_000;

void main()
{
    auto m = FMat4(
        1, 0, 0, 5,
        0, 1, 0, 6,
        0, 0, 1, 7,
        0, 0, 0, 1,
    );
    const sp = FMat4(
        4, 0, 0, 0,
        0, 8, 0, 0,
        0, 0, 2, 0,
        0, 0, 0, 1,
    );
    const sm = FMat4(
        0.25, 0, 0, 0,
        0, 0.125, 0, 0,
        0, 0, 0.5, 0,
        0, 0, 0, 1,
    );
    StopWatch sw;
    sw.start();
    foreach (i; 0 .. numIters) {
        if (i % 2) {
            m = sp * m;
        }
        else {
            m = sm * m;
        }
    }
    const usecs = sw.peek().total!"usecs"();
    writefln("final matrix: %s", m);
    writefln("executed %s multiplications in %s usecs", numIters, usecs);
    writefln("(%s multiplications per second)", numIters*1_000_000 / usecs);
}
