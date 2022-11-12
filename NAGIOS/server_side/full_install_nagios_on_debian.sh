# Install the necessary applications
apt update
apt install vim wget curl build-essential unzip openssl libssl-dev apache2 php libapache2-mod-php php-gd libgd-dev ufw -y
# Access home from root /root
cd ~
# Download compressed nagios
wget https://github.com/NagiosEnterprises/nagioscore/releases/download/nagios-4.4.6/nagios-4.4.6.tar.gz
# unzip the file
tar xvzf nagios-4.4.6.tar.gz
# Access the unzipped directory
cd nagios-4.4.6
# run command
./configure --with-httpd-conf=/etc/apache2/sites-enabled
# Run the commands to install Nagios
make install-groups-users
usermod -a -G nagios www-data
make all
make install
make install-daemoninit
make install-commandmode
make install-config
make install-webconf
a2enmod rewrite cgi

chown www-data:www-data /usr/local/nagios/etc/htpasswd.users
chmod 640 /usr/local/nagios/etc/htpasswd.users

# Install the necessary plugins
cd ~
wget https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.3.3/nagios-plugins-2.3.3.tar.gz
tar xvf nagios-plugins-2.3.3.tar.gz
cd nagios-plugins-2.3.3
# run command
./configure --with-nagios-user=nagios --with-nagios-group=nagios
# Run the commands to install the plugins
make
make install
ufw allow 80
ufw reload
systemctl restart apache2
systemctl start nagios.service

