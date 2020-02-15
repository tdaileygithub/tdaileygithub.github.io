---
title:  "Nomad Server Setup"
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

# Host packages

{% highlight bash %}
sudo apt-get update
sudo apt-get upgrade    
sudo apt-get install git htop make elinks 
{% endhighlight %}

{% highlight bash %}
sudo apt install docker.io
sudo systemctl enable docker

#make tools need for nomad
sudo apt-get install build-essential

#node,npm,yarn needed for nomad web ui
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update
sudo apt-get install npm yarn
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

# /etc/nomad.d/server.hcl

{% highlight bash %}
sudo touch /etc/nomad.d/server.hcl
{% endhighlight %}

{% highlight text %}
data_dir  = "/var/lib/nomad"

bind_addr = "192.168.200.10" 

##advertise {
#  # Defaults to the first private IP address.
#  http = "192.168.200.XX"
#  rpc  = "192.168.200.YY"
#  serf = "192.168.200.ZZ:5648" 
#}

server {
    enabled = true
    bootstrap_expect = 3
}

#consul {
#  address = "127.0.0.1:8500"
#}

#defaults
consul {
    address             = "127.0.0.1:8500"
    server_service_name = "nomad"
    client_service_name = "nomad-client"
    auto_advertise      = true
    server_auto_join    = true
    client_auto_join    = true
}
{% endhighlight %}

# System D

{% highlight bash %}
sudo systemctl enable nomad
sudo systemctl start nomad
sudo systemctl status nomad
{% endhighlight %}

# Web UI

{% highlight bash %}
ssh -L5555:127.0.0.1:8500 -L5556:192.168.200.10:4646 nomadsrv1
{% endhighlight %}

- [http://127.0.0.1:5555/ui/]()
- [http://127.0.0.1:5556/ui/]()

# Force Garbage Collect
{% highlight bash %}
curl -X PUT http://localhost:4646/v1/system/gc
{% endhighlight %}