using BinaryBuilder

# Collection of sources required to build GEOS
sources = [
    "http://download.osgeo.org/geos/geos-3.6.2.tar.bz2" =>
    "045a13df84d605a866602f6020fc6cbf8bf4c42fb50de237a08926e1d7d7652a",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd geos-3.6.2/
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:i686, :glibc),
    BinaryProvider.Linux(:x86_64, :glibc),
    BinaryProvider.Linux(:aarch64, :glibc),
    BinaryProvider.Linux(:armv7l, :glibc),
    BinaryProvider.Linux(:powerpc64le, :glibc),
    BinaryProvider.MacOS(),
    BinaryProvider.Windows(:i686),
    BinaryProvider.Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libgeos_c", :libgeos_c),
    LibraryProduct(prefix, "libgeos", :libgeos)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "GEOS", sources, script, platforms, products, dependencies)

