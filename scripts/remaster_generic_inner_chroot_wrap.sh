#!/bin/sh

/usr/sbin/env-update
. /etc/profile

echo '192.99.32.76 repository.spike-pentesting.org' >>/etc/hosts

echo '[spike]
desc = Spike Pentesting Sabayon Repository
repo = http://repository.spike-pentesting.org#bz2
enabled = true
pkg = http://repository.spike-pentesting.org
' >> /etc/entropy/repositories.conf.d/entropy_spike

"${SABAYON_MOLECULE_HOME}"/scripts/remaster_generic_inner_chroot_script.sh

export ACCEPT_LICENSE="*"