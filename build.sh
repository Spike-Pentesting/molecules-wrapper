export SABAYON_MOLECULE_HOME=$(pwd)"/molecules"
export SABAYON_RELEASE="1.0a"


if [ -d "${SABAYON_MOLECULE_HOME}" ]; then
    cd "${SABAYON_MOLECULE_HOME}"
    git fetch --all
    git reset --hard origin/master
    cd ..
else
    git clone https://github.com/Sabayon/molecules
fi
ARCH="${1}"
export ISO_TAG="${2}" #14.05, DAILY
export BASE_VERSION="${3}" #Minimal, SpinBase
FLAVOR="${4}"

"$(pwd)"/wrap.pl
cp -rfv "$(pwd)"/scripts/make_grub_efi.sh "$(pwd)"/molecules/scripts/make_grub_efi.sh
chmod +x "$(pwd)"/molecules/scripts/make_grub_efi.sh
molecule specs/spike-pentesting-"${ARCH}"-"${FLAVOR}".spec
sudo rm -rfv '/var/tmp/molecule*'
