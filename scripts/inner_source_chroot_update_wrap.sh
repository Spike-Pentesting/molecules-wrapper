#echo '192.99.32.76 repository.spike-pentesting.org' >>/etc/hosts

rm -rfv /etc/entropy/repositories.conf.d/entropy_weekly
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
