#!/bin/sh

set -e

[ -n "$BASH_VERSION" ] && set -o posix

BUILD_ROOT=${BUILD_ROOT:-$HOME/vbam-build}
TAR=${TAR:-tar --force-local}
PERL_MAKE=${PERL_MAKE:-make}

[ -n "$BUILD_ENV" ] && eval "$BUILD_ENV"

BUILD_ENV=$BUILD_ENV$(cat <<EOF
export BUILD_ROOT="$BUILD_ROOT"

export CC="\${CC:-gcc}"
export CXX="\${CXX:-g++}"

if [ -z "\$CCACHE" ] && command -v ccache >/dev/null; then
    export CC="ccache \$CC"
    export CXX="ccache \$CXX"
    export CCACHE=1
fi

export CFLAGS="\$CFLAGS -fPIC -I$BUILD_ROOT/root/include -L$BUILD_ROOT/root/lib -Wno-error=all"
export CPPFLAGS="\$CPPFLAGS -I$BUILD_ROOT/root/include -Wno-error=all"
export CXXFLAGS="\$CXXFLAGS -fPIC -I$BUILD_ROOT/root/include -L$BUILD_ROOT/root/lib -std=gnu++11 -Wno-error=all"
export OBJCXXFLAGS="\$OBJCXXFLAGS -fPIC -I$BUILD_ROOT/root/include -L$BUILD_ROOT/root/lib -std=gnu++11 -Wno-error=all"
export LDFLAGS="\$LDFLAGS -fPIC -L$BUILD_ROOT/root/lib -Wno-error=all"
export CMAKE_PREFIX_PATH="\${CMAKE_PREFIX_PATH:-$BUILD_ROOT/root}"
export PKG_CONFIG_PATH="$BUILD_ROOT/root/lib/pkgconfig"

export PERL_MM_USE_DEFAULT=1
export PERL_EXTUTILS_AUTOINSTALL="--defaultdeps"

export OPENSSL_ROOT="$BUILD_ROOT/root"

if command -v cygpath >/dev/null; then
    export PERL_MB_OPT="--install_base \$(cygpath -u "$BUILD_ROOT/root/perl5")"
    export PERL_MM_OPT="INSTALL_BASE=\$(cygpath -u "$BUILD_ROOT/root/perl5")"
    export PERL5LIB="\$(cygpath -u "$BUILD_ROOT/root/perl5/lib/perl5")"
    export PERL_LOCAL_LIB_ROOT="\$(cygpath -u "$BUILD_ROOT/root/perl5")"

    export PATH="\$(cygpath -u "$BUILD_ROOT/root/bin"):\$(cygpath -u "$BUILD_ROOT/root/perl5/bin"):\$PATH"
else
    export PERL_MB_OPT='--install_base $BUILD_ROOT/root/perl5'
    export PERL_MM_OPT='INSTALL_BASE=$BUILD_ROOT/root/perl5'
    export PERL5LIB="$BUILD_ROOT/root/perl5/lib/perl5"
    export PERL_LOCAL_LIB_ROOT="$BUILD_ROOT/root/perl5"

    export PATH="$BUILD_ROOT/root/bin:$BUILD_ROOT/root/perl5/bin:\$PATH"
fi

export PERL_MM_OPT="\$PERL_MM_OPT CCFLAGS='\$CFLAGS' LDDFLAGS='\$LDFLAGS'"

export XML_CATALOG_FILES="$BUILD_ROOT/root/etc/xml/catalog.xml"

export XDG_DATA_DIRS="$BUILD_ROOT/root/share"

export FONTCONFIG_PATH="$BUILD_ROOT/etc/fonts"
EOF
)

ORIG_PATH=$PATH

eval "$BUILD_ENV"

PRE_BUILD_DISTS="$PRE_BUILD_DISTS bzip2 xz unzip"

DISTS=$DISTS'
    bzip2           http://bzip.org/1.0.6/bzip2-1.0.6.tar.gz                                                    lib/libbz2.a
    xz              https://tukaani.org/xz/xz-5.2.3.tar.gz                                                      lib/liblzma.a
    unzip           https://downloads.sourceforge.net/project/infozip/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz     bin/unzip
    openssl         https://www.openssl.org/source/openssl-1.0.2l.tar.gz                                        lib/libssl.a
    cmake           https://cmake.org/files/v3.10/cmake-3.10.0-rc3.tar.gz                                       bin/cmake
    zlib            https://zlib.net/zlib-1.2.11.tar.gz                                                         lib/libz.a
    autoconf        https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz                                       bin/autoconf
    autoconf-archive http://mirror.team-cymru.org/gnu/autoconf-archive/autoconf-archive-2017.09.28.tar.xz       share/aclocal/ax_check_gl.m4
    automake        https://ftp.gnu.org/gnu/automake/automake-1.15.1.tar.xz                                     bin/automake
    help2man        https://ftp.gnu.org/gnu/help2man/help2man-1.47.5.tar.xz                                     bin/help2man
    flex            https://github.com/westes/flex/files/981163/flex-2.6.4.tar.gz                               bin/flex
    bison           https://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.xz                                            bin/bison
    xmlto           https://releases.pagure.org/xmlto/xmlto-0.0.28.tar.bz2                                      bin/xmlto
    libtool         https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz                                        bin/libtool
    gperf           http://ftp.gnu.org/pub/gnu/gperf/gperf-3.1.tar.gz                                           bin/gperf
    pkgconfig       https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz                         bin/pkg-config
    nasm            http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.xz                       bin/nasm
    yasm            http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz                             bin/yasm
    pcre            https://ftp.pcre.org/pub/pcre/pcre-8.41.tar.bz2                                             lib/libpcre.a
    libffi          ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz                                         lib/libffi.a
    libiconv        https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz                                   lib/libiconv.a
    gettext         http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.8.1.tar.xz                                  lib/libintl.a
    c2man           http://www.ciselant.de/c2man/c2man-2.0@42.tar.gz                                            bin/c2man
    doxygen         http://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.13.src.tar.gz                             bin/doxygen
    libxml2         ftp://xmlsoft.org/libxml2/libxml2-2.9.6.tar.gz                                              lib/libxml2.a
    libxslt         https://git.gnome.org/browse/libxslt/snapshot/libxslt-1.1.32-rc1.tar.xz                     lib/libxslt.a
    XML-NamespaceSupport https://cpan.metacpan.org/authors/id/P/PE/PERIGRIN/XML-NamespaceSupport-1.12.tar.gz    perl5/lib/perl5/XML/NamespaceSupport.pm
    XML-SAX-Base    https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-Base-1.09.tar.gz                   perl5/lib/perl5/XML/SAX/Base.pm
    XML-SAX         https://cpan.metacpan.org/authors/id/G/GR/GRANTM/XML-SAX-0.99.tar.gz                        perl5/lib/perl5/XML/SAX.pm
    docbook2x       https://downloads.sourceforge.net/project/docbook2x/docbook2x/0.8.8/docbook2X-0.8.8.tar.gz  bin/docbook2man
    expat           https://github.com/libexpat/libexpat/archive/R_2_2_4.tar.gz                                 lib/libexpat.a
    freetype        http://download.savannah.gnu.org/releases/freetype/freetype-2.8.tar.bz2                     lib/libfreetype.a
    fontconfig      https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.6.tar.bz2           lib/libfontconfig.a
    libpng          https://download.sourceforge.net/libpng/libpng-1.6.32.tar.xz                                lib/libpng.a
    libjpeg-turbo   https://github.com/libjpeg-turbo/libjpeg-turbo/archive/1.5.2.tar.gz                         lib/libjpeg.a
    libtiff         http://download.osgeo.org/libtiff/tiff-4.0.9.tar.gz                                         lib/libtiff.a
    libgd           https://github.com/libgd/libgd/releases/download/gd-2.2.4/libgd-2.2.4.tar.xz                lib/libgd.a
    dejavu          https://downloads.sourceforge.net/project/dejavu/dejavu/2.37/dejavu-fonts-ttf-2.37.tar.bz2  share/fonts/dejavu/DejaVuSansMono.ttf
    liberation      https://releases.pagure.org/liberation-fonts/liberation-fonts-ttf-2.00.1.tar.gz             share/fonts/liberation/LiberationMono-Regular.ttf
    graphviz        https://graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.40.1.tar.gz                     bin/dot_static
    docbook4.2      http://www.docbook.org/xml/4.2/docbook-xml-4.2.zip                                                    share/xml/docbook/schema/dtd/4.2/catalog.xml
    docbook4.1.2    http://www.docbook.org/xml/4.1.2/docbkx412.zip                                                        share/xml/docbook/schema/dtd/4.1.2/catalog.xml
    docbook4.3      http://www.docbook.org/xml/4.3/docbook-xml-4.3.zip                                                    share/xml/docbook/schema/dtd/4.3/catalog.xml
    docbook4.4      http://www.docbook.org/xml/4.4/docbook-xml-4.4.zip                                                    share/xml/docbook/schema/dtd/4.4/catalog.xml
    docbook4.5      http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip                                                    share/xml/docbook/schema/dtd/4.5/catalog.xml
    docbook5.0      http://www.docbook.org/xml/5.0/docbook-5.0.zip                                                        share/xml/docbook/schema/dtd/5.0/catalog.xml
    docbook-xsl     https://downloads.sourceforge.net/project/docbook/docbook-xsl/1.79.1/docbook-xsl-1.79.1.tar.bz2       share/xml/docbook/stylesheet/docbook-xsl/catalog.xml
    docbook-xsl-ns  https://downloads.sourceforge.net/project/docbook/docbook-xsl-ns/1.79.1/docbook-xsl-ns-1.79.1.tar.bz2 share/xml/docbook/stylesheet/docbook-xsl-ns/catalog.xml
    python2         https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tar.xz                               bin/python
    python3         https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tar.xz                                 bin/python3
    setuptools      https://pypi.python.org/packages/0f/22/7fdcc777ba60e2a8b1ea17f679c2652ffe80bd5a2f35d61c629cb9545d5e/setuptools-36.7.2.zip   bin/easy_install
    pip             https://pypi.python.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz        bin/pip3
    ninja           https://github.com/ninja-build/ninja/archive/v1.8.2.tar.gz                                  bin/ninja
    meson           https://github.com/mesonbuild/meson/releases/download/0.43.0/meson-0.43.0.tar.gz            bin/meson
    glib            http://mirror.umd.edu/gnome/sources/glib/2.55/glib-2.55.0.tar.xz                            lib/libglib-2.0.a
    sdl2            https://www.libsdl.org/release/SDL2-2.0.7.tar.gz                                            lib/libSDL2.a
    flac            https://ftp.osuosl.org/pub/xiph/releases/flac/flac-1.3.2.tar.xz                             lib/libFLAC.a
    libogg          http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.xz                                  lib/libogg.a
    libvorbis       https://github.com/xiph/vorbis/archive/v1.3.5.tar.gz                                        lib/libvorbis.a
    harfbuzz        https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.6.0.tar.bz2                lib/libharfbuzz.a
    XML-Parser      https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz                      perl5/man/man3/XML::Parser.3pm
    intltool        https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz                bin/intltoolize
    sfml            https://github.com/SFML/SFML/archive/013d053277c980946bc7761a2a088f1cbb788f8c.tar.gz        lib/libsfml-system-s.a
    shared-mime-info http://freedesktop.org/~hadess/shared-mime-info-1.9.tar.xz                                 bin/update-mime-database
    wxwidgets       https://github.com/wxWidgets/wxWidgets/archive/ba58172987ea991e5e759c7e36ed7ec685aa8310.tar.gz                              lib/libwx_baseu-3.0.a
    graphite2       https://github.com/silnrsi/graphite/releases/download/1.3.10/graphite2-1.3.10.tgz           lib/libgraphite2.a
    xvidcore        http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.bz2                                  lib/libxvidcore.a
    fribidi         https://github.com/fribidi/fribidi/archive/0.19.7.tar.gz                                    lib/libfribidi.a
    libgsm          http://www.quut.com/gsm/gsm-1.0.17.tar.gz                                                   lib/libgsm.a
    libmodplug      https://github.com/Konstanty/libmodplug/archive/5a39f5913d07ba3e61d8d5afdba00b70165da81d.tar.gz lib/libmodplug.a
    libopencore-amrnb https://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.5.tar.gz lib/libopencore-amrnb.a
    opus            https://archive.mozilla.org/pub/opus/opus-1.2.1.tar.gz                                      lib/libopus.a
    snappy          https://github.com/google/snappy/archive/1.1.7.tar.gz                                       lib/libsnappy.a
    libsoxr         https://downloads.sourceforge.net/project/soxr/soxr-0.1.2-Source.tar.xz                     lib/libsoxr.a
    speex           http://downloads.us.xiph.org/releases/speex/speex-1.2.0.tar.gz                              lib/libspeex.a
    libtheora       https://github.com/Distrotech/libtheora/archive/17b02c8c564475bb812e540b551219fc42b1f75f.tar.gz lib/libtheora.a
    vidstab         https://github.com/georgmartius/vid.stab/archive/v1.1.0.tar.gz                              lib/libvidstab.a
    libvo-amrwbenc  https://github.com/mstorsjo/vo-amrwbenc/archive/v0.1.3.tar.gz                               lib/libvo-amrwbenc.a
    mp3lame         https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz                 lib/libmp3lame.a
    libass          https://github.com/libass/libass/releases/download/0.13.7/libass-0.13.7.tar.xz              lib/libass.a
    libbluray       ftp://ftp.videolan.org/pub/videolan/libbluray/1.0.0/libbluray-1.0.0.tar.bz2                 lib/libbluray.a
    libvpx          http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.6.1.tar.bz2  lib/libvpx.a
    libwavpack      http://www.wavpack.com/wavpack-5.1.0.tar.bz2                                                lib/libwavpack.a
    libx264         ftp://ftp.videolan.org/pub/videolan/x264/snapshots/last_stable_x264.tar.bz2                 lib/libx264.a
    libx265         https://bitbucket.org/multicoreware/x265/downloads/x265_2.5.tar.gz                          lib/libx265.a
    libxavs         https://github.com/Distrotech/xavs/archive/distrotech-xavs-git.tar.gz                       lib/libxavs.a
    libzmq          https://github.com/zeromq/libzmq/releases/download/v4.2.2/zeromq-4.2.2.tar.gz               lib/libzmq.a
#    libzvbi         https://downloads.sourceforge.net/project/zapping/zvbi/0.2.35/zvbi-0.2.35.tar.bz2           lib/libzvbi.a
    ffmpeg          http://ffmpeg.org/releases/ffmpeg-3.3.4.tar.xz                                              lib/libavformat.a
'

CONFIGURE_ARGS="$CONFIGURE_ARGS --disable-shared --enable-static --prefix=\$BUILD_ROOT/root"

CMAKE_BASE_ARGS="$CMAKE_BASE_ARGS -DBUILD_SHARED_LIBS=NO -DENABLE_SHARED=NO -DCMAKE_PREFIX_PATH=\"\$CMAKE_PREFIX_PATH\" -DCMAKE_BUILD_TYPE=Release"

CMAKE_ARGS="$CMAKE_BASE_ARGS $CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=\$BUILD_ROOT/root"

MESON_ARGS="--prefix '$BUILD_ROOT/root' --buildtype release --default-library static -Dintrospection=false"

DIST_PATCHES=$DIST_PATCHES'
    docbook2x       https://sourceforge.net/p/docbook2x/bugs/_discuss/thread/0cfa4055/f6a5/attachment/docbook2x.patch
    graphite2       https://gist.githubusercontent.com/rkitover/418600634d7cf19e2bf1c3708b50c042/raw/839b72d9cda545f2e3b640d743c1bd44b89861b9/graphite2-1.3.10-static.patch
    python2         https://gist.githubusercontent.com/rkitover/2d9e5baff1f1cc4f2618dee53083bd35/raw/7f33fcf5470a9f1013ac6ae7bb168368a98fe5a0/python-2.7.14-custom-static-openssl.patch https://gist.githubusercontent.com/rkitover/afab7ed3ac7ce1860c43a258571c8ae1/raw/6f5fc90a7acf5f5c3ffda2edf402b28f469a4b3b/python-2.7.14-static-libintl.patch
    python3         https://gist.githubusercontent.com/rkitover/93d89a679705875c59275fb0a8f22b45/raw/6149e7fa3920d6c674c79448c5a4c9313620e06c/python-3.6.3-custom-static-openssl.patch https://gist.githubusercontent.com/rkitover/b18f19eafda3775a9652cc9cdf3ec914/raw/ed14c34bf9f205ccc3a4684dbdb83f8620162b98/python-3.6.3-static-libintl.patch
    intltool        https://gist.githubusercontent.com/rkitover/d638882f52e5d5f8e392cbf6842cd6d0/raw/dcfbe358bbb8b89f88b40a9c3402494552fd33f8/intltool-0.51.0.patch
'

DIST_TAR_ARGS="$DIST_TAR_ARGS
"

DIST_PRE_BUILD="$DIST_PRE_BUILD
    openssl         ln -sf ./Configure ./configure || :;
    python2         rm -f configure;
    python3         rm -f configure;
    pkgconfig       (cd '$BUILD_ROOT/dists/libiconv'; make uninstall >/dev/null 2>&1 || :);
    unzip           rm -f unix/Contents; ln -sf \$(find unix -mindepth 1 -maxdepth 1) .;
    expat           cd expat; \
                    sed -i.bak 's/cp \\\$</mv \$</' doc/doc.mk;
    fribidi         rm -f configure; echo > git.mk;
    xvidcore        cd build/generic; \
                    sed -i.bak '/^all:/{ s/ *\\\$(SHARED_LIB)//; }; \
                                /^install:/{ s, *\\\$(BUILD_DIR)/\\\$(SHARED_LIB),,; }; \
                                s/\\\$(INSTALL).*\\\$(SHARED_LIB).*/:/; \
                                s/\\\$(LN_S).*\\\$(SHARED_LIB).*/:/; \
                                s/@echo.*\\\$(SHARED_LIB).*/@:/; \
                    ' Makefile;
    libx265         cd source;
    XML-SAX         sed -i.bak 's/-MXML::SAX/-Mblib -MXML::SAX/' Makefile.PL
    docbook2x       if [ -f ./configure ]; then mv configure configure.bak; fi; \
                    sed -i.bak 's/^\\( *SUBDIRS *= *.*\\)doc\\(.*\\)\$/\1\2/'           Makefile.am; \
                    sed -i.bak 's/^\\( *SUBDIRS *= *.*\\)documentation\\(.*\\)\$/\1\2/' xslt/Makefile.am;
"

DIST_POST_BUILD="$DIST_POST_BUILD
    harfbuzz        build_dist freetype --with-harfbuzz=yes;
    graphviz        (cd '$BUILD_ROOT/root/bin'; [ -f dot_static -a ! -e dot ] && ln -sf '$BUILD_ROOT/root/bin/dot_static' ./dot || :)
    libxml2         mkdir -p '$BUILD_ROOT/root/etc/xml'; \
                    xmlcatalog --noout --create '$BUILD_ROOT/root/etc/xml/catalog.xml' || :;
    python2         pip2 install six;
    python3         pip3 install six;
"

DIST_POST_CONFIGURE="$DIST_POST_CONFIGURE
"

DIST_CONFIGURE_OVERRIDES="$DIST_CONFIGURE_OVERRIDES
    openssl     ./config no-shared --prefix='$BUILD_ROOT/root'
    unzip       ./configure
    cmake       ./configure --prefix=\$BUILD_ROOT/root --no-qt-gui
    c2man       ./Configure -de -Dprefix='$BUILD_ROOT/root' && make -j$NUM_CPUS && make install
    zlib        ./configure --static --prefix=\$BUILD_ROOT/root
    XML-SAX     echo no | PERL_MM_USE_DEFAULT=0 perl Makefile.PL
    setuptools  python bootstrap.py; python easy_install.py .
    pip         easy_install .
    ninja       python configure.py --bootstrap && cp -af ./ninja '$BUILD_ROOT/root/bin'
    docbook4.2     install_docbook_dist schema
    docbook4.1.2   cp '$BUILD_ROOT/dists/docbook4.2/catalog.xml' . ; \
                   sed -i.bak 's/V4.2/V4.1.2/g; s/4.2/4.1.2/g;' catalog.xml; \
                   install_docbook_dist schema
    docbook4.3     install_docbook_dist schema
    docbook4.4     install_docbook_dist schema
    docbook4.5     install_docbook_dist schema
    docbook5.0     install_docbook_dist schema
    docbook-xsl    install_docbook_dist stylesheet
    docbook-xsl-ns install_docbook_dist stylesheet
    dejavu         install_fonts
    liberation     install_fonts
    wxwidgets   ./configure --disable-shared --prefix='$BUILD_ROOT'/root --enable-stl --disable-precomp-headers --enable-cxx11 --enable-permissive
"

DIST_ARGS="$DIST_ARGS
    gettext     --with-included-gettext --with-included-glib --with-included-libcroco --with-included-libunistring --with-included-libxml CPPFLAGS=\"\$CPPFLAGS -DLIBXML_STATIC\"
    pkgconfig   --with-internal-glib
    glib        --with-libiconv
    pcre        --enable-utf8 --enable-pcre8 --enable-pcre16 --enable-pcre32 --enable-unicode-properties --enable-pcregrep-libz --enable-pcregrep-libbz2 --enable-jit
    doxygen     -DICONV_LIBRARY='-lintl -liconv'
    python2     --with-ensurepip --with-system-expat
    python3     --with-ensurepip --with-system-expat
    XML-Parser  EXPATINCPATH='$BUILD_ROOT/root/include' EXPATLIBPATH='$BUILD_ROOT/root/lib'
    sfml        -DSFML_USE_SYSTEM_DEPS=TRUE
    freetype    --with-harfbuzz=no
    harfbuzz    --with-cairo=no
    libvpx      --disable-unit-tests --disable-tools --disable-docs --disable-examples
    libxavs     --disable-asm
    libzvbi     --without-x --without-doxygen
    libxml2     --without-python
    libbluray   --disable-bdjava
    libopencore-amrnb   --disable-compile-c
    vidstab     -DUSE_OMP=NO
    libx265     -DHIGH_BIT_DEPTH=ON -DENABLE_ASSEMBLY=OFF -DENABLE_CLI=OFF
    ffmpeg      --pkg-config-flags=--static --enable-nonfree --extra-version=tessus --enable-avisynth --enable-fontconfig --enable-gpl --enable-version3 --enable-libass --enable-libbluray --enable-libfreetype --enable-libgsm --enable-libmodplug --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopus --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libtheora --enable-libvidstab --enable-libvo-amrwbenc --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libx264 --enable-libx265 --enable-libxavs --enable-libxvid --enable-libzmq --enable-openssl --enable-lzma --extra-cflags='-DMODPLUG_STATIC -DZMQ_STATIC'
#
# TODO: add these if possible (from brew) --enable-indev=qtkit --enable-securetransport --enable-chromaprint --enable-ffplay --enable-frei0r --enable-libbs2b --enable-libcaca --enable-libfdk-aac --enable-libgme --enable-libgsm --enable-librtmp --enable-librubberband --enable-libssh --enable-libtesseract --enable-libtwolame --enable-webp --enable-libzimg
#
# Possibly also: --enable-libzvbi
#   I could not get libzvbi to build
#
# these require > 10.7:
#   --enable-opencl       # requires 10.8
#   --enable-videotoolbox # requires 10.8
"

DIST_BARE_MAKE_INSTALL_ARGS='prefix="$BUILD_ROOT/root" PREFIX="$BUILD_ROOT/root" INSTALL_ROOT="$BUILD_ROOT/root"'

DIST_BARE_MAKE_ARGS=

DIST_MAKE_ARGS="$DIST_MAKE_ARGS
    bzip2       CFLAGS='$CFLAGS' LDFLAGS='$LDFLAGS'
    openssl     CC='$CC -fPIC'
    unzip       generic2
    expat       DOCBOOK_TO_MAN=docbook2man
    shared-mime-info    -j1
    fribidi     -j1
    libx264     AS='yasm -DPIC'
"

DIST_MAKE_INSTALL_ARGS="$DIST_MAKE_INSTALL_ARGS
"

DIST_EXTRA_LDFLAGS="$DIST_EXTRA_LDFLAGS
"

DIST_EXTRA_LIBS="$DIST_EXTRA_LIBS
    shared-mime-info    -Wl,--start-group -lxml2 -lgio-2.0 -lgmodule-2.0 -lgobject-2.0 -lglib-2.0 -lpcre -llzma -lz -lm -lffi -lpthread -liconv -lresolv -ldl -lmount -lblkid -luuid -Wl,--end-group
"

NL="
"

builder() {
    setup
    read_command_line "$@"
    install_core_deps
    setup_perl
    delete_outdated_dists
    build_prerequisites
    download_dists
    build_dists
    build_project
}

read_command_line() {
    case "$1" in
        --env)
            puts "$BUILD_ENV"
            exit 0
            ;;
    esac
}

setup() {
    detect_os

    mkdir -p "$BUILD_ROOT/root/include"
    [ -L "$BUILD_ROOT/root/inc" ] || ln -s "$BUILD_ROOT/root/include" "$BUILD_ROOT/root/inc"

    mkdir -p "$BUILD_ROOT/root/lib"
    libarch="lib$bits"
    [ -L "$BUILD_ROOT/root/$libarch" ] || ln -s "$BUILD_ROOT/root/lib" "$BUILD_ROOT/root/$libarch"

    [ -n "$target_platform" ] && [ -L "$BUILD_ROOT/root/lib/$target_platform" ] || ln -s '.' "$BUILD_ROOT/root/lib/$target_platform"

    DIST_NAMES=$(  table_column DISTS 0 3)
    DIST_URLS=$(   table_column DISTS 1 3)
    DIST_TARGETS=$(table_column DISTS 2 3)

    DISTS_NUM=$(table_rows DISTS)

    NUM_CPUS=$(num_cpus)

    BUILD_ENV="$BUILD_ENV
export MAKEFLAGS=-j$NUM_CPUS
"
    eval "$BUILD_ENV"

    CHECKOUT=$(find_checkout)

    TMP_DIR=${TMP_DIR:-/tmp/builder-$$}

    setup_tmp_dir

    UNPACK_DIR="$TMP_DIR/unpack"
    mkdir "$UNPACK_DIR"

    DISTS_DIR="$BUILD_ROOT/dists"
    mkdir -p "$DISTS_DIR"
}

num_cpus() {
    if command -v nproc >/dev/null; then
        nproc
        return $?
    fi

    if [ -f /proc/cpuinfo ]; then
        set -- $(grep '^processor		*:' /proc/cpuinfo | wc -l)
        puts $1
        return 0
    fi

    if command -v sysctl >/dev/null; then
        sysctl -n hw.ncpu
        return 0
    fi

    warn 'cannot determine number of CPU threads, using a default of [1;31m2[0m'

    puts 2
}

setup_perl() {
    setup_cpan

    perl -MApp::cpanminus -le 1 2>/dev/null || cpan App::cpanminus
}

setup_cpan() {
    mkdir -p "$BUILD_ROOT"/root/perl5/lib/perl5/CPAN

    cpan -J 2>/dev/null >"$BUILD_ROOT"/root/perl5/lib/perl5/CPAN/Config.pm

    sed -i.bak 's;\('\''makepl_arg'\'' .*\)'\'', *$;\1 CCFLAGS="'"$CFLAGS"'" LDDFLAGS="'"$LDFLAGS"'"'\'',;' "$BUILD_ROOT"/root/perl5/lib/perl5/CPAN/Config.pm

    # if the user has a ~/.cpan/CPAN/MyConfig.pm, it will override this file, that's why we set PERL_MM_OPT in BUILD_ENV
}

clear_build_env() {
    for var in CC CXX CCACHE CFLAGS CPPFLAGS CXXFLAGS OBJCXXFLAGS LDFLAGS CMAKE_PREFIX_PATH PKG_CONFIG_PATH PERL_MM_USE_DEFAULT PERL_EXTUTILS_AUTOINSTALL OPENSSL_ROOT PERL_MB_OPT PERL_MM_OPT PERL5LIB PERL_LOCAL_LIB_ROOT; do
        unset $var
    done
    export PATH="$ORIG_PATH"
}

set_build_env() {
    eval "$BUILD_ENV"
}

install_core_deps() {
    ${os}_install_core_deps

    # things like ccache may have been installed, re-eval build env
    eval "$BUILD_ENV"
}

installing_core_deps() {
    puts "${NL}[32mInstalling core dependencies for your OS...[0m${NL}${NL}"
}

done_msg() {
    puts "${NL}[32mDone!!![0m${NL}${NL}"
}

unknown_install_core_deps() {
    :
}

linux_install_core_deps() {
    # detect host architecture
    case "$(uname -a)" in
        *x86_64*)
            amd64=1
            ;;
        *i686*)
            i686=1
            ;;
    esac

    if [ -f /etc/debian_version ]; then
        debian_install_core_deps
    elif [ -f /etc/fedora-release ]; then
        fedora_install_core_deps
    elif [ -f /etc/arch-release ]; then
        archlinux_install_core_deps
    elif [ -f /etc/solus-release ]; then
        solus_install_core_deps
    fi
}

debian_install_core_deps() {
    installing_core_deps

    sudo apt-get -qq update || :
    sudo apt-get -qy install build-essential g++ curl

    done_msg
}

fedora_install_core_deps() {
    installing_core_deps

    sudo dnf -y --nogpgcheck --best --allowerasing install gcc gcc-c++ make redhat-rpm-config curl
}

archlinux_install_core_deps() {
    installing_core_deps

    # check for gcc-multilib
    gcc_pkg=gcc
    if sudo pacman -Q gcc-multilib >/dev/null 2>&1; then
        gcc_pkg=gcc-multilib
    fi

    # update catalogs
    sudo pacman -Sy

    # not using the base-devel group because it can break gcc-multilib
    sudo pacman --noconfirm --needed -S $gcc_pkg binutils file grep gawk gzip make patch sed util-linux curl

    done_msg
}

solus_install_core_deps() {
    installing_core_deps

    sudo eopkg -y update-repo
    sudo eopkg -y install -c system.devel curl

    done_msg
}

windows_install_core_deps() {
    if [ -n "$msys2" ]; then
        msys2_install_core_deps
    elif [ -n "$cygwin" ]; then
        cygwin_install_core_deps
    fi
}

cygwin_install_core_deps() {
    :
}

msys2_install_core_deps() {
    case "$MSYSTEM" in
        MINGW32)
            target='mingw-w64-i686'
            ;;
        *)
            target='mingw-w64-x86_64'
            ;;
    esac

    installing_core_deps

    # update catalogs
    pacman -Sy

    set --
    for p in binutils curl crt-git gcc gcc-libs gdb headers-git tools-git windows-default-manifest libmangle-git; do
        set -- "$@" "${target}-${p}"
    done

    # install
    # TODO: remove zip and add to dists
    pacman --noconfirm --needed -S make tar patch diffutils ccache zip perl m4 "$@"

    # make sure msys perl takes precedence over mingw perl if the latter is installed
    mkdir -p "$BUILD_ROOT/root/bin"
    ln -sf /usr/bin/perl "$BUILD_ROOT/root/bin/perl"

    # activate ccache
    eval "$BUILD_ENV"

    done_msg
}

mac_install_core_deps() {
    if ! xcode-select -p >/dev/null 2>&1 && \
       ! pkgutil --pkg-info=com.apple.pkg.CLTools_Executables >/dev/null 2>&1 && \
       ! pkgutil --pkg-info=com.apple.pkg.DeveloperToolsCLI >/dev/null 2>&1; then

        error 'Please install XCode and the XCode Command Line Tools, then run this script again. On newer systems this can be done with: [35m;xcode-select --install[0m'
    fi
}

setup_tmp_dir() {
    # mkdir -m doesn't work on some versions of msys and similar
    rm -rf "$TMP_DIR"
    if ! ( mkdir -m 700 "$TMP_DIR" 2>/dev/null || mkdir "$TMP_DIR" 2>/dev/null || [ -d "$TMP_DIR" ] ); then
        die "Failed to create temporary directory: '[1;35m$TMP_DIR[0m"
    fi

    chmod 700 "$TMP_DIR" 2>/dev/null || :

    trap 'quit $?' EXIT PIPE HUP INT QUIT ILL TRAP KILL BUS TERM
}

quit() {
    cd "$HOME" || :
    rm -rf "$TMP_DIR" || :
    exit "${1:-0}"
}

detect_os() {
    case "$(uname -s)" in
        Linux)
            os=linux
            ;;
        Darwin)
            os=mac
            ;;
        MINGW*|MSYS*)
            os=windows
            msys2=1
            ;;
        CYGWIN*)
            os=windows
            cygwin=1
            ;;
        *)
            os=unknown
            ;;
    esac

    case "$(uname -a)" in
        *x86_64*)
            bits=64
            ;;
        *i686*)
            bits=32
            ;;
    esac

    target_platform=$($CC -dumpmachine 2>/dev/null)
}

delete_outdated_dists() {
    [ ! -d "$BUILD_ROOT/downloads" ] && return 0

    files=
    i=0
    for dist in $DIST_NAMES; do
        dist_url=$(list_get $i $DIST_URLS)
        dist_file="$BUILD_ROOT/downloads/$dist-${dist_url##*/}"

        files="$files $dist_file"

        i=$((i + 1))
    done

    OLDIFS=$IFS IFS=$NL
    find "$BUILD_ROOT/downloads" -maxdepth 1 -type f -not -name '.*' | \
    while read -r file; do
        IFS=$OLDIFS
        if ! list_contains "$file" $files; then
            puts "${NL}[32mDeleting outdated dist: [1;34m$file[0m${NL}${NL}"
            rm -f "$file"
        fi
    done
    IFS=$OLDIFS

    (
        cd "$BUILD_ROOT/dists"

        OLDIFS=$IFS IFS=$NL
        find . -maxdepth 1 -type d -not -name '.*' | \
        while read -r dir; do
            IFS=$OLDIFS
            dir=${dir#./}
            if ! list_contains "$dir" $DIST_NAMES; then
                puts "${NL}[32mDeleting outdated dist unpack dir: [1;34m$dir[0m${NL}${NL}"
                rm -rf "$dir"
            fi
        done
        IFS=$OLDIFS
    )
}

build_prerequisites() {
    dists_are_installed $PRE_BUILD_DISTS && return 0

    puts "${NL}[32mFetching and building prerequisites...[0m${NL}${NL}"

    for dist in $PRE_BUILD_DISTS; do
        download_dist $dist
        build_dist_if_needed $dist
    done

    puts "${NL}[32mDone with prerequisites.[0m${NL}${NL}"
}

dists_are_installed() {
    for _dist; do
        if [ ! -f "$(install_artifact $_dist)" ]; then
            return 1
        fi
    done
}

download_dists() {
    running_jobs=
    max_jobs=$((NUM_CPUS * 2))
    mkdir -p "$TMP_DIR/job_status" "$TMP_DIR/job_output"
    for dist in $DIST_NAMES; do
        (
            job_pid=$(exec sh -c 'printf "%s" $PPID')
            putsln "dist_name=$dist" > "$TMP_DIR/job_status/$job_pid"
            {
                download_dist $dist
                putsln "job_exited=$?" >> "$TMP_DIR/job_status/$job_pid"
            } 2>&1 | tee "$TMP_DIR/job_output/$job_pid"
        ) &
        running_jobs="$running_jobs $!"

        while [ "$(list_length $running_jobs)" -ge $max_jobs ]; do
            sleep 1
            check_jobs running_jobs
        done
    done

    # wait for pending jobs to finish
    while [ "$(list_length $running_jobs)" -ne 0 ]; do
        sleep 1
        check_jobs running_jobs
    done
}

download_dist() {
    dist_name=$1
    [ -n "$dist_name" ] || die 'download_dist: dist name required'

    dist_idx=$(list_index $dist_name $DIST_NAMES)
    dist_url=$( list_get $dist_idx $DIST_URLS)
    orig_dist_file="$BUILD_ROOT/downloads/${dist_url##*/}"
    dist_file="$BUILD_ROOT/downloads/$dist_name-${dist_url##*/}"
    dist_dir="$DISTS_DIR/$dist_name"

    mkdir -p "$BUILD_ROOT/downloads"
    cd "$BUILD_ROOT/downloads"

    if [ ! -f "$dist_file" ]; then
        puts "${NL}[32mFetching [1;35m$dist_name[0m: [1;34m$dist_url[0m${NL}${NL}"
        curl -SsL "$dist_url" -o "$dist_file"

        # force rebuild for new dist file
        rm  -f "$BUILD_ROOT/root/$(list_get $dist_idx $DIST_TARGETS)"
        rm -rf "$dist_dir"
    fi

    if [ ! -d "$dist_dir" ]; then
        puts "${NL}[32mUnpacking [1;35m$dist_name[0m${NL}${NL}"
        mkdir "$dist_dir"

        unpack_dir="$UNPACK_DIR/$dist_name-$$"
        mkdir "$unpack_dir"
        cd "$unpack_dir"

        eval "set -- $(dist_tar_args "$dist_name")"

        case "$dist_file" in
            *.tar)
                $TAR $@ -xf "$dist_file"
                ;;
            *.tar.gz|*.tgz)
                $TAR $@ -zxf "$dist_file"
                ;;
            *.tar.xz)
                xzcat "$dist_file" | $TAR $@ -xf -
                ;;
            *.tar.bz2)
                bzcat "$dist_file" | $TAR $@ -xf -
                ;;
            *.zip)
                unzip -q "$dist_file"
                ;;
        esac

        if [ $(list_length *) -eq 1 ] && [ -d * ]; then
            # one archive dir
            cd *
        fi

        $TAR -cf - . | (cd "$dist_dir"; $TAR -xf -)

        cd "$TMP_DIR"
        rm -rf "$unpack_dir"

        # force rebuild if dist dir was deleted
        rm -f "$BUILD_ROOT/root/$(list_get $dist_idx $DIST_TARGETS)"
    fi
}

running_jobs() {
    alive_list_var=$1
    [ -n "$alive_list_var" ] || die 'running_jobs: alive list variable name required'
    reaped_list_var=$2
    [ -n "$reaped_list_var" ] || die 'running_jobs: reaped list variable name required'

    jobs_file="$TMP_DIR/jobs_list.txt"

    jobs -l > "$jobs_file"

    eval "$alive_list_var="
    eval "$reaped_list_var="
    OLDIFS=$IFS IFS=$NL
    # will get pair: <PID> <state>
    for job in $(sed <"$jobs_file" -n 's/^\[[0-9]\{1,\}\] *[-+]\{0,1\}  *\([0-9][0-9]*\)  *\([A-Za-z]\{1,\}\).*/\1 \2/p'); do
        IFS=$OLDIFS
        set -- $job
        pid=$1 state=$2
        
        case "$state" in
            Stopped)
                kill $pid 2>/dev/null || :
                eval "$reaped_list_var=\"\$$reaped_list_var $pid\""
                ;;
            Running)
                eval "$alive_list_var=\"\$$alive_list_var $pid\""
                ;;
        esac
    done
    IFS=$OLDIFS

    rm -f "$jobs_file"
}

check_jobs() {
    jobs_list_var=$1
    [ -n "$jobs_list_var" ] || die 'check_jobs: jobs list variable name required'

    running_jobs alive reaped

    new_jobs=
    for job in $(eval puts \$$jobs_list_var); do
        if list_contains $job $alive; then
            new_jobs="$new_jobs $job"
        else
            job_status_file="$TMP_DIR/job_status/$job"
            job_output_file="$TMP_DIR/job_output/$job"

            if [ -f "$job_status_file" ]; then
                job_exited= dist_name=
                eval "$(cat "$job_status_file")"

                if [ -n "$job_exited" ] && [ "$job_exited" -eq 0 ]; then
                    rm "$job_status_file" "$job_output_file"
                else
                    error "Fetch/unpack process failed, winding down pending processes..."

                    while [ "$(list_length $alive)" -ne 0 ]; do
                        for pid in $alive; do
                            if ! list_contains $pid $last_alive; then
                                kill $pid 2>/dev/null || :
                            else
                                kill -9 $pid 2>/dev/null || :
                            fi
                        done

                        last_alive=$alive

                        sleep 0.2

                        running_jobs alive reaped
                    done

                    if [ "$os" != windows ]; then
                        sleep 30
                    else
                        # this is painfully slow on msys2/cygwin
                        warn 'Please wait, this will take a while...'

                        # don't want signals to interrupt sleep
                        trap - PIPE HUP ALRM

                        sleep 330 || :
                    fi

                    error "Fetching/unpacking $dist_name failed, check the URL:${NL}${NL}$(cat "$job_output_file")"

                    rm -rf "$DISTS_DIR"

                    exit 1
                fi
            fi
        fi
    done

    eval "$jobs_list_var=\$new_jobs"
}

# fall back to 1 second sleeps if fractional sleep is not supported
sleep() {
    if ! command sleep "$@" 2>/dev/null; then
        sleep_secs=${1%%.*}
        shift
        if [ -z "$sleep_secs" ] || [ "$sleep_secs" -lt 1 ]; then
            sleep_secs=1
        fi
        command sleep $sleep_secs "$@"
    fi
}

build_dists() {
    for dist in $DIST_NAMES; do
        build_dist_if_needed $dist
    done
}

build_dist_if_needed() {
    dist_name=$1
    [ -n "$dist_name" ] || die 'build_dist_if_needed: dist name required'
    shift

    if [ ! -f "$(install_artifact $dist_name)" ]; then
        build_dist $dist_name "$@"
    fi
}

build_dist() {
    dist=$1
    [ -n "$dist" ] || die 'build_dist: dist name required'
    shift
    extra_dist_args=$@

    cd "$DISTS_DIR/$dist"

    puts "${NL}[32mBuilding [1;35m$dist[0m${NL}${NL}"

    ORIG_LDFLAGS=$LDFLAGS
    ORIG_LIBS=$LIBS

    # have to make sure C++ flags are passed when linking, but only for C++ and **NOT** C
    # this fails if there are any .c files in the project
    if [ "$(find . -name '*.cpp' -o -name '*.cc' | wc -l)" -ne 0 -a "$(find . -name '*.c' | wc -l)" -eq 0 ]; then
        export LDFLAGS="$CXXFLAGS $LDFLAGS"
    fi

    export LDFLAGS="$LDFLAGS $(dist_extra_ldflags "$dist")"
    export LIBS="$LIBS $(dist_extra_libs "$dist")"

    dist_patch "$dist"
    dist_pre_build "$dist"

    configure_override=$(dist_configure_override "$dist")
    install_override=$(dist_install_override "$dist")

    if [ -f meson.build -a ! -f configure.ac ]; then
        mkdir -p build
        cd build

        if [ -n "$configure_override" ]; then
            eval "set -- $extra_dist_args"
            echo_eval_run "$configure_override $@"
        else
            eval "set -- $(dist_args "$dist" meson) $extra_dist_args"
            echo_run meson .. "$@"
        fi
        dist_post_configure "$dist"
        eval "set -- $(dist_make_args "$dist")"
        echo_run ninja -j $NUM_CPUS "$@"

        if [ -z "$install_override" ]; then
            rm -rf destdir
            mkdir destdir

            echo_eval_run 'DESTDIR="$PWD/destdir" ninja '"$(dist_make_install_args "$dist")"' install || :'

            install_dist "$dist"
        else
            echo_eval_run "$install_override $(dist_make_install_args "$dist")"
        fi

        [ -f "$(install_artifact $dist)" ]
    elif [ -f configure -o -f configure.ac -o -f configure.in -o -f Makefile.am ]; then
        if [ -n "$configure_override" ]; then
            eval "set -- $extra_dist_args"
            echo_eval_run "$configure_override $@"
        else
            if [ ! -f configure ]; then
                if [ ! -f configure.ac ]; then
                    if [ -f autogen.sh ]; then
                        chmod +x autogen.sh
                        eval "set -- $(dist_args "$dist" autoconf) $extra_dist_args"
                        echo_run ./autogen.sh "$@"
                    elif [ -f buildconf.sh ]; then
                        chmod +x buildconf.sh
                        eval "set -- $(dist_args "$dist" autoconf) $extra_dist_args"
                        echo_run ./buildconf.sh "$@"
                    fi
                else
                    if [ -d m4 ]; then
                        echo_run aclocal --force -I m4
                    else
                        echo_run aclocal --force
                    fi

                    if command -v glibtoolize >/dev/null; then
                        echo_run glibtoolize --force
                    else
                        echo_run libtoolize --force
                    fi

                    echo_run autoheader || :
                    echo_run autoconf --force

                    if command -v gtkdocize >/dev/null; then
                        echo_run gtkdocize 2>/dev/null || :
                    fi

                    [ -f Makefile.am ] && echo_run automake --foreign --add-missing --copy
                fi
            fi

            eval "set -- $(dist_args "$dist" autoconf) $extra_dist_args"
            echo_run ./configure "$@"
        fi

        dist_post_configure "$dist"
        eval "set -- $(dist_make_args "$dist")"
        echo_run make -j$NUM_CPUS "$@"

        if [ -z "$install_override" ]; then
            rm -rf destdir
            mkdir destdir

            eval "set -- $(dist_make_install_args "$dist")"

            if grep -Eq 'DESTDIR|cmake_install\.cmake' $(find . -name Makefile -o -name '*.mk' -o -name '*.mak') 2>/dev/null; then
                echo_run make "$@" install DESTDIR="$PWD/destdir" || :
            else
                echo_run make "$@" install prefix="$PWD/destdir/$BUILD_ROOT/root" INSTALLTOP="$PWD/destdir/$BUILD_ROOT/root" || :
            fi

            install_dist "$dist"
        else
            echo_eval_run "$install_override $(dist_make_install_args "$dist")"
        fi

        [ -f "$(install_artifact $dist)" ]
    elif [ -f CMakeLists.txt ]; then
        mkdir -p build
        cd build

        if [ -n "$configure_override" ]; then
            eval "set -- $extra_dist_args"
            echo_eval_run "$configure_override $@"
        else
            eval "set -- $(dist_args "$dist" cmake) $extra_dist_args"
            echo_run cmake .. "$@"
        fi
        dist_post_configure "$dist"
        eval "set -- $(dist_make_args "$dist")"
        echo_run make -j$NUM_CPUS "$@"

        if [ -z "$install_override" ]; then
            rm -rf destdir
            mkdir destdir

            eval "set -- $(dist_make_install_args "$dist")"

            echo_run make "$@" install DESTDIR="$PWD/destdir" || :

            install_dist "$dist"
        else
            echo_eval_run "$install_override $(dist_make_install_args "$dist")"
        fi

        [ -f "$(install_artifact $dist)" ]
    elif [ -f Makefile.PL ]; then
        echo_run cpanm --notest --installdeps .

        if [ -n "$configure_override" ]; then
            eval "set -- $extra_dist_args"
            echo_eval_run "$configure_override $@"
        else
            eval "set -- $(dist_args "$dist" perl) $extra_dist_args"
            echo_run perl Makefile.PL "$@"
        fi

        dist_post_configure "$dist"
        eval "set -- $(dist_make_args "$dist")"
        echo_run $PERL_MAKE "$@" # dmake doesn't understand -j

        if [ -z "$install_override" ]; then
            eval "set -- $(dist_make_install_args "$dist")"
            echo_run $PERL_MAKE "$@" install || :
        else
            echo_eval_run "$install_override $(dist_make_install_args "$dist")"
        fi

        [ -f "$(install_artifact $dist)" ]
    elif [ -f setup.py ]; then
        if [ -z "$install_override" ]; then
            pip=
            if grep -Eq 'Python :: 3' PKG-INFO 2>/dev/null; then
                pip=pip3
            fi
            if grep -Eq 'Python :: 2' PKG-INFO 2>/dev/null; then
                pip="$pip pip2"
            fi

            for pip in $pip; do
                if [ -n "$configure_override" ]; then
                    eval "set -- $extra_dist_args"
                    echo_eval_run "$configure_override $@"
                else
                    eval "set -- $(dist_args "$dist" python) $extra_dist_args"
                    echo_run $pip install . "$@"
                fi
            done
        else
            echo_eval_run "$install_override $(dist_make_install_args "$dist")"
        fi

        [ -f "$(install_artifact $dist)" ]
    elif [ \( -f Makefile -o -f makefile \) -a -z "$configure_override" ]; then
        eval "set -- $DIST_BARE_MAKE_ARGS $(dist_make_args "$dist")"

        echo_run make -j$NUM_CPUS "$@"

        if [ -z "$install_override" ]; then
            eval "set -- $DIST_BARE_MAKE_INSTALL_ARGS $(dist_make_install_args "$dist")"
            echo_run make "$@" install || :
        else
            echo_eval_run "$install_override $(dist_make_install_args "$dist")"
        fi

        [ -f "$(install_artifact $dist)" ]
    elif [ -n "$configure_override" ]; then
        eval "set -- $extra_dist_args"
        echo_eval_run "$configure_override $@"
        [ -f "$(install_artifact $dist)" ]
    else
        die "don't know how to build [1;35m$dist[0m"
    fi

    dist_post_build "$dist"

    export LDFLAGS="$ORIG_LDFLAGS"
    export LIBS="$ORIG_LIBS"

    done_msg
}

# assumes make install has run into ./destdir
install_dist() {
    dist_name=$1
    [ -n "$dist_name" ] || die 'install_dist: dist name required'
    [ -d destdir      ] || die 'install_dist: ./destdir does not exist'

    # move libs out of platforms dirs like lib/x86_64-linux-gnu/ and lib64/
    # and adjust pkgconfig files

    dest_lib_dir="destdir/$(remove_drive_prefix "$BUILD_ROOT/root/lib")"

    [ -n "$target_platform" ] && dest_platform_lib_dir="$dest_lib_dir/$target_platform"
    [ -n "$bits"            ] && dest_bits_lib_dir="destdir/$(remove_drive_prefix "$BUILD_ROOT/root/lib$bits")"

    for platf_dir in "$dest_platform_lib_dir" "$dest_bits_lib_dir"; do
        if [ -n "$platf_dir" ] && [ -d "$platf_dir" ]; then
            if [ -d "$platf_dir/pkgconfig" ]; then
                sed -i.bak "s,lib/$target_platform,lib,g" "$platf_dir/pkgconfig"/*.pc
                rm -f "$platf_dir/pkgconfig"/*.pc.bak
            fi

            mkdir -p "$dest_lib_dir"

            (cd "$platf_dir"; $TAR -cf - .) | (cd "$dest_lib_dir"; $TAR -xf -)

            rm -rf "$platf_dir"
        fi
    done

    # copy platform includes to the regular include dirs
    OLDIFS=$IFS IFS=$NL
    for platform_inc_dir in $(find "destdir/$(remove_drive_prefix "$BUILD_ROOT/root/lib/")" -mindepth 2 -maxdepth 2 -type d -name include 2>/dev/null || :); do
        IFS=$OLDIFS
        (
            inc_dir=${platform_inc_dir%/*}
            inc_dir="destdir/$(remove_drive_prefix "$BUILD_ROOT/root/include/")${inc_dir##*/}"

            mkdir -p "$inc_dir"

            (cd "$platform_inc_dir"; $TAR -cf - .) | (cd "$inc_dir"; $TAR -xf -)
        )
    done
    IFS=$OLDIFS

    # check that key file was built
    [ -e "destdir/$(remove_drive_prefix "$(install_artifact "$dist_name")")" ]

    cd "destdir/$(remove_drive_prefix $BUILD_ROOT)/root"
    OLDPWD=$PWD
    find . ! -type d | (cd "$BUILD_ROOT/root"; OLDIFS=$IFS IFS=$NL;
    while read f; do
        IFS=$OLDIFS
        if [ ! -d "${f%/*}" ]; then
            echo_run mkdir -p "${f%/*}"
        fi
        echo_run cp -af "$OLDPWD/$f" "$f"
    done)
}

echo_run() {
    putsln "[32mExecuting[0m[35m:[0m $(cmd_with_quoted_args "$@")"
    "$@"
}

echo_eval_run() {
    putsln "[32mExecuting[0m[35m:[0m $@"
    eval "$@"
}

cmd_with_quoted_args() {
    [ -n "$1" ] || error 'cmd_with_quoted_args: command required'
    res="$1 "
    shift
    for arg; do
        res="$res '$arg'"
    done
    puts "$res"
}

remove_drive_prefix() {
    path=$1
    [ -n "$path" ] || die 'remove_drive_prefix: path required'

    if [ -n "$msys2" ]; then
        path=${path#/[a-zA-Z]/}
    elif [ -n "$cygwin" ]; then
        path=${path#/cygdrive/[a-zA-Z]/}
    fi

    # remove windows drive prefixes such as c:
    path=${path#[a-zA-Z]:}

    # remove all but one slash at the beginning (double slashes have special meaning on windows)
    while :; do
        case "$path" in
            /*)
                path=${path#/}
                ;;
            *)
                break
                ;;
        esac
    done

    puts "/$path"
}

list_get() {
    pos=$1
    [ -n "$pos" ] || die 'list_pos: position to retrieve required'
    shift

    i=0
    for item; do
        if [ $i -eq $pos ]; then
            puts "$item"
            return 0
        fi

        i=$((i + 1))
    done
}

list_index() {
    item=$1
    [ -n "$item" ] || die 'list_index: item to find required'
    shift

    i=0
    for element; do
        if [ "$element" = "$item" ]; then
            puts $i
            return 0
        fi

        i=$((i + 1))
    done

    return 1
}

dist_args() {
    dist=$1
    [ -n "$dist" ] || die 'dist_args: dist name required'
    buildsys=$2

    case "$buildsys" in
        autoconf)
            puts "$CONFIGURE_ARGS $(table_line DIST_ARGS $dist)" || :
            ;;
        cmake)
            puts "$CMAKE_ARGS $(table_line DIST_ARGS $dist)" || :
            ;;
        meson)
            puts "$MESON_ARGS $(table_line DIST_ARGS $dist)" || :
            ;;
        perl)
            puts "$(table_line DIST_ARGS $dist)" || :
            ;;
        python)
            puts "$(table_line DIST_ARGS $dist)" || :
            ;;
        *)
            die "dist_args: buildsystem type required, must be 'autoconf', 'cmake' or 'perl'"
            ;;
    esac
}

dist_tar_args() {
    _dist=$1
    [ -n "$_dist" ] || die 'dist_tar_args: dist name required'

    puts "$(table_line DIST_TAR_ARGS $_dist)" || :
}

dist_configure_override() {
    _dist=$1
    [ -n "$_dist" ] || die 'dist_configure_override: dist name required'

    puts "$(table_line DIST_CONFIGURE_OVERRIDES $_dist)" || :
}

dist_install_override() {
    _dist=$1
    [ -n "$_dist" ] || die 'dist_install_override: dist name required'

    puts "$(table_line DIST_INSTALL_OVERRIDES $_dist)" || :
}

dist_make_args() {
    dist=$1
    [ -n "$dist" ] || die 'dist_make_args: dist name required'

    puts "$(table_line DIST_MAKE_ARGS $dist)" || :
}

dist_make_install_args() {
    dist=$1
    [ -n "$dist" ] || die 'dist_make_install_args: dist name required'

    puts "$(table_line DIST_MAKE_INSTALL_ARGS $dist)" || :
}

dist_extra_ldflags() {
    dist=$1
    [ -n "$dist" ] || die 'dist_extra_ldflags: dist name required'

    puts "$(table_line DIST_EXTRA_LDFLAGS $dist)" || :
}

dist_extra_libs() {
    dist=$1
    [ -n "$dist" ] || die 'dist_extra_libs: dist name required'

    puts "$(table_line DIST_EXTRA_LIBS $dist)" || :
}

dist_patch() {
    _dist_name=$1
    [ -n "$_dist_name" ] || die 'dist_patch: dist name required'

    for _patch_url in $(table_line DIST_PATCHES $_dist_name); do
        _patch_file=${_patch_url##*/}
        _patch_file=${_patch_file%%\?*}

        if [ ! -f "$_patch_file" ]; then
            puts "${NL}[32mApplying patch [1;34m$_patch_url[0m to [1;35m$_dist_name[0m${NL}${NL}"

            curl -SsL "$_patch_url" -o "$_patch_file"
            patch -p1 < "$_patch_file"
        fi

        done_msg
    done
}

dist_pre_build() {
    _dist_name=$1
    [ -n "$_dist_name" ] || die 'dist_pre_build: dist name required'

    if _cmd=$(table_line DIST_PRE_BUILD $_dist_name); then
        puts "${NL}[32mRunning pre-build for: [1;35m$_dist_name[0m:${NL}$_cmd${NL}${NL}"

        eval "$_cmd"
    fi
}

dist_post_configure() {
    _dist_name=$1
    [ -n "$_dist_name" ] || die 'dist_post_configure: dist name required'

    if _cmd=$(table_line DIST_POST_CONFIGURE $_dist_name); then
        puts "${NL}[32mRunning post-configure for: [1;35m$_dist_name[0m:${NL}$_cmd${NL}${NL}"

        eval "$_cmd"
    fi
}

dist_post_build() {
    _dist_name=$1
    [ -n "$_dist_name" ] || die 'dist_post_build: dist name required'

    if _cmd=$(table_line DIST_POST_BUILD $_dist_name); then
        if [ -z "$IN_DIST_POST_BUILD" ]; then
            IN_DIST_POST_BUILD=1

            puts "${NL}[32mRunning post-build for: [1;35m$_dist_name[0m:${NL}$_cmd${NL}${NL}"

            eval "$_cmd"

            IN_DIST_POST_BUILD=
        fi
    fi
}

install_docbook_dist() {
    _type=$1

    _dist_ver=$(echo "$PWD" | sed 's/.*[^0-9.]\([0-9.]*\)$/\1/')

    case "$_type" in
        stylesheet)
            _dir="stylesheet/${PWD##*/}"
            ;;
        schema)
            _dir="schema/dtd/$_dist_ver"
            ;;
        *)
            die "install_docbook_dist: type of dist required, must be 'stylesheet' or 'schema'"
            ;;
    esac

    _dir="$BUILD_ROOT/root/share/xml/docbook/$_dir"

    echo_run mkdir -p "$_dir"
    echo_run cp -af * "$_dir"

    if [ -f "$_dir/catalog.xml" ]; then
        echo_run xmlcatalog --noout --del "file://$_dir/catalog.xml" "$BUILD_ROOT/root/etc/xml/catalog.xml" || :
        echo_run xmlcatalog --noout --add nextCatalog '' "file://$_dir/catalog.xml" "$BUILD_ROOT/root/etc/xml/catalog.xml"
    fi
}

install_fonts() {
    if [ -d fontconfig ]; then
        install -v -m644 fontconfig/*.conf "$BUILD_ROOT/root/etc/fonts/conf.d"
    fi

    ttf_found=
    OLDIFS=$IFS IFS=$NL
    for ttf in $(find . -name '*.ttf' -o -name '*.TTF'); do
        IFS=$OLDIFS
        ttf_found=1
        if [ ! -d "$BUILD_ROOT/root/share/fonts/${PWD##*/}" ]; then
            install -v -d -m755 "$BUILD_ROOT/root/share/fonts/${PWD##*/}"
        fi
        install -v -m644 "$ttf" "$BUILD_ROOT/root/share/fonts/${PWD##*/}"
    done
    IFS=$OLDIFS

    [ -n "$ttf_found" ] && echo_run fc-cache -v "$BUILD_ROOT/root/share/fonts/${PWD##*/}"
}

table_line() {
    table=$1
    [ -n "$table" ] || die 'table_line: table name required'
    name=$2
    [ -n "$name" ]  || die 'table_line: item name required'

    table=$(table_contents $table)

    OLDIFS=$IFS IFS=$NL
    for line in $table; do
        IFS=$OLDIFS
        set -- $line
        if [ "$1" = "$name" ]; then
            shift
            puts "$@"
            return 0
        fi
    done
    IFS=$OLDIFS

    return 1
}

table_line_append() {
    table=$1
    [ -n "$table" ]      || die 'table_line_append: table name required'
    name=$2
    [ -n "$name" ]       || die 'table_line_append: item name required'
    append_str=$3
    [ -n "$append_str" ] || die 'table_line_append: string to append required'

    table_name=$table
    table=$(table_contents $table)

    new_table=
    line_appended=
    OLDIFS=$IFS IFS=$NL
    for line in $table; do
        IFS=$OLDIFS
        set -- $line
        if [ "$1" = "$name" ]; then
            new_table=$new_table"$@ $append_str"${NL}
            line_appended=1
        else
            new_table=$new_table"$@"${NL}
        fi
    done
    IFS=$OLDIFS

    if [ -z "$line_appended" ]; then
        # make new entry
        new_table=$new_table"$name $append_str"${NL}
    fi

    eval "$table_name=\$new_table"
}

table_line_replace() {
    table=$1
    [ -n "$table" ]   || die 'table_line_replace: table name required'
    name=$2
    [ -n "$name" ]    || die 'table_line_replace: item name required'
    set_str=$3
    [ -n "$set_str" ] || die 'table_line_replace: string to set required'

    table_name=$table
    table=$(table_contents $table)

    new_table=
    line_found=
    OLDIFS=$IFS IFS=$NL
    for line in $table; do
        IFS=$OLDIFS
        set -- $line
        if [ "$1" = "$name" ]; then
            new_table=$new_table"$1 $set_str"${NL}
            line_found=1
        else
            new_table=$new_table"$@"${NL}
        fi
    done
    IFS=$OLDIFS

    if [ -z "$line_found" ]; then
        # make new entry
        new_table=$new_table"$name $set_str"${NL}
    fi

    eval "$table_name=\$new_table"
}

table_insert_after() {
    table=$1
    [ -n "$table" ]   || die 'table_insert_after: table name required'
    name=$2
    [ -n "$name" ]    || die 'table_insert_after: item name to insert after required'
    new_line=$3
    [ -n "$new_line" ] || die 'table_insert_after: new line required'

    table_name=$table
    table=$(table_contents $table)

    new_table=
    line_found=
    OLDIFS=$IFS IFS=$NL
    for line in $table; do
        IFS=$OLDIFS
        set -- $line
        new_table=$new_table"$@"${NL}

        if [ "$1" = "$name" ]; then
            new_table="${new_table}${new_line}"${NL}
            line_found=1
        fi
    done
    IFS=$OLDIFS

    [ -n "$line_found" ] || error 'table_insert_after: item to insert after not found'

    eval "$table_name=\$new_table"
}

table_insert_before() {
    table=$1
    [ -n "$table" ]   || die 'table_insert_before: table name required'
    name=$2
    [ -n "$name" ]    || die 'table_insert_before: item name to insert before required'
    new_line=$3
    [ -n "$new_line" ] || die 'table_insert_before: new line required'

    table_name=$table
    table=$(table_contents $table)

    new_table=
    line_found=
    OLDIFS=$IFS IFS=$NL
    for line in $table; do
        IFS=$OLDIFS
        set -- $line

        if [ "$1" = "$name" ]; then
            new_table="${new_table}${new_line}"${NL}
            line_found=1
        fi

        new_table=$new_table"$@"${NL}
    done
    IFS=$OLDIFS

    [ -n "$line_found" ] || die 'table_insert_before: item to insert before not found'

    eval "$table_name=\$new_table"
}

table_line_remove() {
    table=$1
    [ -n "$table" ]      || die 'table_line_remove: table name required'
    name=$2
    [ -n "$name" ]       || die 'table_line_remove: item name required'

    table_name=$table
    table=$(table_contents $table)

    new_table=
    OLDIFS=$IFS IFS=$NL
    for line in $table; do
        IFS=$OLDIFS
        set -- $line
        if [ "$1" != "$name" ]; then
            new_table=$new_table"$@"${NL}
        fi
    done
    IFS=$OLDIFS

    eval "$table_name=\$new_table"
}

find_checkout() {
    (
        cd "$(dirname "$0")"
        while [ "$PWD" != / ]; do
            if [ -f src/version.h.in ]; then
                puts "$PWD"
                exit 0
            fi

            cd ..
        done
        exit 1
    ) || die 'cannot find project checkout'
}

error() {
    puts >&2 "${NL}[31mERROR[0m: $@${NL}${NL}"
}

warn() {
    puts >&2 "${NL}[35mWARNING[0m: $@${NL}${NL}"
}

die() {
    error "$@"
    exit 1
}

build_project() {
    puts "${NL}[32mBuilding project: [1;34m$CHECKOUT[0m${NL}${NL}"

    mkdir -p "$BUILD_ROOT/project"
    cd "$BUILD_ROOT/project"

    eval "set -- $CMAKE_BASE_ARGS"
    echo_run cmake "$CHECKOUT" "$@" -DVBAM_STATIC=ON -DENABLE_FFMPEG=ON
    echo_run make -j$NUM_CPUS

    if [ "$os" = mac ]; then
        codesign -s "Developer ID Application" --deep ./visualboyadvance-m.app || :

        rm -f ./visualboyadvance-m-Mac.zip
        zip -9r ./visualboyadvance-m-Mac.zip ./visualboyadvance-m.app
    fi

    puts "${NL}[32mBuild Successful!!![0m${NL}${NL}Build results can be found in: [1;34m$BUILD_ROOT/project[0m${NL}${NL}"
}

table_column() {
    table=$1
    [ -n "$table" ]    || die 'table_column: table name required'
    col=$2
    [ -n "$col" ]      || die 'table_column: column required'
    row_size=$3
    [ -n "$row_size" ] || die 'table_column: row_size required'

    table=$(table_contents $table)

    i=0
    res=
    for item in $table; do
        if [ $((i % row_size)) -eq "$col" ]; then
            res="$res $item"
        fi
        i=$((i + 1))
    done

    puts "$res"
}

table_rows() {
    table=$1
    [ -n "$table" ] || die 'table_rows: table name required'

    table=$(table_contents $table)

    i=0
    OLDIFS=$IFS IFS=$NL
    for line in $table; do
        i=$((i + 1))
    done
    IFS=$OLDIFS

    puts $i
}

table_contents() {
    table=$1
    [ -n "$table" ] || die 'table_contents: table name required'

    # filter comments and blank lines
    eval puts "\"\$$table\"" | grep -Ev '^ *(#|$)' || :
}

list_contains() {
    _item=$1
    [ -n "$_item" ] || die 'list_contains: item required'
    shift

    for _pos; do
        [ "$_item" = "$_pos" ] && return 0
    done

    return 1
}

list_length() {
    puts $#
}

install_artifact() {
    dist=$1
    [ -n "$dist" ] || die 'install_artifact: dist name required'

    set -- $(table_line DISTS $dist)

    eval puts "'$BUILD_ROOT/root/'"\"\$$#\"
}

echo() {
    if [ -n "$BASH_VERSION" -a "$os" != mac ]; then
        builtin echo -e "$@"
    else
        command echo "$@"
    fi
}

puts() {
    printf '%s' "$1"
    shift

    for _str; do
        printf ' %s' "$_str"
    done
}

putsln() {
    puts "$@"
    printf '\n'
}

# this needs to run on source, not just after entry
detect_os
