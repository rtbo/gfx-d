module app;

import bench;
import matmul;
import matinv;

void main(string[] args)
{
    import std.getopt : config, defaultGetoptPrinter, getopt;

    string dc;
    string cc;

    auto helpInfo = getopt(args,
        config.required, "dc", "D compiler and version", &dc,
        config.required, "cc", "C++ compiler and version", &cc
    );

    if (helpInfo.helpWanted) {
        defaultGetoptPrinter("Gfx-d Math benchmark", helpInfo.options);
    }

    benchmark("Matrix multiplication", dc, cc, &gfxMatMul, &gl3nMatMul, &glmMatMul, 5_000_000);
    benchmark("Matrix inversion", dc, cc, &gfxMatInv, &gl3nMatInv, &glmMatInv, 2_000_000);
}
