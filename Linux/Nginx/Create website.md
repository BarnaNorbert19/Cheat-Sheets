# 1. Create the directory for the website (this is where the source files will be stored)
The -p flag tells mkdir to create any necessary parent directories along the way.
```
sudo mkdir -p /var/www/$PAGE.NAME$/html
```
Change owner if necessary
```
sudo chown -R $USER$ /var/www/$PAGE.NAME$/html
```
# 2. Creating Sample Page
```
nano /var/www/$PAGE.NAME$/html/index.html
```
```html
<html>
    <head>
        <title>Welcome to $PAGE.NAME$!</title>
    </head>
    <body>
        <h1>Success! The $PAGE.NAME$ server block is working!</h1>
    </body>
</html>
```
# 3. Creating Server Block Files
Create our server block config file by copying over the default file
```
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/$PAGE.NAME$
sudo nano /etc/nginx/sites-available/$PAGE.NAME$
```
Remove <b style='color: #eb0000'>default_server</b> if we don't intend to use it as a default site (there can be only one default_server website)
```
server {
        listen 80 default_server;
        listen [::]:8080 default_server;

        . . .
}
```
We need to specify the root (the source files containing) folder
```
server {
        listen 80;
        listen [::]:80;

        root /var/www/$PAGE.NAME$/html;

}
```
Specify the server name (domain name)
```
server {
        listen 80;
        listen [::]:80;

        root /var/www/$PAGE.NAME$/html;
        index index.html index.htm index.nginx-debian.html;

        server_name example.com $PAGE.NAME$;

        location / {
                try_files $uri $uri/ =404;
        }
}
```
#### 4. Enable site
```
sudo ln -s /etc/nginx/sites-available/$PAGE.NAME$ /etc/nginx/sites-enabled/
```
#### 5. Enable hash bucket
In order to avoid a possible hash bucket memory problem that can arise from adding additional server names, we will also adjust a single value within our /etc/nginx/nginx.conf file.
```
sudo nano /etc/nginx/nginx.conf
```
Within the file, find the server_names_hash_bucket_size directive. Remove the ```#``` symbol to uncomment the line
```
http {
    . . .

    server_names_hash_bucket_size 64;

    . . .
}
```
Test to make sure that there are no syntax errors in any of your Nginx files
```
sudo nginx -t
```
If no problems were found, restart Nginx to enable your changes
```
sudo systemctl restart nginx
```
