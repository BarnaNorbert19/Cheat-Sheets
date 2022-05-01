# Certificates 
It doesen't metter where you use these commands as long as you have openssl
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
