# Install NTP
Poolokat innen lehet válogatni -> https://www.ntppool.org
```
sudo apt-get install ntp ntpdate -y
sudo service ntp stop
sudo ntpdate -B 0.hu.pool.ntp.org
sudo service ntp start
sudo timedatectl set-timezone Europe/Budapest
date
```
