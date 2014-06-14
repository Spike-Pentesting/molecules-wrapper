
if [ "${1}" = "lxde" ]; then
	echo "LXDE build!"
elif [ "${1}" = "mate" ]; then
	echo "Mate build!"
elif [ "${1}" = "e17" ]; then
	genmenu.py -e
elif [ "${1}" = "xfce" ]; then
	echo "XFCE build!"
elif [ "${1}" = "fluxbox" ]; then
	echo "FLUXBOX build!"
elif [ "${1}" = "gnome" ]; then
	echo "GNOME build!"
elif [ "${1}" = "xfceforensic" ]; then
	echo "xfceforensic build!"
elif [ "${1}" = "kde" ]; then
	echo "KDE build!"
elif [ "${1}" = "awesome" ]; then
	echo "AWESOME build!"
fi

#rm -rfv /etc/entropy/packages/license.accept
mv /etc/portage/make.conf.bak /etc/portage/make.conf
