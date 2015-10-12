
PHP_ARG_ENABLE(tideways, whether to enable Tideways support,
[ --enable-tideways      Enable Tideways support])

AC_DEFUN([AC_TIDEWAYS_CLOCK],
[
  have_clock_gettime=no

  AC_MSG_CHECKING([for clock_gettime])

  AC_TRY_LINK([ #include <time.h> ], [struct timespec ts; clock_gettime(CLOCK_MONOTONIC, &ts);], [
    have_clock_gettime=yes
    AC_MSG_RESULT([yes])
  ], [
    AC_MSG_RESULT([no])
  ])

  if test "$have_clock_gettime" = "no"; then
    AC_MSG_CHECKING([for clock_gettime in -lrt])

    SAVED_LIBS="$LIBS"
    LIBS="$LIBS -lrt"

    AC_TRY_LINK([ #include <time.h> ], [struct timespec ts; clock_gettime(CLOCK_MONOTONIC, &ts);], [
      have_clock_gettime=yes
      AC_MSG_RESULT([yes])
    ], [
      LIBS="$SAVED_LIBS"
      AC_MSG_RESULT([no])
    ])
  fi

  if test "$have_clock_gettime" = "no"; then
    AC_MSG_CHECKING([for clock_get_time])

    AC_TRY_RUN([ #include <mach/mach.h>
      #include <mach/clock.h>
      #include <mach/mach_error.h>

      int main()
      {
        kern_return_t ret; clock_serv_t aClock; mach_timespec_t aTime;
        ret = host_get_clock_service(mach_host_self(), REALTIME_CLOCK, &aClock);

        if (ret != KERN_SUCCESS) {
          return 1;
        }

        ret = clock_get_time(aClock, &aTime);
        if (ret != KERN_SUCCESS) {
          return 2;
        }

        return 0;
      }
    ], [
      have_clock_gettime=yes
      AC_DEFINE([HAVE_CLOCK_GET_TIME], 1, [do we have clock_get_time?])
      AC_MSG_RESULT([yes])
    ], [
      AC_MSG_RESULT([no])
    ])
  fi

  if test "$have_clock_gettime" = "yes"; then
      AC_DEFINE([HAVE_CLOCK_GETTIME], 1, [do we have clock_gettime?])
  fi

  if test "$have_clock_gettime" = "no"; then
      AC_MSG_ERROR([clock_gettime is missing, but required])
  fi
])

if test "$PHP_TIDEWAYS" != "no"; then
  AC_TIDEWAYS_CLOCK

  PHP_SUBST([LIBS])
  PHP_SUBST([TIDEWAYS_SHARED_LIBADD])
  PHP_NEW_EXTENSION(tideways, tideways.c, $ext_shared)
fi
