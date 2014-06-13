#!/bin/bash

/usr/sbin/env-update
. /etc/profile


prepare_system() {
	local de="${1}"
	if [ "${de}" = "lxde" ]; then

	elif [ "${de}" = "mate" ]; then

	elif [ "${de}" = "e17" ]; then
		genmenu.py -e
	elif [ "${de}" = "xfce" ]; then

	elif [ "${de}" = "fluxbox" ]; then

	elif [ "${de}" = "gnome" ]; then

	elif [ "${de}" = "xfceforensic" ]; then

	elif [ "${de}" = "kde" ]; then

	elif [ "${de}" = "awesome" ]; then

	fi
}


prepare_system "${1}"
"${SABAYON_MOLECULE_HOME}"/scripts/remaster_generic_inner_chroot_script_after.sh "${1}"
exit 0
