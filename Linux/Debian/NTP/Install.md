# NTP
Rengeteg programnak, protokolnak szüksége van a pontos időre. Mivel az adott host(gép) nem képes megmondani a pontos időt, ezért szükségünk van egy atomórára ami megmondja azt. NTP protokol pontosan ezt csinálja. Ilyen órák gyüjteményét hívjuk ntp pool -nak.
### Poolokat innen lehet válogatni -> https://www.ntppool.org
```
apt-get install ntp ntpdate -y
service ntp stop
ntpdate -B 0.hu.pool.ntp.org
service ntp start
timedatectl set-timezone Europe/Budapest
date
```
