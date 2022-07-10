# Weboldal mappájának létrehozása
Ebben a mappában lesz tárolva az összes source file a weboldalhoz (.html, .css, képek, stb.). `-p` létrehoz minden szükséges parent mappát.
```
mkdir -p /var/www/weboldal.com
```
# Alap oldal
Hozzunk létre egy `index.html` fájlt a weboldal mappáján belűl és írjunk bele valamit.
```
nano /var/www/weboldal.com/index.html
```
# Oldal config fájlja
Miden oldalnak kell legyen egy `.conf` kiterjesztésű fájlja a `/etc/apache2/sites-available` directoryban (ez a gyűjtőhelye ezen fájloknak). Nevéből adódóan az oldal beállításait tudjuk módosítani vele. Az egyszerűség kedvéért, másoljuk át az alap weboldal config fájlját és szerkesszük azt.
```
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/weboldal.com.conf
```
```
nano /etc/apache2/sites-available/weboldal.com.conf
```
#### Itt több dolgot is érdemes módosítani
##### `VirtualHost *:80` - `*` jelöli kit szolgál ki (jelen esetben *, tehát midenkit), és milyen porton.
##### `ServerAdmin` - nem szükséges az oldal működéséhez, ha megadjuk PHP-ba enviromental változoként elérhető lesz `$_SERVER['SERVER_ADMIN'] `.
##### `ServerName` - fontos, ez lesz az azonosítója a weboldalnak. Ha egyetlen szervert hosztolunk elengedhető de akkor sem ajánlott, mert ha nincs megadva ServerName, az Apache megpróbálja a server IP-je alapján kitalálni azt.
##### `ServerAlias` - Alternatív név, nem muszáj. www. kezdődésű domain név variációt majdnem mindíg ide írjuk.
##### `DocumentRoot` - Elengedhetetlen, a soruce fájlok mappájára mutat.
# Weboldal engedélyezése, alap weboldal tiltása
```
a2ensite weboldal.com.conf
```
```
a2dissite 000-default.conf
```
Indítsuk újra az apachet
```
systemctl restart apache2
```
Ha nem akarjuk a már működő weboldalakat is újraindítani
```
/etc/init.d/httpd reload
```
