---
title:  "Nomad Jenkins"
date:   2020-02-07 20:10:34 -0700
categories: homelab
tags: [nomad, gitlab]
---
# Overview

Gitlab CE can do private repo hosting AND docker container registry.

However, it's pipeline does not play nicely with self signed and it is not straight forward

# Todo 

1. Specific version of docker -- maybe docker?
2. docker-compose
3. Firewall
4. HTTPS
5. Ansible playbook / Packer Script

# Host package Deps

Docker added to build images and push them to gitlab

{% highlight bash %}
sudo apt-get update
sudo apt-get upgrade    
sudo apt-get install git htop make elinks 

sudo apt-get install -y curl openssh-server ca-certificates
sudo apt-get install -y postfix

sudo apt install docker.io
sudo systemctl enable docker
sudo usermod -aG docker $USER
{% endhighlight %}

# Jenkins

{% highlight bash %}
sudo apt install default-jdk-headless

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins
sudo systemctl enable jenkins
{% endhighlight %}