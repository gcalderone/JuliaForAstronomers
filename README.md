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

It is similar to a terminal, and provides all typical Emacs-like shortcuts as well as the common history search commands (Ctrl-s, Ctrl-r).

Type the following command:
```julia
julia> println("Hello world!")
```
that's it: you ran your first Julia program!

To check the online help for the `println` function you just used, type `?` (question mark), the prompt will turn yellow, then type `println` and enter.  The same applies to all other functions.

From within Julia you can also issue shell commands (only on Linux and OSX): simply type `;`, the prompt will turn red, type `ls` (or any other shell command) and enter.

Another *magic* key is `]`: it allows you to enter the builtin [package manager](https://julialang.org/blog/2018/09/Pkgtutorial).

In any of these modes simply hit the *backspace* key to go back to the Julia prompt.

To quit your Julia session simply hit `Ctrl-d`.
