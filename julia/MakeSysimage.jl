#Requires recent version of Julia, possibly compiled from source

#This script creates a Sysimage, essentially a snapshot of a Julia runtime 
#environment where NLsolve has already been compiled.
#This Sysimage, which must be created on a local machine, can be passed as
#part of a --sysimage flag. For example:
# julia --sysimage "NLsolveSysimage.so" NLsolvemodel.jl
#Compiling NLsolve usually takes around 8 seconds, which is bothersome for
#repeated execution of a single Julia script using NLsolve, but
#unacceptable for testing such a script.

#Note that making the Sysimage may take a few minutes

using Pkg
Pkg.add("PackageCompiler")
Pkg.add("NLsolve")

using PackageCompiler
using NLsolve

create_sysimage([:NLsolve], sysimage_path="./SysimageEnvironments/NLsolveSysimage.so")