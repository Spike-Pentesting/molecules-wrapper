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


######END######

rm -rfv /etc/entropy/packages/license.accept
#chsh -s /bin/zsh sabayonuser
# genkernel --plymouth-theme=spike  --luks initramfs

echo '
# useradd defaults file
GROUP=100
HOME=/home
INACTIVE=-1
EXPIRE=
SHELL=/bin/zsh
SKEL=/etc/skel
' > /etc/default/useradd
#set default plymouth theme
#plymouth-set-default-theme spike

equo mask sabayon-skel sabayon-version sabayon-artwork-grub sabayon-live
equo remove sabayon-artwork-grub sabayon-artwork-core sabayon-artwork-isolinux sabayon-version sabayon-skel sabayon-live sabayonlive-tools sabayon-live  sabayon-artwork-gnome --nodeps
#equo remove linux-sabayon:$(eselect kernel list | grep "*" | awk '{print $2}' | cut -d'-' -f2) --nodeps --configfiles
equo remove linux-sabayon --nodeps --configfiles
equo remove --force-system sabayon-version --configfiles
equo mask sabayon-version
equo install spike-version --nodeps

equo install sys-boot/grub::spike

