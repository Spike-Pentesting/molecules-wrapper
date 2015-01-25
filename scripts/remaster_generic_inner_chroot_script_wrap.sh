#echo '192.99.32.76 repository.spike-pentesting.org' >>/etc/hosts

echo '[spike]
desc = Spike Pentesting Sabayon Repository
repo = https://repository.spike-pentesting.org#bz2
enabled = true
pkg = https://repository.spike-pentesting.org
' >> /etc/entropy/repositories.conf.d/spike
#sed -i 's:splash::g' /etc/default/sabayon-grub #plymouth fix
#grub2-mkconfig -o /boot/grub/grub.cfg
rsync -av -H -A -X --delete-during "rsync://rsync.at.gentoo.org/gentoo-portage/licenses/" "/usr/portage/licenses/"
ls /usr/portage/licenses -1 | xargs -0 > /etc/entropy/packages/license.accept


equo mask sabayon-skel sabayon-version sabayon-artwork-grub sabayon-live
equo remove sabayon-artwork-grub sabayon-artwork-core sabayon-artwork-isolinux sabayon-version sabayon-skel sabayon-live sabayonlive-tools sabayon-live  sabayon-artwork-gnome --nodeps
#equo remove linux-sabayon:$(eselect kernel list | grep "*" | awk '{print $2}' | cut -d'-' -f2) --nodeps --configfiles
equo remove linux-sabayon --nodeps --configfiles
equo remove --force-system sabayon-version --configfiles
equo mask sabayon-version
equo install spike-version --nodeps

equo install sys-boot/grub::spike


mkdir -p /etc/entropy/packages/package.mask.d/
#Masking sabayon packages
REPLACEMENT=">=sys-apps/openrc-0.9@sabayon-limbo
>=sys-apps/openrc-0.9@sabayonlinux.org
>=sys-apps/openrc-0.9@sabayon-weekly
>=app-misc/sabayonlive-tools-2.3@sabayon-limbo
>=app-misc/sabayonlive-tools-2.3@sabayonlinux.org
>=app-misc/sabayonlive-tools-2.3@sabayon-weekly
>=app-misc/sabayon-live-1.3@sabayon-limbo
>=app-misc/sabayon-live-1.3@sabayonlinux.org
>=app-misc/sabayon-live-1.3@sabayon-weekly
>=app-misc/sabayon-skel-1@sabayon-limbo
>=app-misc/sabayon-skel-1@sabayonlinux.org
>=app-misc/sabayon-skel-1@sabayon-weekly
>=sys-boot/grub-1.00@sabayon-limbo
>=sys-boot/grub-1.00@sabayonlinux.rg
>=sys-boot/grub-1.00@sabayon-weekly
>=kde-base/oxygen-icons-4.9.2@sabayon-weekly
>=kde-base/oxygen-icons-4.9.2@sabayonlinux.org
>=kde-base/oxygen-icons-4.9.2@sabayon-limbo
>=x11-themes/gnome-colors-common-5.5.1@sabayon-weekly
>=x11-themes/gnome-colors-common-5.5.1@sabayonlinux.org
>=x11-themes/gnome-colors-common-5.5.1@sabayon-limbo
>=x11-themes/tango-icon-theme-0.8.90@sabayon-weekly
>=x11-themes/tango-icon-theme-0.8.90@sabayonlinux.org
>=x11-themes/tango-icon-theme-0.8.90@sabayon-limbo
>=x11-themes/elementary-icon-theme-2.7.1@sabayon-weekly
>=x11-themes/elementary-icon-theme-2.7.1@sabayonlinux.org
>=x11-themes/elementary-icon-theme-2.7.1@sabayon-limbo
>=lxde-base/lxdm-0.4.1-r5@sabayon-weekly
>=lxde-base/lxdm-0.4.1-r5@sabayonlinux.org
>=lxde-base/lxdm-0.4.1-r5@sabayon-limbo
>=sys-apps/gpu-detector-1@sabayon-weekly
>=sys-apps/gpu-detector-1@sabayonlinux.org
>=sys-apps/gpu-detector-1@sabayon-limbo
>=app-admin/anaconda-0.1@sabayon-weekly
>=app-admin/anaconda-0.1@sabayonlinux.org
>=app-admin/anaconda-0.1@sabayon-limbo
>=sys-boot/plymouth-1@sabayon-weekly
>=sys-boot/plymouth-1@sabayonlinux.org
>=sys-boot/plymouth-1@sabayon-limbo
>=x11-themes/sabayon-artwork-core-1@sabayon-weekly
>=x11-themes/sabayon-artwork-core-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-core-1@sabayon-limbo
>=x11-themes/sabayon-artwork-extra-1@sabayon-weekly
>=x11-themes/sabayon-artwork-extra-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-extra-1@sabayon-limbo
>=x11-themes/sabayon-artwork-gnome-1@sabayon-weekly
>=x11-themes/sabayon-artwork-gnome-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-gnome-1@sabayon-limbo
>=x11-themes/sabayon-artwork-grub-1@sabayon-weekly
>=x11-themes/sabayon-artwork-grub-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-grub-1@sabayon-limbo
>=x11-themes/sabayon-artwork-isolinux-1@sabayon-weekly
>=x11-themes/sabayon-artwork-isolinux-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-isolinux-1@sabayon-limbo
>=x11-themes/sabayon-artwork-kde-1@sabayon-weekly
>=x11-themes/sabayon-artwork-kde-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-kde-1@sabayon-limbo
>=x11-themes/sabayon-artwork-loo-1@sabayon-weekly
>=x11-themes/sabayon-artwork-loo-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-loo-1@sabayon-limbo
>=x11-themes/sabayon-artwork-lxde-1@sabayon-weekly
>=x11-themes/sabayon-artwork-lxde-1@sabayonlinux.org
>=x11-themes/sabayon-artwork-lxde-1@sabayon-limbo
>=app-misc/anaconda-runtime-1.1-r1@sabayon-weekly
>=app-misc/anaconda-runtime-1.1-r1@sabayonlinux.org
>=app-misc/anaconda-runtime-1.1-r1@sabayon-limbo"

echo $REPLACEMENT >> /etc/entropy/packages/package.mask
echo $REPLACEMENT >> /etc/entropy/packages/package.mask.d/package.mask