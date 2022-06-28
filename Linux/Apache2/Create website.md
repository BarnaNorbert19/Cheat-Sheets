# Install NTP
```
apt-get install ntp ntpdate -y
```
#Configure
Stop ntp
```
service ntp stop
```
Set ntp server -> https://www.pool.ntp.org
```
ntpdate -B 0.hu.pool.ntp.org
```
Start ntp
```
service ntp start
```
Set timezone
```
timedatectl set-timezone Europe/Budapest
```
Test
```
date
```
