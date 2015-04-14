export SABAYON_MOLECULE_HOME=$(pwd)"/molecules"
export SABAYON_RELEASE="1.0.2"


if [ -d "${SABAYON_MOLECULE_HOME}" ]; then
    cd "${SABAYON_MOLECULE_HOME}"
    git fetch --all
    git reset --hard origin/master
    cd ..
else
    git clone https://github.com/Sabayon/molecules.git
fi
ARCH="${1}"
export ISO_TAG="${2}" #14.05, DAILY
export BASE_VERSION="${3}" #Minimal, SpinBase
FLAVOR="${4}"

#cp -rfv "$(pwd)"/molecules/scripts/inner_source_chroot_update.sh "$(pwd)"/molecules/scripts/inner_source_chroot_update_dev.sh


"$(pwd)"/wrap.pl
cp -rfv "$(pwd)"/scripts/make_grub_efi.sh "$(pwd)"/molecules/scripts/make_grub_efi.sh
chmod +x "$(pwd)"/molecules/scripts/make_grub_efi.sh

cp -rfv "$(pwd)"/scripts/inner_source_chroot_update_dev.sh "$(pwd)"/molecules/scripts/inner_source_chroot_update_dev.sh
chmod +x "$(pwd)"/molecules/scripts/inner_source_chroot_update_dev.sh

cp -rfv "$(pwd)"/scripts/inner_source_chroot_update_stable.sh "$(pwd)"/molecules/scripts/inner_source_chroot_update_stable.sh
chmod +x "$(pwd)"/molecules/scripts/inner_source_chroot_update_stable.sh


cp -rfv "$(pwd)"/scripts/generic_pre_iso_script.sh "$(pwd)"/molecules/scripts/generic_pre_iso_script.sh
chmod +x "$(pwd)"/molecules/scripts/generic_pre_iso_script.sh

molecule specs/spike-pentesting-"${ARCH}"-"${FLAVOR}".spec
sudo rm -rfv '/var/tmp/molecule*'
