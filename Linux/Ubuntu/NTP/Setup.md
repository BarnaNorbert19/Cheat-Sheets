# NTP
Rengeteg programnak szüksége van a pontos időre. Mivel az adott host(gép) nem képes megmondani a pontos időt, ezért szükségünk van egy atomórára ami megmondja azt. NTP protokol pontosan ezt csinálja. Ilyen órák gyüjteményét hívjuk ntp pool -nak.
### Poolokat innen lehet válogatni -> https://www.ntppool.org
```
sudo apt-get install ntp ntpdate -y
sudo service ntp stop
sudo ntpdate -B 0.hu.pool.ntp.org
sudo service ntp start
sudo timedatectl set-timezone Europe/Budapest
date
```
