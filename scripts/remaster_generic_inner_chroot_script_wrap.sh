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

