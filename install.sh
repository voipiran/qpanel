#!/bin/bash
echo "Install voipiran Queue Panel"
echo "VOIPIRAN.io"
echo "VOIPIRAN Queue Panel Version 1.0"
sleep 1

#echo "------------START-----------------"
#echo "Install sourceguardian Files"
#echo "------------Copy SourceGaurd-----------------"
#yes | cp -rf sourceguardian/ixed.5.4.lin /usr/lib64/php/modules
#yes | cp -rf sourceguardian/ixed.5.4ts.lin /usr/lib64/php/modules
##yes | cp -rf /etc/php.ini /etc/php-old.ini
#yes | cp -rf sourceguardian/php.ini /etc
#echo "SourceGuardian Files have Moved Sucsessfully"
#sleep 1

echo "Install viservey Mysql DataBase"
echo "------------Create DB-----------------"
#echo -n "Enter the MySQL root password: "
#read rootpw

###Install Dependencies
#yum install -y git python-virtualenv swig mod_wsgi python3 python-pip npm

###Install Panel
cd /var/www/html
git clone https://github.com/voipiran/panel.git
cd panel/

#pip3 install flask
pip3 install -r requirements.txt

#npm install -g npm@8.17.0 
npm install
cp samples/configs/site-apache2-wsgi.conf /etc/httpd/conf.d/qpanel.conf
pybabel compile -d qpanel/translations
python3 app.py


# httpd apache
if ! [ -f "/etc/httpd/conf.d/qpanel.conf" ]; then
echo '
Alias /qpanel/static /opt/qpanel/qpanel/static
<Directory /opt/qpanel/qpanel/static>
    Require all granted
</Directory>

WSGIScriptAlias /qpanel /opt/qpanel/start.wsgi
WSGIScriptReloading On

<Directory /opt/qpanel>
    Order deny,allow
    Allow from all

   <Files start.wsgi>
        Require all granted
    </Files>

</Directory>


' > /etc/httpd/conf.d/qpanel.conf

service httpd restart

echo "-----------FINISHED (voipiran.io)-----------"

