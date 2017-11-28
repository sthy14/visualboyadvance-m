set -e

[ -z "$BUILD_ROOT" ] && BUILD_ROOT=$HOME/vbam-build-unix

. "$(dirname "$0")/../builder/core.sh"

table_insert_before DISTS autoconf '
    m4              https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz                                                 bin/m4
'

# on mac openal is part of the system, on most unixes we need openal-soft
table_insert_before DISTS sfml '
    openal          http://kcat.strangesoft.net/openal-releases/openal-soft-1.18.2.tar.bz2                      lib/libopenal.a
'

# have to build a large chunk of X11 on *nix
table_insert_before DISTS sfml '
    xproto          https://www.x.org/archive/individual/proto/xproto-7.0.31.tar.bz2                            include/X11/X.h
    xcb-proto       https://www.x.org/archive/individual/xcb/xcb-proto-1.12.tar.bz2                             lib/pkgconfig/xcb-proto.pc
    inputproto      https://www.x.org/archive/individual/proto/inputproto-2.3.2.tar.bz2                         include/X11/extensions/XI.h
    kbproto         https://www.x.org/archive/individual/proto/kbproto-1.0.7.tar.bz2                            include/X11/extensions/XKBsrv.h
    xextproto       https://www.x.org/archive/individual/proto/xextproto-7.3.0.tar.bz2                          include/X11/extensions/shmproto.h
    renderproto     https://www.x.org/archive/individual/proto/renderproto-0.11.tar.bz2                         lib/pkgconfig/renderproto.pc
    randrproto      https://www.x.org/archive/individual/proto/randrproto-1.5.0.tar.bz2                         lib/pkgconfig/randrproto.pc
    glproto         https://www.x.org/releases/individual/proto/glproto-1.4.17.tar.bz2                          lib/pkgconfig/glproto.pc
    dri2proto       https://www.x.org/archive/individual/proto/dri2proto-2.8.tar.bz2                            lib/pkgconfig/dri2proto.pc
    dri3proto       https://www.x.org/archive/individual/proto/dri3proto-1.0.tar.bz2                            lib/pkgconfig/dri3proto.pc
    damageproto     https://www.x.org/archive//individual/proto/damageproto-1.2.1.tar.bz2                       lib/pkgconfig/damageproto.pc
    fixesproto      https://www.x.org/archive//individual/proto/fixesproto-5.0.tar.bz2                          lib/pkgconfig/fixesproto.pc
    recordproto     https://www.x.org/archive//individual/proto/recordproto-1.14.2.tar.bz2                      lib/pkgconfig/recordproto.pc
    xf86vidmodeproto https://www.x.org/archive//individual/proto/xf86vidmodeproto-2.3.1.tar.bz2                 lib/pkgconfig/xf86vidmodeproto.pc
    libpthread-stubs https://www.x.org/archive/individual/xcb/libpthread-stubs-0.4.tar.bz2                      lib/pkgconfig/pthread-stubs.pc
    libXau          https://www.x.org/archive/individual/lib/libXau-1.0.8.tar.bz2                               lib/libXau.a
    libxcb          https://www.x.org/archive/individual/xcb/libxcb-1.12.tar.bz2                                lib/libxcb.a
    xtrans          https://www.x.org/archive/individual/lib/xtrans-1.3.5.tar.bz2                               include/X11/Xtrans/Xtrans.h
    libX11          https://www.x.org/archive/individual/lib/libX11-1.6.5.tar.bz2                               lib/libX11.a
    libXext         https://www.x.org/archive/individual/lib/libXext-1.3.3.tar.bz2                              lib/libXext.a
    libXrender      https://www.x.org/archive/individual/lib/libXrender-0.9.10.tar.bz2                          lib/libXrender.a
    libXrandr       https://www.x.org/archive/individual/lib/libXrandr-1.5.1.tar.bz2                            lib/libXrandr.a
    libXfixes       https://www.x.org/archive//individual/lib/libXfixes-5.0.3.tar.bz2                           lib/libXfixes.a
    libXdamage      https://www.x.org/archive//individual/lib/libXdamage-1.1.4.tar.bz2                          lib/libXdamage.a
    libxshmfence    https://www.x.org/archive//individual/lib/libxshmfence-1.2.tar.bz2                          lib/libxshmfence.a
    libXi           https://www.x.org/archive//individual/lib/libXi-1.7.9.tar.bz2                               lib/libXi.a
    libXtst         https://www.x.org/archive//individual/lib/libXtst-1.2.3.tar.bz2                             lib/libXtst.a
    libXxf86vm      https://www.x.org/archive//individual/lib/libXxf86vm-1.1.4.tar.bz2                          lib/libXxf86vm.a
'

# and Wayland now that that's a thing
table_insert_before DISTS sfml '
    wayland         https://wayland.freedesktop.org/releases/wayland-1.14.0.tar.xz                              lib/libwayland-client.a
    wayland-protocols https://wayland.freedesktop.org/releases/wayland-protocols-1.11.tar.xz                    share/pkgconfig/wayland-protocols.pc
'

# and mesa OpenGL (the Gallium drivers in mesa require llvm)
table_insert_before DISTS sfml '
    libpciaccess    https://www.x.org/archive//individual/lib/libpciaccess-0.14.tar.bz2                         lib/libpciaccess.a
    libdrm          https://dri.freedesktop.org/libdrm/libdrm-2.4.88.tar.bz2                                    lib/libdrm.a
#    llvm            http://releases.llvm.org/5.0.0/llvm-5.0.0.src.tar.xz                                        lib/libLLVMCore.a
    libelf          http://www.mr511.de/software/libelf-0.8.13.tar.gz                                           lib/libelf.a
    mesa            https://mesa.freedesktop.org/archive/mesa-17.3.0-rc5.tar.xz                                 lib/libGL.so
    glu             ftp://ftp.freedesktop.org/pub/mesa/glu/glu-9.0.0.tar.bz2                                    lib/libGLU.a
    freeglut        https://downloads.sourceforge.net/project/freeglut/freeglut/3.0.0/freeglut-3.0.0.tar.gz     lib/libglut.a
'

# and need GTK with all deps for wx
table_insert_before DISTS wxwidgets '
    pixman          https://www.cairographics.org/releases/pixman-0.34.0.tar.gz                                 lib/libpixman-1.a
    cairo           http://cairographics.org/snapshots/cairo-1.15.8.tar.xz                                      lib/libcairo.a
    libepoxy        https://github.com/anholt/libepoxy/releases/download/1.4.3/libepoxy-1.4.3.tar.xz            lib/libepoxy.a
    gdk-pixbuf      https://download.gnome.org/sources/gdk-pixbuf/2.36/gdk-pixbuf-2.36.11.tar.xz                lib/libgdk_pixbuf-2.0.a
    pango           https://download.gnome.org/sources/pango/1.40/pango-1.40.14.tar.xz                          lib/libpango-1.0.a
    atk             https://download.gnome.org/sources/atk/2.27/atk-2.27.1.tar.xz                               lib/libatk-1.0.a
    dbus            https://dbus.freedesktop.org/releases/dbus/dbus-1.12.2.tar.gz                               lib/libdbus-1.a
    gtk-doc         https://github.com/GNOME/gtk-doc/archive/GTK_DOC_1_26.tar.gz                                bin/gtkdocize
    gobject-introspection https://download.gnome.org/sources/gobject-introspection/1.55/gobject-introspection-1.55.0.tar.xz share/aclocal/introspection.m4
    at-spi2-core    https://github.com/GNOME/at-spi2-core/archive/AT_SPI2_CORE_2_26_2.tar.gz                    lib/libatspi.a
    at-spi2-atk     https://github.com/GNOME/at-spi2-atk/archive/AT_SPI2_ATK_2_26_1.tar.gz                      lib/libatk-bridge-2.0.a
    libxkbcommon    https://xkbcommon.org/download/libxkbcommon-0.7.2.tar.xz                                    lib/libxkbcommon.a
    graphene        https://github.com/ebassi/graphene/archive/1.6.0.tar.gz                                     lib/libgraphene-1.0.a
    gtk+            https://download.gnome.org/sources/gtk+/3.92/gtk+-3.92.1.tar.xz                             lib/libgtk-4.a
'

table_line_append DIST_PATCHES freeglut 'https://gist.githubusercontent.com/rkitover/e6d6af234c6a5cea05a7943dba7ab76f/raw/4ba4305d55d56140e90e0761f46e4b73a40e304d/freeglut-3.0.0-static-X11.patch'

table_line_append DIST_ARGS freeglut '-DFREEGLUT_BUILD_SHARED_LIBS=NO -DFREEGLUT_BUILD_STATIC_LIBS=YES'

table_line_append DIST_ARGS gtk-doc "--with-xml-catalog='$BUILD_ROOT/root/etc/xml/catalog.xml'"

table_line_append DIST_CONFIGURE_OVERRIDES at-spi2-core ":; ./autogen.sh $CONFIGURE_ARGS;"

table_line_replace DIST_PRE_BUILD gobject-introspection ':; rm -f configure configure.ac configure.in Makefile.am;'

table_line_replace DIST_CONFIGURE_OVERRIDES gobject-introspection ':; cp m4/introspection.m4 "$BUILD_ROOT/root/share/aclocal";'

table_line_append DIST_PRE_BUILD gtk+ ':; sed -i.bak '"\"s/'-Werror[^']*',//g; s/shared_library(/library(/g\""' $(find . -name meson.build)'

table_line_append DIST_ARGS gtk+ '-Dintrospection=false -Denable-x11-backend=true -Denable-wayland-backend=true -Ddemos=false -Dbuild-tests=false -Dinstall-tests=false -Ddisable-modules=true -Dwith-included-immodules=all'

table_line_append DIST_EXTRA_LDFLAGS gtk+ '-Wl,--allow-multiple-definition -Wl,--as-needed -Wl,--start-group -latspi -lexpat -lharfbuzz -lpixman-1 -lpng -ldbus-1 -lX11 -lX11-xcb -lxcb -lXau -lXext -lwayland-client -lmount -lglib-2.0 -lgio-2.0 -lgmodule-2.0 -lgobject-2.0 -lpcre -lz -lffi -lpthread -lresolv -ldl -lintl -liconv -luuid -lblkid -lm -lutil -lbz2'

table_line_append DIST_POST_BUILD gtk+ '(cd "$BUILD_ROOT/root/lib/pkgconfig"; for pc in gtk+*-4.0.pc; do ln -sf "$pc" "${pc%4.0.pc}3.0.pc"; done)'

table_line_append DIST_CONFIGURE_OVERRIDES wxwidgets '--with-x --with-opengl --with-gtk=3 --disable-gtktest'

table_line_append DIST_EXTRA_LIBS wxwidgets '-Wl,--allow-multiple-definition -Wl,--as-needed -Wl,--start-group -lfreetype -lfontconfig -lgtk-4 -latspi -lexpat -lharfbuzz -lpixman-1 -lpng -ldbus-1 -lX11 -lX11-xcb -lxcb -lXau -lXext -lwayland-client -lmount -lglib-2.0 -lgio-2.0 -lgmodule-2.0 -lgobject-2.0 -lpcre -lz -lffi -lpthread -lresolv -ldl -lintl -liconv -luuid -lblkid -lm -lutil -lbz2 -llzma'

#table_line_append DIST_ARGS gobject-introspection '--enable-shared --disable-static'

#table_line_append DIST_EXTRA_LIBS gobject-introspection '-Wl,--as-needed -Wl,--start-group -Wl,-lmount -Wl,-lglib-2.0 -Wl,-lgio-2.0 -Wl,-lgmodule-2.0 -Wl,-lgobject-2.0 -Wl,-lpcre -Wl,-lz -Wl,-lffi -Wl,-lpthread -Wl,-lresolv -Wl,-ldl -Wl,-lintl -Wl,-liconv -Wl,-luuid -Wl,-lblkid -Wl,-lm -Wl,-lutil -Wl,--end-group'

table_line_append DIST_PRE_BUILD llvm ':; rm -f configure;'

table_line_append DIST_PRE_BUILD mesa ':; rm -f configure;'

table_line_append DIST_ARGS mesa '--enable-shared --disable-static --with-gallium-drivers=no --with-dri-drivers=no --with-platforms=x11,surfaceless,drm,wayland'

table_line_append DIST_EXTRA_LIBS mesa '-Wl,--as-needed -Wl,--start-group -lexpat -lxcb -lxcb-dri3 -lxcb-dri2 -lxcb-present -lxcb-sync -lxcb-xfixes -lxshmfence -lX11-xcb -ldrm -ldrm_amdgpu -ldrm_intel -ldrm_nouveau -ldrm_radeon -lwayland-client -Wl,--end-group'

table_line_append DIST_EXTRA_LIBS cairo '-Wl,--start-group -lX11 -lXext -lXrender -lxcb -lXau -ldl -Wl,--end-group'

table_line_append DIST_ARGS openal '-DLIBTYPE=STATIC'

table_line_append DIST_MAKE_ARGS libvpx "AS='yasm -DPIC'"

table_line_append DIST_ARGS ffmpeg '--enable-pic'

table_line_append DIST_EXTRA_LDFLAGS ffmpeg '-lgomp'

table_line_remove DISTS wxwidgets
