---
title:  "Nomad Gitlab"
date:   2020-02-07 20:10:34 -0700
categories: homelab
tags: [nomad, gitlab]
---
# Overview

Gitlab CE can do private repo hosting AND docker container registry.

This will allow the nomad units to pull images from a LAN private registry.

# Todo 

1. Specific version of docker -- maybe docker?
2. Firewall
3. Ansible playbook / Packer Script

# Host packages

{% highlight bash %}
sudo apt-get update
sudo apt-get upgrade    
sudo apt-get install git htop make elinks 

sudo apt-get install -y curl openssh-server ca-certificates
sudo apt-get install -y postfix

sudo apt install docker.io
sudo systemctl enable docker
sudo usermod -aG docker $USER

# prod warning - pipe to sudo bash
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo EXTERNAL_URL="https://127.0.0.1" apt-get install gitlab-ce
{% endhighlight %}

# Gitlab runner - Fail

omg... no quick support for self sign in runner registration....!!!

jenkins time!

{% highlight bash %}
wget https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb
sudo dpkg -i gitlab-runner_amd64.deb
sudo systemctl enable gitlab-runner
{% endhighlight %}

# ssh tunnel
{% highlight bash %}
sudo ssh -L 5050:192.168.200.101:5050 -L 5558:192.168.200.101:22 -L443:192.168.200.101:443 tdailey@nomadgitlab
{% endhighlight %}