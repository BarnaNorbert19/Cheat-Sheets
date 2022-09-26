#!/bin/sh
read -p "REALM (pl. test.hu): " realm
read -p "Admin password: " admin_pass

ip_addr=$(hostname -I | cut -d' ' -f1)
def_gateway=$(/sbin/ip route | awk '/default/ { print $3 }')

> /etc/resolv.conf
printf "domain $realm \nsearch $realm \nnameserver $ip_addr \nnameserver $def_gateway" >> /etc/resolv.conf

line_nr=$(awk "/$HOSTNAME/{print NR}" /etc/hosts)
sed -i "${line_nr}s/.*/$ip_addr$(printf "\t")$HOSTNAME $HOSTNAME.$realm/" /etc/hosts

apt-get update
apt-get clean
apt-get install samba winbind smbclient debconf-utils -y

echo "krb5-config krb5-config/add_servers boolean true" | debconf-set-selections
echo "krb5-config krb5-config/add_servers_realm string ${realm^h}" | debconf-set-selections
echo "krb5-config krb5-config/default_realm string ${realm^h}" | debconf-set-selections
echo "krb5-config krb5-config/read_conf boolean true" | debconf-set-selections
echo "krb5-config krb5-config/kerberos_servers string $HOSTNAME" | debconf-set-selections
echo "krb5-config krb5-config/default_realm string $HOSTNAME.${realm^h}" | debconf-set-selections

DEBIAN_FRONTEND=noninteractive apt-get install krb5-config -y

systemctl stop samba-ad-dc.service smbd.service nmbd.service winbind.service
systemctl disable samba-ad-dc.service smbd.service nmbd.service winbind.service

mv /etc/samba/smb.conf /etc/samba/smb.conf.original
mv /etc/krb5.conf /etc/krb5.conf.original
ln -sf /var/lib/samba/private/krb5.conf /etc/krb5.conf

domain=$(echo "$realm" | cut -d'.' -f1) # first half of the realm -> $realm=test.hu -> $domain=test

samba-tool domain provision --use-rfc2307 \
--realm=${realm^^} \
--domain=${domain^^} \
--server-role=dc \
--dns-backend=SAMBA_INTERNAL \
--adminpass $admin_pass

systemctl unmask samba-ad-dc.service
systemctl start samba-ad-dc.service
systemctl enable samba-ad-dc.service
