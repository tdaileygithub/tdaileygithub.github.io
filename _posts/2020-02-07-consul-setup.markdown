---
title:  "Consul Server Setup"
date:   2020-02-07 20:10:34 -0700
categories: homelab
tags: [hashicorp, consul, go]
---
# Todo 

1. Firewall

# Host Packages

{% highlight bash %}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install git htop make elinks 
{% endhighlight %}

# Go 1.13.7 - Stable

[see](go-release)

# Compile Consul 1.6.3 from source

{% highlight bash %}
mkdir -p $GOPATH/src/github.com/hashicorp 
cd $GOPATH/src/github.com/hashicorp 
git clone https://github.com/hashicorp/consul.git
cd consul
git checkout tags/v1.6.3
make tools
make dev

sudo cp $GOPATH/bin/consul /usr/local/bin
sudo chown root:root /usr/local/bin/consul

which consul
consul --version
{% endhighlight %}

## Consul autocomplete

{% highlight bash %}
consul -autocomplete-install
complete -C /usr/local/bin/consul consul    
{% endhighlight %}

## Consul User

{% highlight bash %}
sudo useradd --system --home /etc/consul.d --shell /bin/false consul
sudo mkdir --parents /opt/consul
sudo chown --recursive consul:consul /opt/consul
{% endhighlight %}

## System D

{% highlight bash %}
sudo touch /etc/systemd/system/consul.service
{% endhighlight %}

{% highlight text %}
[Unit]
Description="HashiCorp Consul - A service mesh solution"
Documentation=https://www.consul.io/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl

[Service]
Type=notify
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/ -bind '{{ GetPrivateInterfaces | include "network" "192.168.200.0/24" | attr "address" }}'
ExecReload=/usr/local/bin/consul reload
KillMode=process
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target    
{% endhighlight %}

## Consul Configurations 

{% highlight bash %}
sudo mkdir --parents /etc/consul.d
sudo touch /etc/consul.d/consul.hcl
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/consul.hcl
{% endhighlight %}

## /etc/consul.d/consul.hcl

generate encrypt with:

{% highlight bash %}
consul keygen
{% endhighlight %}

{% highlight text %}
datacenter = "dc1"
data_dir = "/opt/consul"
encrypt = "xxxx"    

performance {
    raft_multiplier = 1
}    
{% endhighlight %}

## Consul Directories

{% highlight bash %}
sudo mkdir --parents /etc/consul.d
sudo touch /etc/consul.d/server.hcl
sudo chown --recursive consul:consul /etc/consul.d
sudo chmod 640 /etc/consul.d/server.hcl    
{% endhighlight %}

## /etc/consul.d/server.hcl

Replace the bootstrap_expect and retry_join value with the number of Consul servers you will use; three or five is recommended

{% highlight text %}    
server = true
retry_join = ["192.168.200.XX", "192.168.200.YY", "192.168.200.ZZ"]
bootstrap_expect = 3    

enable_syslog = true
log_level = "DEBUG"

leave_on_terminate = true
rejoin_after_leave = true
ui = true
{% endhighlight %}   

## Consul System D
{% highlight bash %}
sudo systemctl enable consul
sudo systemctl start consul
sudo systemctl status consul
{% endhighlight %}

# Consul Debugging

## Consul DNS query

[https://www.consul.io/docs/agent/dns.html]()

By default, Consul will listen on 127.0.0.1:8600 for DNS queries in the consul. domain, without support for further DNS recursion

## DNS Node + Service lookups

{% highlight bash %}
#<node>.node[.datacenter].<domain>
#[tag.]<service>.service[.datacenter].<domain>
dig @127.0.0.1 -p 8600 nomadsrv2.node.dc1.consul. ANY
{% endhighlight %}

## Consul Web UI - Via SSH Tunnel

{% highlight bash %}
ssh -L5555:127.0.0.1:8500 -L5556:192.168.200.10:4646 nomadsrv1
{% endhighlight %}

[http://127.0.0.1:5555/ui/]()