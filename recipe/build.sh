#!/usr/bin/env bash
set -ex

./configure --prefix="${PREFIX}" \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-static     \
            --without-systemd    \
            --disable-makeinstall-chown \
            --disable-makeinstall-setuid \
            --without-systemdsystemunitdir
make -j ${CPU_COUNT}
make check \
  TS_OPT_misc_setarch_known_fail=yes \
  TS_OPT_column_invalid_multibyte_known_fail=yes \
  TS_OPT_hardlink_options_known_fail=yes  # flaky
make install
