# gfx:math  -  Maths for Gfx-d (but not only...)

`gfx:math` has no external dependency, and is also agnostic to the coordinate
system of the rendering engine, so it is easy to use it in any application.

The matrices are row-major, which is best for performances.

Performance is decent. Here is a result of the `math/bench` benchmark:

```
LDC / Clang

Benchmark: Matrix multiplication
             Lib	        gfx:math	            gl3n	             glm
        Compiler	      ldc-1.13.0	      ldc-1.13.0	     clang-7.0.1
   Iter/s single	      6.6628e+07	     6.80018e+07	     3.94986e+07
 Iter/s parallel	       4.664e+07	     4.25572e+07	      2.1178e+07

Benchmark: Matrix inversion
             Lib	        gfx:math	            gl3n	             glm
        Compiler	      ldc-1.13.0	      ldc-1.13.0	     clang-7.0.1
   Iter/s single	     4.81757e+06	     9.82315e+06	     1.91701e+07
 Iter/s parallel	      3.5201e+06	     5.48336e+06	     1.28184e+07


DMD / GCC

Benchmark: Matrix multiplication
             Lib	        gfx:math	            gl3n	             glm
        Compiler	     dmd-2.084.0	     dmd-2.084.0	       gcc-8.2.1
   Iter/s single	     1.62738e+07	     1.34356e+07	     3.70883e+07
 Iter/s parallel	     8.25124e+06	      6.8057e+06	     1.83225e+07

Benchmark: Matrix inversion
             Lib	        gfx:math	            gl3n	             glm
        Compiler	     dmd-2.084.0	     dmd-2.084.0	       gcc-8.2.1
   Iter/s single	     1.42325e+06	     6.45558e+06	     2.80551e+07
 Iter/s parallel	          998131	     3.67822e+06	     1.53305e+07
```
