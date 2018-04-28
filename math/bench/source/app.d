module app;

import bench;
import matmul;
import matinv;


void main(string[] args)
{
    static import std.compiler;
    import std.format : format;
    string dc = format("%s-%x.%03s", std.compiler.name, std.compiler.version_major, std.compiler.version_minor);
    string cc = "(unknown c++)";
    if (args.length > 1) {
        import std.string : splitLines;
        cc = args[1].splitLines()[0];
    }
    benchmark("Matrix multiplication", dc, cc, &gfxMatMul, &gl3nMatMul, &glmMatMul);
    benchmark("Matrix inversion", dc, cc, &gfxMatInv, &gl3nMatInv, &glmMatInv);
}
