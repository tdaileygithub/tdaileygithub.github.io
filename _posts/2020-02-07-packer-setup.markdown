---
title:  "Packer Steup"
date:   2020-02-07 20:10:34 -0700
categories: homelab
tags: [hashicorp, consul, nomad, go]

---
# Todo 

[https://github.com/hashicorp/packer/issues/8772]()

    set +e
    ${GOX:?command not found} \
        -os="${XC_OS:-$ALL_XC_OS}" \
        -arch="${XC_ARCH:-$ALL_XC_ARCH}" \
        -parallel=1 \
        -osarch="!darwin/arm !darwin/arm64" \
        -ldflags "${GOLDFLAGS}" \
        -output "pkg/{{.OS}}_{{.Arch}}/packer" \
        .
    set -e

# Host packages

{% highlight bash %}
sudo apt-get update
sudo apt-get upgrade    
sudo apt-get install git make build-essential
{% endhighlight %}

# Go 1.13.7 - Stable

[install it](go-release)

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

# make packer type faster over vnc!!

{% highlight bash %}
PACKER_KEY_INTERVAL=20ms packer build 
{% endhighlight %}

This command takes minutes off of some builds.  
The default on my setup seems like it is 1 second or so per keystroke.