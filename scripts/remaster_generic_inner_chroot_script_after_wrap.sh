#xfceforensic_remove_skel_stuff()

if [ "${1}" = "lxde" ]; then
	echo "LXDE build!"
elif [ "${1}" = "mate" ]; then
	echo "Mate build!"
elif [ "${1}" = "e17" ]; then
	echo "Enlightenment BUILD!"
	#genmenu.py -e
	#sed -i '/lxdm-greeter-gtk/ a\\nlast_session=enlightenment.desktop\nlast_lang=' /etc/lxdm/lxdm.conf
elif [ "${1}" = "xfce" ]; then
	echo "XFCE build!"
	#genmenu.py -x
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

for PKG in sabayon-artwork-core sabayon-artwork-grub sabayon-artwork-isolinux sabayon-skel sabayon-artwork-lxde linux-sabayon
equo mask $PKG
equo remove $PKG --nodeps
done


######END######

rm -rfv /etc/entropy/packages/license.accept
# plymouth-set-default-theme spike
# genkernel --plymouth-theme=spike  --luks initramfs

