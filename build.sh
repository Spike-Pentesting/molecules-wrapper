export SABAYON_MOLECULE_HOME=$(pwd)"/molecules"
export SABAYON_RELEASE="1.0"
export ISO_TAG="14.05"
molecule specs/spike-pentesting-86.spec
molecule specs/spike-pentesting-64.spec
