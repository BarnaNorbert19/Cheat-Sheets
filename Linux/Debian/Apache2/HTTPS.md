# Tanusítvány
Self signed (Részletes leírás) -> [Itt](https://github.com/BarnaNorbert19/Notes/blob/main/OpenSSL/Tanusítvány.md "Itt")
# Confing fájl
`VirtualHost *:80 `-ról átírjuk`VirtualHost *:443 `-ra
#### A következőt pedig hozzáadjuk a confighoz
```
SSLEngine on
SSLCertificateFile /etc/apache2/certificate/apache-certificate.crt
SSLCertificateKeyFile /etc/apache2/certificate/apache.key
```
Tehát valahogy így fog kinézni
```
<VirtualHost *:443>
        ServerAdmin admin@admin
        DocumentRoot /var/www/weboldal.com
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        SSLEngine on
        SSLCertificateFile /etc/apache2/certificate/apache-certificate.crt
        SSLCertificateKeyFile /etc/apache2/certificate/apache.key
</VirtualHost>
```
#### SSL modúl elindítása
```
a2enmod ssl
```
Apache restart
```
systemctl reload apache2
```
