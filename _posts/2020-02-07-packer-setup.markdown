---
title:  "Packer Steup"
date:   2020-02-07 20:10:34 -0700
categories: homelab
tags: [hashicorp, consul, nomad, go]

---
# Todo 

# Host packages

{% highlight bash %}
sudo apt-get update
sudo apt-get upgrade    
sudo apt-get install git htop make elinks 

#make tools 
sudo apt-get install build-essential

{% endhighlight %}

# Go 1.13.7 - Stable

[see](go-release)

# Compile Packer 1.5.2 From Source

{% highlight bash %}
mkdir -p $GOPATH/src/github.com/hashicorp 
cd $GOPATH/src/github.com/hashicorp 
git clone https://github.com/hashicorp/packer.git
cd packer
git checkout tags/v1.5.2

make release

sudo cp $GOPATH/bin/packer /usr/local/bin
{% endhighlight %}

# packer autocomplete

{% highlight bash %}
packer -autocomplete-install
complete -C /usr/local/bin/packer packer
{% endhighlight %}