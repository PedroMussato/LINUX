# INSTALL REQUIRED APPS
apt install -y autoconf automake gcc libc6 libmcrypt-dev make libssl-dev wget openssl

# CREATE AND ACCESS DIRECTORY FOR INSTALLING NRPE
mkdir /opt/nrpe
cd /opt/nrpe

# DOWNLOAD THE PLUGINS UNCOMPRESS AND ACCESS THE DIRECTORY
wget http://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
gunzip -c nagios-plugins-2.2.1.tar.gz | tar xf -
cd nagios-plugins-2.2.1

# PERFORM THE INSTALLATION PROCEDURE
./configure
make
make install
useradd nagios
groupadd nagios
usermod -a -G nagios nagios
chown nagios.nagios /usr/local/nagios
chown -R nagios.nagios /usr/local/nagios/libexec

# DOWNLOAD THE NRPE IN THE /opt/nrpe DIRECTORY AND ACCESS THE DIRECTORY
cd ..
wget https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-3.2.1/nrpe-3.2.1.tar.gz
tar xzf nrpe-3.2.1.tar.gz
cd nrpe-3.2.1

# PERFORM THE INSTALLATION
./configure
make all
make install-groups-users
make install
make install-config
make install-inetd
make install-init

# ENABLE AND START NRPE
systemctl enable nrpe
systemctl start nrpe
