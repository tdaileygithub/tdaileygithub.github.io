---
title: "TPLink HS110 Power Monitoring with Emoncms and pyHS100"  
date:   2018-10-31 20:10:34 -0700
categories: powermonitor
---

# Links
- [https://www.softscheck.com/en/reverse-engineering-tp-link-hs110/]()
- [https://github.com/GadgetReactor/pyHS100]()

![emoncms app](/assets/images/emoncms_app.JPG)
![emoncms dashboard](/assets/images/emoncms_dashboard.JPG)

Took around 2 hours to get the plugs out of their box, setup a vm with emoncms, connect them up, and setup a cron.

The dashboard layout is in flux but emoncms seems to have sufficient default charts.

# Install Emoncms Prereqs
{% highlight bash %}
sudo apt-get install -y apache2 mysql-server mysql-client php libapache2-mod-php php-mysql php-curl php-pear php-dev php-mcrypt php-json git-core redis-server build-essential
{% endhighlight %}

## mysql installation
{% highlight bash %}
sudo mysql_secure_installation
sudo mysqld --initialize
sudo mysqladmin -p -u root version

sudo mysql -u root -p
CREATE DATABASE emoncms DEFAULT CHARACTER SET utf8;
CREATE USER 'emoncms'@'localhost' IDENTIFIED BY 'YOUR_SECURE_PASSWORD_HERE';
GRANT ALL ON emoncms.* TO 'emoncms'@'localhost';
flush privileges;
exit
{% endhighlight %}	

## apache and php configuration
{% highlight bash %}
sudo pear channel-discover pear.swiftmailer.org
sudo pecl install swift/swift redis
printf "extension=redis.so" | sudo tee /etc/php/7.0/mods-available/redis.ini 1>&2

sudo phpenmod redis
sudo a2enmod rewrite
sudo cat <<EOF >> /etc/apache2/sites-available/emoncms.conf
	<Directory /var/www/html/emoncms>
	    Options FollowSymLinks
	    AllowOverride All
	    DirectoryIndex index.php
	    Order allow,deny
	    Allow from all
	</Directory>
	EOF
echo 'ServerName localhost' | sudo tee -a /etc/apache2/apache2.conf
sudo a2ensite emoncms
sudo service apache2 reload

cd /var/www/
sudo chown $USER html
cd html
git clone -b stable https://github.com/emoncms/emoncms.git
cd /var/www/html/emoncms
git pull

sudo mkdir /var/lib/phpfiwa
sudo mkdir /var/lib/phpfina
sudo mkdir /var/lib/phptimeseries

sudo chown www-data:root /var/lib/phpfiwa
sudo chown www-data:root /var/lib/phpfina
sudo chown www-data:root /var/lib/phptimeseries

cd /var/www/html/emoncms/Modules
git clone https://github.com/emoncms/dashboard.git
git clone https://github.com/emoncms/app.git
	
sudo touch /var/log/emoncms.log
sudo chmod 666 /var/log/emoncms.log
{% endhighlight %}	

## emoncms configuration
{% highlight bash %}
cd /var/www/html/emoncms/
cp default.settings.php settings.php

nano settings.php
$username = "emoncms";
$password = "YOUR_SECURE_PASSWORD_HERE";
$server   = "localhost";
$database = "emoncms";

elinks http://localhost/emoncms/
{% endhighlight %}

# pyHS100 Preqs
{% highlight bash %}
sudo apt-get install -y python3 python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install pyHS100
sudo pip3 install httplib2
{% endhighlight %}

## pyHS100 emoncms script
{% highlight bash %}
sudo mkdir -p /opt/poewrmon
sudo chown $USER:$USER /opt/poewrmon
{% endhighlight %}

{% highlight python %}
from pyHS100 import Discover
import requests
import json

EMONCMS_APIKEY='xxx'
for dev in Discover.discover().values():

    headers = {}
    emeter = dev.get_emeter_realtime()
    name = dev.alias
    current = emeter['current']
    total = emeter['total']
    voltage = emeter['voltage']
    power = emeter['power']

    data_payload = [voltage,current,power,total]
    payload = dict(node='{}'.format(dev.alias),
                   data=json.dumps(data_payload),
                   apikey='{}'.format(EMONCMS_APIKEY))

    #print ('{} : {} : {} : {}'.format(name, current,voltage,total))

    res = requests.post("http://127.0.0.1/emoncms/input/post",
                        data=payload,
                        headers=headers)
    print (res)

{% endhighlight %}

## Crontab -e
{% highlight bash %}
* * * * * /usr/bin/python3 /opt/powermon/main.py

sudo systemctl enable cron
sudo systemctl restart cron
{% endhighlight %}