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



######END######
# check if a kernel update is needed
kernel_target_pkg="sys-kernel/linux-spike"

available_kernel=$(equo match "${kernel_target_pkg}" -q --showslot)
echo
echo "@@ Upgrading kernel to ${available_kernel}"
echo
safe_run kernel-switcher switch "${available_kernel}" || exit 1
equo remove "sys-kernel/linux-sabayon" || exit 1
safe_run kernel-switcher switch "${available_kernel}" || exit 1

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



rm -rfv /etc/entropy/repositories.conf.d/entropy_sabayon-weekly

echo '[sabayonlinux.org]
desc = Sabayon Linux Official Repository
repo = http://pkg.sabayon.org#bz2
repo = http://pkg.repo.sabayon.org#bz2
enabled = true
pkg = http://mirror.umd.edu/sabayonlinux/entropy
pkg = http://mirror.freelydifferent.com/sabayon/entropy
pkg = http://dl.sabayon.org/entropy
pkg = http://bali.idrepo.or.id/sabayon/entropy
pkg = http://ftp.sh.cvut.cz/MIRRORS/sabayon/entropy
pkg = http://madura.idrepo.or.id/sabayon/entropy
pkg = http://sumbawa.idrepo.or.id/sabayon/entropy
pkg = http://www2.itti.ifce.edu.br/sabayon/entropy
pkg = http://riksun.riken.go.jp/pub/pub/Linux/sabayon/entropy
pkg = http://ftp.yz.yamagata-u.ac.jp/pub/linux/sabayonlinux/entropy
pkg = ftp://ftp.klid.dk/sabayonlinux/entropy
pkg = http://best.sabayon.org/entropy
pkg = http://cross-lfs.sabayonlinux.org/entropy
pkg = http://redir.sabayon.org/entropy
pkg = http://ftp.fsn.hu/pub/linux/distributions/sabayon/entropy
pkg = http://ftp.surfnet.nl/pub/os/Linux/distr/sabayonlinux/entropy
pkg = http://ftp.cc.uoc.gr/mirrors/linux/SabayonLinux/entropy
pkg = http://mirror.internode.on.net/pub/sabayon/entropy
pkg = http://sabayon.c3sl.ufpr.br/entropy
pkg = http://ftp.kddilabs.jp/Linux/packages/sabayonlinux/entropy
pkg = http://mirror.yandex.ru/sabayon/entropy
pkg = ftp://ftp.nluug.nl/pub/os/Linux/distr/sabayonlinux/entropy
pkg = http://debian.mirror.dkm.cz/sabayon/entropy
pkg = http://ftp.rnl.ist.utl.pt/pub/sabayon/entropy
pkg = http://mirror.clarkson.edu/sabayon/entropy
pkg = http://na.mirror.garr.it/mirrors/sabayonlinux/entropy
pkg = http://pkg.sabayon.org

' >> /etc/entropy/repositories.conf.d/entropy_sabayonlinux.org


ls -liah /etc/entropy/repositories.conf.d/
cat /etc/entropy/repositories.conf.d/entropy_sabayonlinux.org

#mkdir -p /etc/entropy/packages/package.mask.d/
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
>=x11-themes/sabayon-artwor-gnome-1@sabayon-weekly
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
>=app-misc/anaconda-runtime-1.1-r1@sabayon-limbo
"


safe_run equo update --force || exit 1


# metasploit still targets ruby19

    masks=(=dev-ruby/act3ionpack-4.2.0@sabayonlinux.org
=dev-ruby/activesupport-4.2.0@sabayonlinux.org
=dev-ruby/rails-html-sanitizer-1.0.1@sabayonlinux.org
=dev-ruby/rails-dom-testing-1.0.5@sabayonlinux.org
=dev-ruby/activemodel-4.2.0@sabayonlinux.org
=dev-ruby/activerecord-4.2.0@sabayonlinux.org
=dev-ruby/rails-deprecated_sanitizer-1.0.3@sabayonlinux.org
=dev-ruby/loofah-2.0.1@sabayonlinux.org
=dev-ruby/arel-6.0.0@sabayonlinux.org
=dev-ruby/mime-types-2.4.3@sabayonlinux.org
=dev-ruby/actionview-4.2.0@sabayonlinux.org)

    for mask in "${masks[@]}"; do
        equo mask ${mask}
    done

echo $REPLACEMENT >> /etc/entropy/packages/package.mask
#echo $REPLACEMENT >> /etc/entropy/packages/package.mask.d/package.mask

export ETP_NOINTERACTIVE=1
safe_run equo upgrade || exit 1
equo upgrade --purge || exit 1


equo install sys-boot/grub::spike



equo mask sabayon-skel sabayon-version sabayon-artwork-grub sabayon-live
equo remove sabayon-artwork-grub sabayon-artwork-core sabayon-artwork-isolinux sabayon-version sabayon-skel sabayon-live sabayonlive-tools sabayon-live  sabayon-artwork-gnome --nodeps --force-system
#equo remove linux-sabayon:$(eselect kernel list | grep "*" | awk '{print $2}' | cut -d'-' -f2) --nodeps --configfiles
equo remove linux-sabayon --nodeps --configfiles
equo remove --force-system sabayon-version --configfiles
equo mask sabayon-version
equo install  --multifetch 10 spike/spike::spike
equo query list installed -qv > /etc/sabayon-pkglist



