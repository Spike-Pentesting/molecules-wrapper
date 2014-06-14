#echo '192.99.32.76 repository.spike-pentesting.org' >>/etc/hosts

echo '[spike]
desc = Spike Pentesting Sabayon Repository
repo = http://repository.spike-pentesting.org#bz2
enabled = true
pkg = http://repository.spike-pentesting.org
' >> /etc/entropy/repositories.conf.d/spike

#echo "*" > /etc/entropy/packages/license.accept
cp -rfv /etc/portage/make.conf /etc/portage/make.conf.bak
echo "ACCEPT_LICENSE='*'" >> /etc/portage/make.conf