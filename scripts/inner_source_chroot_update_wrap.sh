echo '192.99.32.76 repository.spike-pentesting.org' >>/etc/hosts

echo '[spike]
desc = Spike Pentesting Sabayon Repository
repo = http://repository.spike-pentesting.org#bz2
enabled = true
pkg = http://repository.spike-pentesting.org
' >> /etc/entropy/repositories.conf.d/spike
#sed -i 's:splash::g' /etc/default/sabayon-grub #plymouth fix
#grub2-mkconfig -o /boot/grub/grub.cfg
rsync -av -H -A -X --delete-during "rsync://rsync.at.gentoo.org/gentoo-portage/licenses/" "/usr/portage/licenses/"
ls /usr/portage/licenses -1 | xargs -0 > /etc/entropy/packages/license.accept

equo mask sabayon-artwork-core sabayon-artwork-grub sabayon-artwork-isolinux sabayon-skel sabayon-artwork-lxde linux-sabayon
equo remove sabayon-artwork-core sabayon-artwork-grub sabayon-artwork-isolinux sabayon-skel sabayon-artwork-lxde linux-sabayon --nodeps

######END######

# check if a kernel update is needed
kernel_target_pkg="sys-kernel/linux-spike"

available_kernel=$(equo match "${kernel_target_pkg}" -q --showslot)
echo
echo "@@ Upgrading kernel to ${available_kernel}"
echo
safe_run kernel-switcher switch "${available_kernel}" || exit 1
equo remove "sys-kernel/linux-sabayon" || exit 1
# now delete stale files in /lib/modules
for slink in $(find /lib/modules/ -type l); do
    if [ ! -e "${slink}" ]; then
        echo "Removing broken symlink: ${slink}"
        rm "${slink}" # ignore failure, best effort
        # check if parent dir is empty, in case, remove
        paren_slink=$(dirname "${slink}")
        paren_children=$(find "${paren_slink}")
        if [ -z "${paren_children}" ]; then
            echo "${paren_slink} is empty, removing"
            rmdir "${paren_slink}" # ignore failure, best effort
        fi
    fi
done


# keep /lib/modules clean at all times
for moddir in $(find /lib/modules -maxdepth 1 -type d -empty); do
    echo "Cleaning ${moddir} because it's empty"
    rmdir "${moddir}"
done
