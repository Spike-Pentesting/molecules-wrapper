#echo '192.99.32.76 repository.spike-pentesting.org' >>/etc/hosts

echo '[spike]
desc = Spike Pentesting Sabayon Repository
repo = http://repository.spike-pentesting.org#bz2
enabled = true
pkg = http://repository.spike-pentesting.org
' >> /etc/entropy/repositories.conf.d/entropy_spike

export ACCEPT_LICENSE="*"
