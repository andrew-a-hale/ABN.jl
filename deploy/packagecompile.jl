using Pkg
Pkg.instantiate()

using PackageCompiler

create_sysimage(:ABN;
    sysimage_path="ABN.so",
    precompile_execution_file="deploy/precompile.jl")