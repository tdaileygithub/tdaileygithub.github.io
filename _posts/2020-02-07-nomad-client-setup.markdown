---
title:  "Nomad Client Setup"
date:   2020-02-07 20:10:34 -0700
categories: homelab
tags: [hashicorp, consul, nomad, go]

---
# Todo 

1. Specific version of docker -- maybe nvidia-docker?
2. Nomad requires Docker to be installed with the nomad agent. 
3. Nomad was developed against Docker 1.8.2 and 1.9.
4. Firewall
5. Ansible playbook / Packer Script
6. Is the qemu vm disk downloaded temporary/copy?  How can it be network attached?

## Ponder

If the client nodes themselves are virtual machines everything could be a image.

Then the only setup that would be "manual" would be a proxmox cluster or the esxi setup.

If nomad can handle failing over vms when they crash a cluster of single node esx-i hosts with all vms running as nomad service jobs might be the poor-man, extermely simple, "HA enough" setup if the vm disk images are stored on ceph, gluster, minio, etc.

# Host packages

{% highlight bash %}
sudo apt-get update
sudo apt-get upgrade    
sudo apt-get install git htop make elinks 

sudo apt install docker.io
sudo systemctl enable docker
sudo usermod -aG docker $USER

#make tools need for nomad
sudo apt-get install build-essential

#node,npm,yarn needed for nomad web ui
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install npm yarn

#qemu and kvm
sudo apt install qemu qemu-kvm libvirt-bin  bridge-utils  virt-manager uml-utilities
{% endhighlight %}

# Go 1.13.7 - Stable

[see](go-release)

# Compile Nomad v0.10.3 From Source

{% highlight bash %}
mkdir -p $GOPATH/src/github.com/hashicorp 
cd $GOPATH/src/github.com/hashicorp 
git clone https://github.com/hashicorp/nomad.git
cd nomad
git checkout tags/v0.10.3

make bootstrap
make dev-ui

sudo cp $GOPATH/bin/nomad /usr/local/bin
{% endhighlight %}

# nomad autocomplete

{% highlight bash %}
nomad -autocomplete-install
complete -C /usr/local/bin/nomad nomad
{% endhighlight %}

# System D

[https://github.com/hashicorp/nomad/blob/master/dist/systemd/nomad.service]()

{% highlight bash %}
sudo touch /etc/systemd/system/nomad.service
{% endhighlight %}

{% highlight text %}
[Unit]
Description=Nomad
Documentation=https://nomadproject.io/docs/
Wants=network-online.target
After=network-online.target

# When using Nomad with Consul it is not necessary to start Consul first. These
# lines start Consul before Nomad as an optimization to avoid Nomad logging
# that Consul is unavailable at startup.
#Wants=consul.service
#After=consul.service

[Service]
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/nomad agent -config /etc/nomad.d
KillMode=process
KillSignal=SIGINT
LimitNOFILE=65536
LimitNPROC=infinity
Restart=on-failure
RestartSec=2
StartLimitBurst=3
StartLimitIntervalSec=10
TasksMax=infinity
OOMScoreAdjust=-1000

[Install]
WantedBy=multi-user.target
{% endhighlight %}    

# Nomad Directory

{% highlight bash %}
sudo mkdir --parents /etc/nomad.d
sudo chmod 700 /etc/nomad.d
sudo touch /etc/nomad.d/nomad.hcl
{% endhighlight %}

# /etc/nomad.d/nomad.hcl

{% highlight text %}
datacenter = "dc1"
data_dir = "/opt/nomad"
enable_syslog = true
log_level = "DEBUG"
{% endhighlight %}

# /etc/nomad.d/client.hcl

{% highlight bash %}
sudo touch /etc/nomad.d/client.hcl
{% endhighlight %}

{% highlight text %}
client {
    enabled = true

    server_join {
        retry_join = [ "192.168.200.XX", "192.168.200.YY", "192.168.200.ZZ" ]
        retry_max = 3
        retry_interval = "15s"
    }
    
    #options = {
    #    "driver.whitelist" = "docker",
    #    "user.blacklist" = "root,ubuntu"
    #}

    #reserved {
    #    cpu            = 500
    #    memory         = 512
    #    disk           = 1024
    #    reserved_ports = "22,80,8500-8600"
    #}
}
{% endhighlight %}

# System D

{% highlight bash %}
sudo systemctl enable nomad
sudo systemctl start nomad
sudo systemctl status nomad
{% endhighlight %}

# libvirtd

{% highlight bash %}
sudo service libvirtd start
sudo update-rc.d libvirtd enable
sudo adduser username libvirt
sudo adduser username libvirt-qemu

#https://bugs.launchpad.net/qemu/+bug/1661386
{% endhighlight %}

## kvm module permission
#https://bugzilla.redhat.com/show_bug.cgi?id=1479558
sudo chmod 666 /dev/kvm

{% highlight bash %}
sudo chmod 666 /dev/kvm

/lib/udev/rules.d/99-kvm.rules 
KERNEL=="kvm", GROUP="kvm", MODE="0666"
{% endhighlight %}

# fabio 1.5.13

{% highlight bash %}

mkdir -p $GOPATH/src/github.com/fabiolb 
cd $GOPATH/src/github.com/fabiolb
#git clone https://github.com/fabiolb/fabiolb.git
wget https://github.com/fabiolb/fabio/archive/v1.5.13.zip
unzip v1.5.13.zip
cd fabiolb-1.5.13
#git checkout tags/v1.5.13

make build
make install
sudo cp $GOPATH/bin/fabio /usr/local/bin
{% endhighlight %}

{% highlight bash %}
sudo mkdir --parents /etc/fabio
sudo chmod 700 /etc/fabio
sudo touch /etc/fabio/fabio.properties
{% endhighlight %}

{% highlight bash %}
mkdir -p /etc/fabio
useradd -M -d /etc/fabio -s /sbin/nologin fabio
{% endhighlight %}

/etc/fabio/fabio.properties

{% highlight text %}
# These two lines are example of running fabio with HTTPS 
# certificates#proxy.cs = cs=lb;type=file;cert=/opt/fabio/certs.d/mydomain_com.ca-bundle.crt;key=/opt/fabio/certs.d/mydomain_com.key
# proxy.addr = :443;cs=lb;tlsmin=tls11;tlsmax=tls12;tlsciphers="0xc02f,0x9f,0xc030,0xc028,0xc014,0x6b,0x39,0x009d,0x0035",#:80

proxy.addr = :9999
proxy.header.tls = Strict-Transport-Security
proxy.header.tls.value = "max-age=63072000; includeSubDomains"

ui.addr = 127.0.0.1:9998
ui.access = ro

runtime.gogc = 800

log.access.target = stdout
log.access.format =  - - [] ""   ".Referer" ".User-Agent" "" "" "" ""
log.access.level = INFO

registry.consul.addr = 127.0.0.1:8500
proxy.maxconn = 20000
{% endhighlight %}

# /etc/systemd/system/fabio.service

{% highlight text %}
[Unit]
Description=Fabio Proxy
After=syslog.target
After=network.target
 
[Service]
LimitMEMLOCK=infinity
LimitNOFILE=65535
 
Type=simple
WorkingDirectory=/etc/fabio
Restart=always
ExecStart=/usr/local/bin/fabio -cfg fabio.properties
 
# Log to syslog with identifier for syslog to process
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=fabio
 
# No need that fabio messes with /dev
PrivateDevices=yes
 
# Dedicated /tmp
PrivateTmp=yes
 
# Make /usr, /boot, /etc read only
ProtectSystem=full
 
# /home is not accessible at all
ProtectHome=yes
 
# You will have to run “setcap ‘cap_net_bind_service=+ep’ /opt/fabio/bin/fabio”
# to be able to bind ports under 1024. This directive allows it to happen:
AmbientCapabilities=CAP_NET_BIND_SERVICE
 
# Only ipv4, ipv6, unix socket and netlink networking is possible
# Netlink is necessary so that fabio can list available IPs on startup
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK
 
# Unprivileged user
User=fabio
Group=fabio
 
[Install]
WantedBy=multi-user.target

{% endhighlight %}


## Enable vmware performance counters
[https://github.com/kubernetes/minikube/issues/2968]()


# Web UI

The client will now appear on the nomad page.

Jobs can be submitted.

{% highlight bash %}
ssh -L5555:127.0.0.1:8500 -L9998:127.0.0.1:9998 -L5556:192.168.200.10:4646 nomadsrv1
{% endhighlight %}

- [http://127.0.0.1:5555/ui/]()
- [http://127.0.0.1:5556/ui/]()
- [http://127.0.0.1:9998/routes]()