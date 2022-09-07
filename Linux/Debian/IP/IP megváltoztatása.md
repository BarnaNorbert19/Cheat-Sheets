# IP megváltoztatása
Debian alapértelmezetten DHCP-ről kapja az ip-t, ezeket az információkat egy fájlban tárolja, tehát szimplán csak meg kell változtatnunk azt.
```
nano /etc/network/interfaces 
```
Valami ilyesmit fogunk látni:
```
allow-hotplug enp0s5
iface enp0s5 inet dhcp
```
`inet dhcp` át kell írni `inet static` -ra és kiegészíteni a következővel:
```
address 192.168.1.1/24
network 192.168.1.0
gateway 192.168.1.254
dns-nameservers 192.168.1.1 8.8.8.8
dns-search domain.nev
```
Tehát valahogy így kell kinézzen:
```
# The loopback network interface
auto lo
iface lo inet loopback
 
# The primary network interface
auto enp0s5
iface enp0s5  inet static
address 192.168.1.1/24
network 192.168.1.0
gateway 192.168.1.254
dns-nameservers 192.168.1.1 8.8.8.8
dns-search domain.nev
```
