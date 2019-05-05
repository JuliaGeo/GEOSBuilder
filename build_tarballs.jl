using BinaryBuilder

src_version = v"3.7.2"  # also change in raw script string below

# Collection of sources required to build GEOS
sources = [
    "http://download.osgeo.org/geos/geos-$src_version.tar.bz2" =>
    "2166e65be6d612317115bfec07827c11b403c3f303e0a7420a2106bc999d7707",
]

# Bash recipe for building across all platforms
script = raw"""
# use GCC ar instead of the LLVM one on OSX,
# see https://github.com/JuliaPackaging/BinaryBuilder.jl/issues/388
if [[ ${target} == *darwin* ]]; then
    export AR=/opt/${target}/bin/${target}-ar
fi

cd $WORKSPACE/srcdir
cd geos-3.7.2/
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()
platforms = expand_gcc_versions(platforms)

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libgeos_c", :libgeos),
    LibraryProduct(prefix, "libgeos", :libgeos_cpp)
]

# Dependencies that must be installed before this package can be built
dependencies = []

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "GEOS", src_version, sources, script, platforms, products, dependencies)
