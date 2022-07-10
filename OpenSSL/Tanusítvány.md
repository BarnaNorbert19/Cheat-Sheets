# SSL/TLS
A SSL/TLS protokolok lehetővé teszik, hogy titkosítsuk a szerver és a kliens közötti kommunikációt. Az SSL-t 1999-ben leváltotta a TLS, de a mai napig SSL vagy SSL/TLS tanusítványként referálunk rá. Jelenleg az 1.3 as TLS verzió a legfrissebb.
## 1. Private Key
After the```-out``` parameter, we need to specify the location where we want to save the private key
```
openssl genrsa -aes256 -out ca-key.pem 4096
```
We need to enter a passphrase afterwards, which we going to use later on
## 2. Public key
X.509 is an ITU standard defining the format of public key certificates
Before the```-key```we need to provide the private key that we just generated
```
openssl req -new -x509 -sha256 -days 3650 -key ca-key.pem -out ca.pem
```
It is going to ask for the passphrase, then (optionaly) we fill out the infomation we are asked for
