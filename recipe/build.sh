#!/usr/bin/env bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config
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

known_fail="TS_OPT_misc_setarch_known_fail=yes"
known_fail+=" TS_OPT_column_invalid_multibyte_known_fail=yes"
known_fail+=" TS_OPT_hardlink_options_known_fail=yes"  # flaky on py3.9?
if [[ $target_platform == linux-aarch64 ]]; then
  known_fail+=" TS_OPT_lsfd_mkfds_ro_regular_file_known_fail=yes"  # can be flaky on this platform
fi
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check $known_fail
fi

make install
