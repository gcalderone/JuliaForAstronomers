# Julia for Astronomers

The material in this repository grow out of a few talks entitled [Julia for Astronomers](https://gcalderone.github.io/JuliaForAstronomers/) I gave in Italy and Switzerland.  Here you will find all the code shown in the talks, as well as a brief introduction on how to start using Julia.

## What is Julia ?

Julia is a new, MIT-licensed (free and open source) and multiplatform (Linux, OSX, Windows) programming language specifically designed for numerical computation.  For Astronomers, the most important Julia features are:
- the very high performances, approaching that of C or FORTRAN.
- the ease of use;

Besides the above mentioned aspects Julia provides much more facilities, some of which will be discussed here.

The best places to start learning about Julia are:
- the reference website: https://julialang.org/;
- the official manual: https://docs.julialang.org/en/v1/;
- the community blog: https://discourse.julialang.org/;

## Installing Julia and first run
Go to https://julialang.org/downloads/ and download the appropriate package.  Avoid installing versions prior to 1.0.

On Linux and OSX there is no need to install anything:
- *untar* the package wherever you want;
- add the `bin` directory to your `PATH` environment variable;
- type `julia` on a terminal and you're ready to go.
- alternatively open a terminal and type:
```
/the/complete/path/to/julia/bin/julia
```

On Windows run the installation program.

Your first contact with Julia will be through the [REPL](https://docs.julialang.org/en/v1/stdlib/REPL/#The-Julia-REPL-1) (Read-Eval-Print Loop), e.g.:
![repl](resources/repl.png)

It is similar to a terminal and provides TAB completion, the typical Emacs-like shortcuts (Ctrl-a, Ctrl-e, Alt-b, Alt-f, Alt-l, Alt-c, etc.) as well as the common history search commands (Ctrl-s, Ctrl-r).

To be clear: TAB completion is that magical feature which allows you to type just a part of a function name, and have it Julia complete it for you by pressing the TAB key (provided the abbreviation is unique).

Try the following command:
```julia
julia> println("Hello world!")
```
that's it: you ran your first Julia program!

To check the online help for the `println` function you just used, type `?` (question mark), the prompt will turn yellow, then type `println` and enter.  The same applies to all other functions.

From within Julia you can also issue shell commands (only on Linux and OSX): simply type `;`, the prompt will turn red, type `ls` (or any other shell command) and enter.

Another *magic* key is `]`: it allows you to enter the builtin [package manager](https://julialang.org/blog/2018/09/Pkgtutorial).

In any of these modes simply hit the *backspace* key to go back to the Julia prompt.

To quit your Julia session simply hit `Ctrl-d`.


## Is Julia really fast?
Try youself with the following code snippets calculating the sum of the square root of the first 500,000,000 integer numbers:

### C
Type the following code in a file named `ex1.c`:
```C
#include <stdio.h>
#include <math.h>

double ex1(long int n) {
	long int i;
	double sum = 0.;
	for (i=1; i<=n; i++)
		sum += sqrt(i);
	return sum;
}

int main() {
	printf("%f\n", ex1(500000000));
}
```

Compile and run with:
```
gcc -O3 -o ex1 ex1.c -lm
time ./ex1
```

### Python

Explicit loop:
```python
import math
import time

def ex1(n):
    sum = 0.
    for i in range(1,n):
        sum += math.sqrt(i)
    return sum

elapsed = time.time()
print(ex1(500000000))
elapsed = time.time() - elapsed
print("Elapsed time: ", elapsed)
```

With Numpy:
```python
import numpy as np
import math
import time

def ex2(n):
    a = np.arange(n)+1
    a = np.sqrt(a)
    return np.sum(a)

elapsed = time.time()
print(ex2(500000000))
elapsed = time.time() - elapsed
print("Elapsed time: ", elapsed)
```

With Numba:
```python
from numba import jit
import math
import time

@jit
def ex3(n):
    sum = 0.
    for i in range(1,n):
        sum += math.sqrt(i)
    return sum

elapsed = time.time()
print(ex3(500000000))
elapsed = time.time() - elapsed
print("Elapsed time: ", elapsed)
```

### IDL

Explicit loop:
```idl
.r
FUNCTION ex1, n
  sum = 0.d
  FOR i=1l, n DO $
     sum += SQRT(i)
  RETURN, sum
END

elapsed = SYSTIME(1)
PRINT, ex1(500000000)
elapsed = SYSTIME(1) - elapsed
PRINT, 'Elapsed: ', elapsed
```

Implicit loop:
```idl
.r
FUNCTION ex2, n
  RETURN, TOTAL(SQRT(DOUBLE(LINDGEN(n)+1)))
END

elapsed = SYSTIME(1)
PRINT, ex2(500000000)
elapsed = SYSTIME(1) - elapsed
PRINT, 'Elapsed: ', elapsed
```


### Julia

Explicit loop:
```julia
function ex1(n)
    sum = 0.
    for i in 1:n
        sum += sqrt(i)
    end
    return sum
end

println(ex1(2))  # warm up
@time println(ex1(500_000_000))
```

Implicit loop:
```julia
function ex2(n)
    return sum(sqrt, 1:n)
end

println(ex2(2))  # warm up
@time println(ex2(500_000_000))
```

Parallel processing (start julia with: `julia -p 4`):
```julia
using Distributed
function ex3(n)
    return @distributed (+) for i = 1:n
        sqrt(float(i))
    end
end

if myid() == 1
	println(ex3(2))  # warm up
    @time println(ex3(500_000_000))
end
```

Multithreading (start julia with: `JULIA_NUM_THREADS=4 julia`):
```julia
using Base.Threads
function ex4(n)
    arr = fill(0., nthreads())
    @threads for i = 1:n
        arr[threadid()] += sqrt(float(i))
    end
    return sum(arr)
end

println(ex4(2))
@time println(ex4(500_000_000))
```

## My first plot
To produce your first plot in Julia you should install one or more [plotting packages](https://juliaobserver.com/categories/Infographics) (see **Packages** section below).  My best choice is the [Gnuplot.jl](https://github.com/gcalderone/Gnuplot.jl/) package.

To install `Gnuplot.jl` you need to have a working [Gnuplot](http://gnuplot.info/) installation.  Then you can start julia, type the `]` character (start the package manager) and type:
```julia
dev https://github.com/gcalderone/ReusePatterns.jl
dev https://github.com/gcalderone/Gnuplot.jl
```
(the above procedure will be simplified in the coming days...).

Now you're ready for your first plot:
```julia
julia> using Gnuplot
julia> @gp 1:10
```

A slightly more interesting example:
```julia
julia> X = -3:0.1:3
julia> @gsp X X reshape([exp.(-x.^2 -y.^2) for x in X for y in X], length(X), length(X)) "w pm3d"
julia> save(term="png", output="MyFirstPlot.png")
```
![MyFirstPlot](resources/MyFirstPlot.png)

Have a look at [Gnuplot.jl](https://github.com/gcalderone/Gnuplot.jl/) documentation for further examples.


## Packages

With the core Julia language you can only do slightly more than arithmetics, basic statistics, and simple input/outputs on files.  New functionalities must be added to Julia with custom **packages**.

The most trending packages are listed [here](https://github.com/trending/julia), while the complete list is available [here](https://juliaobserver.com/packages).  Be aware that many of the packages are not maintained since the Julia language evolved rather quickly in the last few years introducing important breaking changes.  Since August 2018 versin 1.0 is released, and there shouldn't be any other breaking change in the future, hence the package ecosystem will soon settle on its long term state.

(NOTE: Julia package usually have the `.jl` suffix).
