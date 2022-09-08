# Install NTP
Poolokat innen lehet válogatni -> https://www.ntppool.org
```
apt-get install ntp ntpdate -y
service ntp stop
ntpdate -B 0.hu.pool.ntp.org
service ntp start
timedatectl set-timezone Europe/Budapest
date
```
