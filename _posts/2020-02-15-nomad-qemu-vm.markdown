---
title:  "Nomad w/ Packer GKVM image"
date:   2020-02-15 00:00:01 -0700
categories: homelab
tags: [hashicorp, consul, nomad, qemu]

---
# Todo 
1. Resource Allocation at both nomad and qemu?
2. Alternative artifact downloader?     
3. Attaching the Qemu VM to host bridged network
4. Jenkins or gitlab building the images and copying them to destination??
5. Restarts of vm when fail
6. Service Check -- to see if vm is dead?

# Overview

Packer can build a disk image.  

Nomad can then be used to start a vm using that image.

# Qemu Launch Commaond

{% highlight bash %}
qemu-system-x86_64 -m 4096 -cpu kvm64 -smp 2 -vnc :1 ubuntu1804
{% endhighlight %}

# Nomad Job Definition

{% highlight bash %}
job "qemu-ub1804" {
    datacenters = ["dc1"]
    type = "service"
    group "qemu-ub1804" {
        count = 1
        task "qemu-ub1804" {
            driver = "qemu"

            config {
                image_path        = "local/ubuntu1804"
                accelerator       = "kvm"
                graceful_shutdown = true
                args              = ["-m", "4096", "-cpu","kvm64", "-smp","2", "-vnc",":1"]
            }

            # Specifying an artifact is required with the "qemu"
            # driver. This is the # mechanism to ship the image to be run.
            artifact {
                source = "http://nomadnfs/ubuntu1804"

                options {
                checksum = "md5:edb6af153236362b8e681e580d73d1ab"
                }
            }

        }    
    }
}
{% endhighlight %}