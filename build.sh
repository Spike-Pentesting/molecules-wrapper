export SABAYON_MOLECULE_HOME=$(pwd)"/molecules"
export SABAYON_RELEASE="1.0"


if [ -d "${SABAYON_MOLECULE_HOME}" ]; then
    cd "${SABAYON_MOLECULE_HOME}"
    git pull
    cd ..
else
    git clone https://github.com/Sabayon/molecules
fi
ARCH="${1}"
export ISO_TAG="${2}" #14.05, DAILY
export BASE_VERSION="${3}" #Minimal, SpinBase
FLAVOR="${4}"

"$(pwd)"/wrap.pl
molecule specs/spike-pentesting-"${ARCH}"-"${FLAVOR}".spec
sudo rm -rfv '/var/tmp/molecule*'