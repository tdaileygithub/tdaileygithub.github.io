---
title:  "Go Lang - From Release"
date:   2020-02-07 20:10:34 -0700
categories: consul
---

# Download Binary & Install /usr/local
{% highlight bash %}
cd ~/
curl -O https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz

sha256sum go1.13.7.linux-amd64.tar.gz
#b3dd4bd781a0271b33168e627f7f43886b4c5d1c794a4015abf34e99c6526ca3

tar xvf go1.13.7.linux-amd64.tar.gz

sudo chown -R root:root ./go
sudo mv go /usr/local
{% endhighlight %}

## ~/.profile   

Append Contents

{% highlight bash %}
export GOPATH=$HOME/work
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin    
{% endhighlight %}

## Logout