## Ubuntu netplan-t használ alapértelmezetten.
```
sudo nano /etc/netplan/00-installer-config.yaml
```
## Példa config
```
network:
  ethernets:
    ens33:
      addresses:
      - 192.168.1.50/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
        - 192.168.1.50
        - 192.168.1.1
        search:
        - home.local
  version: 2
```

## Nem kell restart
```
sudo netplan apply
```
