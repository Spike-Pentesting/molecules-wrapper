export SABAYON_MOLECULE_HOME=$(pwd)"/molecules"
export SABAYON_RELEASE="1.0"
export ISO_TAG="14.05"

if [ -d "${SABAYON_MOLECULE_HOME}" ]; then
    cd "${SABAYON_MOLECULE_HOME}"
    git pull
    cd ..
else
    git clone https://github.com/Sabayon/molecules
fi
ARCH="${1}"
molecule specs/spike-pentesting-"${ARCH}".spec
