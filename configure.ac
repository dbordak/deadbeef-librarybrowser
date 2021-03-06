dnl Process this file with autoconf to produce a configure script.
AC_INIT([deadbeef-lb],[devel])
AM_INIT_AUTOMAKE([foreign])

dnl Override $PACKAGE to make $pkglibdir use deadbeef search path
PACKAGE=deadbeef

AM_CONFIG_HEADER(config.h)

AC_USE_SYSTEM_EXTENSIONS
AC_PROG_CC
AC_LANG_C
AC_HEADER_STDC
AC_PROG_INSTALL
AC_PROG_LIBTOOL
AC_CONFIG_MACRO_DIR([m4])
PKG_PROG_PKG_CONFIG

#IT_PROG_INTLTOOL([0.40.0])
#AM_GNU_GETTEXT
#GETTEXT_PACKAGE=deadbeef-fb
#AC_SUBST(GETTEXT_PACKAGE)

CFLAGS="$CFLAGS -Wall -g"
if test "x$EXTRA_CFLAGS" != "x" ; then
  CFLAGS="$CFLAGS $EXTRA_CFLAGS"
fi

test "x$PREFIX" = xNONE && PREFIX=$ac_default_prefix

AC_DEFINE_UNQUOTED(LOCALEDIR, "${PREFIX}/${DATADIRNAME}/locale", [Name of gettext locale directory])

AC_ARG_ENABLE(debug, [AS_HELP_STRING([--enable-debug], [enable debug options (default: disabled)])], [enable_debug=$enableval], [enable_debug=no])
AC_ARG_ENABLE(staticlink, [AS_HELP_STRING([--enable-staticlink], [link everything statically (default: disabled)])], [enable_staticlink=$enableval], [enable_staticlink=no])
AC_ARG_ENABLE(gtk3,     [AS_HELP_STRING([--disable-gtk3     ], [build GTK3 version of gtkui plugin (default: enabled)])], [enable_gtk3=$enableval], [enable_gtk3=yes])
AC_ARG_ENABLE(gtk2,     [AS_HELP_STRING([--disable-gtk2     ], [build GTK2 version of gtkui plugin (default: enabled)])], [enable_gtk2=$enableval], [enable_gtk2=yes])

if test "x$enable_debug" != "xno" ; then
    AC_DEFINE_UNQUOTED([DEBUG], [1], [Define if building debug version])
    DEBUG=yes
fi

if test "x$enable_staticlink" != "xno" ; then
    AC_DEFINE_UNQUOTED([STATICLINK], [1], [Define if building static version])
    STATICLINK=yes
fi

if test "x$enable_gtk3" == "xyes" ; then
    PKG_CHECK_MODULES(GTK3_DEPS, gtk+-3.0 >= 3.0 gthread-2.0 glib-2.0, HAVE_GTK3=yes, HAVE_GTK3=no)
else
    HAVE_GTK3=no
fi

if test "x$enable_gtk2" == "xyes" ; then
    PKG_CHECK_MODULES(GTK2_DEPS, gtk+-2.0 >= 2.12 gthread-2.0 glib-2.0, HAVE_GTK2=yes, HAVE_GTK2=no)
else
    HAVE_GTK2=no
fi

AM_CONDITIONAL(DEBUG, test "x$DEBUG" = "xyes")
AM_CONDITIONAL(STATICLINK, test "x$STATICLINK" = "xyes")
AM_CONDITIONAL(HAVE_GTK3, test "x$HAVE_GTK3" = "xyes")
AM_CONDITIONAL(HAVE_GTK2, test "x$HAVE_GTK2" = "xyes")

AC_CONFIG_FILES([
Makefile
])
#intl/Makefile
#po/Makefile.in

dnl read Makefile.in and write Makefile
AC_OUTPUT
