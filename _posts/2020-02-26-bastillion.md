---
title:  "Bastllion"
date:   2020-02-26 20:10:34 -0700
categories: homelab
tags: [homelab, ssh]

---
# Overview

[https://github.com/bastillion-io/Bastillion]()

![terminals]({{ site.url }}/assets/images/bastillion.png)

Web Based SSH Access.

**External Access Concept:**

- Users connect through pfsense on :22 through haproxy to fabio "bastion" service and into the virtual machine.
- Ideally this would be connected to Microsoft Azure AD in the cloud and 2FA with authy.

Very nice.  Online in < 5 minutes.

# Todo / Explore

1. Firewall
2. Compile from source?
3. Packer Build
4. Production Lockdown
5. Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files
   1. use256EncryptionKey=true
6. AD connection with - jaasModule??
7. jdbc:h2:keydb/bastillion;CIPHER=AES;  replace with actual database?
8. Figure out REST API for integrating into pipeline

# Host packages

{% highlight bash %}
sudo apt-get update
sudo apt-get upgrade    
sudo apt-get install htop openjdk-11-jdk
{% endhighlight %}

# Install
{% highlight bash %}
cd ~/
wget https://github.com/bastillion-io/Bastillion/releases/download/v3.09.00/bastillion-jetty-v3.09_00.tar.gz
sudo tar xfz bastillion-jetty-v3.09_00.tar.gz -C /opt
echo JETTY_HOME=/opt/Bastillion-jetty/jetty | sudo tee -a /etc/default/bastillion
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/bin
export PATH=$JAVA_HOME/bin:$PATH
./startBastillion.sh
{% endhighlight %}

# Systemd
{% highlight text %}
[Unit]
Description="Bastillion"
Documentation=https://www.bastillion.io/docs/installation/service/
Requires=network-online.target
After=network-online.target

[Service]
Type=forking
Environment="JETTY_HOME=/opt/Bastillion-jetty/jetty"
Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/bin"
ExecStart=/etc/init.d/bastillion -d start
ExecStop=/etc/init.d/bastillion stop
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
{% endhighlight %}

# Java Config File 

WEB-INF/classes/BastillionConfig.properties

/opt/Bastillion-jetty/jetty/bastillion/WEB-INF/classes/BastillionConfig.properties

# View

https://127.0.0.1:8443

- username:admin
- password:changeme