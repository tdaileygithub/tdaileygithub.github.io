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
                args              = ["-m", "4096", "-enable-kvm", "-cpu","host", "-smp","2", "-vnc",":2"]
            }

            # Specifying an artifact is required with the "qemu"
            # driver. This is the # mechanism to ship the image to be run.
            artifact {
                source = "http://192.168.200.100/ubuntu1804"

                options {
                checksum = "md5:edb6af153236362b8e681e580d73d1ab"
                }
            }

        }    
    }
}
{% endhighlight %}

https://events19.linuxfoundation.org/wp-content/uploads/2017/12/Kashyap-Chamarthy_Effective-Virtual-CPU-Configuration-OSS-EU2018.pdf

<!-- #safest config?? -->
sudo qemu-system-x86_64 -m 4096 -cpu kvm64 -smp 2 -vnc :2 -net nic -net tap,ifname=tap0,script=no  ubuntu1804

#best performing
sudo qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 4096  -vnc :2 -net nic -net tap,ifname=tap0,script=no  ubuntu1804

# NAT access to the virtual machine

https://felipec.wordpress.com/2009/12/27/setting-up-qemu-with-a-nat/
https://wiki.gentoo.org/wiki/QEMU/Options
https://www.redhat.com/en/blog/inception-how-usable-are-nested-kvm-guests

{% highlight bash %}
iptables -t nat -A POSTROUTING -o ens192 -j MASQUERADE
iptables -I FORWARD 1 -i tap0 -j ACCEPT
iptables -I FORWARD 1 -o tap0 -m state --state RELATED,ESTABLISHED -j ACCEPT
{% endhighlight %}