#!/bin/bash

TARGET="${1}"

/usr/sbin/env-update
. /etc/profile


# Setup environment vars
export ETP_NONINTERACTIVE=1
if [ -d "/usr/portage/licenses" ]; then
    export ACCEPT_LICENSE="$(ls /usr/portage/licenses -1 | xargs)"
fi

rm -rfv /etc/entropy/repositories.conf.d/*

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
pkg = https://mirror.spike-pentesting.org/mirrors/spike
pkg = https://repository.spike-pentesting.org
' >> /etc/entropy/repositories.conf.d/spike

#sed -i 's:splash::g' /etc/default/sabayon-grub #plymouth fix
#grub2-mkconfig -o /boot/grub/grub.cfg
rsync -av -H -A -X --delete-during "rsync://rsync.at.gentoo.org/gentoo-portage/licenses/" "/usr/portage/licenses/"
ls /usr/portage/licenses -1 | xargs -0 > /etc/entropy/packages/license.accept
equo update --force

PACKAGES_TO_REMOVE=(
    "app-i18n/man-pages-da"
    "app-i18n/man-pages-de"
    "app-i18n/man-pages-fr"
    "app-i18n/man-pages-it"
    "app-i18n/man-pages-nl"
    "app-i18n/man-pages-pl"
    "app-i18n/man-pages-ro"
    "app-i18n/man-pages-ru"
    "app-i18n/man-pages-zh_CN"
)

safe_run() {
    local updated=0
    for ((i=0; i < 42; i++)); do
        "${@}" && {
            updated=1;
            break;
        }
        if [ ${i} -gt 6 ]; then
            sleep 3600 || return 1
        else
            sleep 1200 || return 1
        fi
    done
    if [ "${updated}" = "0" ]; then
        return 1
    fi
    return 0
}





for repo in $(equo repo list -q); do
    echo "Optimizing mirrors for ${repo}"
    equo repo mirrorsort "${repo}"  # ignore errors
done





ls -liah /etc/entropy/repositories.conf.d/



safe_run equo update --force || exit 1


equo i sys-boot/plymouth


   masks=(
=dev-ruby/actionpack@sabayonlinux.org
dev-ruby/builder@sabayonlinux.org
dev-ruby/rails-html-sanitizer@sabayonlinux.org
dev-ruby/rails-dom-testing@sabayonlinux.org
dev-ruby/activemodel@sabayonlinux.org
dev-ruby/activerecord@sabayonlinux.org
dev-ruby/rails-deprecated_sanitizer@sabayonlinux.org
=net-misc/networkmanager-1.0.0@sabayonlinux.org
=gnome-extra/nm-applet-1.0.0@sabayonlinux.org
#x11-themes/sabayon-artwork-core
#x11-themes/sabayon-artwork-grub
#x11-themes/sabayon-artwork-isolinux
#x11-themes/sabayon-artwork-extra
#x11-themes/sabayon-artwork-kde
#x11-themes/sabayon-artwork-lxde
sys-boot/plymouth@sabayonlinux.org
sys-boot/grub@sabayonlinux.org
dev-ruby/rubygems@sabayonlinux.org
dev-ruby/tilt@sabayonlinux.org
dev-ruby/tzinfo@sabayonlinux.org
dev-ruby/bundler@sabayonlinux.org
dev-ruby/loofah@sabayonlinux.org
dev-ruby/arel@sabayonlinux.org
dev-ruby/mime-types@sabayonlinux.org
dev-ruby/actionpack@sabayonlinux.org
dev-ruby/activesupport@sabayonlinux.org
dev-ruby/ffi@sabayonlinux.org
www-servers/thin@sabayonlinux.org
dev-ruby/daemons@sabayonlinux.org
dev-ruby/ruby_parser@sabayonlinux.org
dev-ruby/actionview@sabayonlinux.org
dev-ruby/execjs@sabayonlinux.org
dev-ruby/mime-types@sabayonlinux.org
dev-ruby/packetfu@sabayonlinux.org
)

    for mask in "${masks[@]}"; do
        equo mask ${mask}
    done

export ETP_NONINTERACTIVE=1
safe_run equo upgrade || exit 1
equo upgrade --purge || exit 1

#equo i sys-boot/plymouth
equo i spike-artwork-core

equo mask sabayon-skel sabayon-version sabayon-artwork-grub sabayon-live

equo remove sabayon-artwork-grub sabayon-artwork-core sabayon-artwork-isolinux sabayon-version sabayon-skel sabayon-live sabayonlive-tools sabayon-live  sabayon-artwork-gnome --nodeps --force-system
equo remove linux-sabayon:$(eselect kernel list | grep "*" | awk '{print $2}' | cut -d'-' -f2) --nodeps --configfiles
#equo remove linux-sabayon
equo mask sabayon-version

equo install sys-boot/grub::spike

#equo install  --multifetch 10 spike/spike::spike

# ruby19 as default
eselect ruby set ruby20

safe_run equo upgrade --fetch || exit 1
equo upgrade --purge || exit 1
equo remove "${PACKAGES_TO_REMOVE[@]}" # ignore
echo "-5" | equo conf update
available_kernel='sys-kernel/linux-spike-3.19.4'
current_kernel=$(equo match --installed "sys-kernel/linux-sabayon" -q --showslot)
# check if a kernel update is needed

    echo
    echo "@@ Upgrading kernel to ${available_kernel}"
    echo
    safe_run kernel-switcher switch "${available_kernel}" || exit 1
    equo remove "${current_kernel}"
    equo remove linux-sabayon
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

rm -rf /var/lib/entropy/client/packages

# copy Portage config from sabayonlinux.org entropy repo to system
for conf in package.mask package.unmask package.keywords make.conf package.use; do
    repo_path=/var/lib/entropy/client/database/*/sabayonlinux.org/standard
    repo_conf=$(ls -1 ${repo_path}/*/*/${conf} | sort | tail -n 1 2>/dev/null)
    if [ -n "${repo_conf}" ]; then
        target_path="/etc/portage/${conf}"
        if [ ! -d "${target_path}" ]; then # do not touch dirs
            cp "${repo_conf}" "${target_path}" # ignore
        fi
    fi
done

# split config file
for conf in 00-sabayon.package.use 00-sabayon.package.mask \
    00-sabayon.package.unmask 00-sabayon.package.keywords; do
    repo_path=/var/lib/entropy/client/database/*/sabayonlinux.org/standard
    repo_conf=$(ls -1 ${repo_path}/*/*/${conf} | sort | tail -n 1 2>/dev/null)
    if [ -n "${repo_conf}" ]; then
        target_path="/etc/portage/${conf/00-sabayon.}/${conf}"
        target_dir=$(dirname "${target_path}")
        if [ -f "${target_dir}" ]; then # remove old file
            rm "${target_dir}" # ignore failure
        fi
        mkdir -p "${target_dir}" # ignore failure
        cp "${repo_conf}" "${target_path}" # ignore

    fi
done

# Update /usr/portage/profiles
# This is actually not strictly needed but several
# gentoo tools expect to find valid /etc/make.profile symlink
# This part is best effort, if it will be able to complete
# correctly, fine.
# For a list of mirrors, see: http://www.gentoo.org/main/en/mirrors-rsync.xml
RSYNC_URI="rsync://rsync.at.gentoo.org/gentoo-portage/profiles"
PROFILES_DIR="/usr/portage/profiles"
safe_run rsync -av -H -A -X --delete-during "${RSYNC_URI}/" "${PROFILES_DIR}/"


equo install sys-boot/grub::spike
equo remove sabayon-artwork-grub sabayon-artwork-core sabayon-artwork-isolinux sabayon-version sabayon-skel sabayon-live sabayonlive-tools sabayon-live  sabayon-artwork-gnome --nodeps --force-system


#Importing Anaconda artwork
wget http://repository.spike-pentesting.org/distfiles/anaconda-artwork.tar.gz -O /tmp/anaconda-artwork.tar.gz
tar xvf /tmp/anaconda-artwork.tar.gz  -C /usr/share/anaconda/pixmaps/
rm -rfv /tmp/anaconda-artwork.tar.gz
# check if a kernel update is needed


echo
echo "@@ Upgrading kernel to ${available_kernel}"
echo
#safe_run kernel-switcher switch "${available_kernel}" || exit 1
#equo remove "sys-kernel/linux-sabayon" || exit 1
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

#
#sed -i 's:sabayon:spike:g' /etc/plymouth/plymouthd.conf

echo '
[Daemon]
Theme=spike
' > /etc/plymouth/plymouthd.conf



#equo mask sabayon-artwork-core
equo rm sabayon-artwork-core
equo i spike-artwork-core



echo '
# useradd defaults file
GROUP=100
HOME=/home
INACTIVE=-1
EXPIRE=
SHELL=/bin/zsh
SKEL=/etc/skel
' > /etc/default/useradd
equo remove sabayon-artwork-isolinux
equo i spike-artwork-isolinux 

equo query list installed -qv > /etc/sabayon-pkglist
