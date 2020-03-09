---
title:  "Xtreemefs"
date:   2020-03-08 00:00:01 -0700
categories: homelab
tags: [storage, beegfs]

---

# RTFM - very nice, concise docs

- [http://www.xtreemfs.org/quickstart.php]()
- [http://xtreemfs.org/xtfs-guide-1.5.1/index.html]()

# TLDR

- Just replicate the files in "RAID0"
- Secure with tennancy via x509 certificates.  Not encrypted during transport by default.
- Project is DEAD
  - The maintainers have moved on to a paid projects
  - The builds are broken for ubuntu 18.04 and the GPG is expired :-(

# Install 

## Centos
{% highlight bash %}
sudo yum update -y
sudo yum install -y nano wget curl net-tools elinks
sudo wget -O http://download.opensuse.org/repositories/home:/xtreemfs/CentOS_7/home:xtreemfs.repo
sudo yum update -y
{% endhighlight %}

## Ubuntu

Note: there is no bionic repo -- compile from source

gcc 4.1+
boost 1.39+
FUSE 2.6+ (Linux), OSXFUSE (OS X)
OpenSSL 0.99.8+
cmake 2.6+
make
libattr (Linux only)

The XtreemFS servers are implemented in Java and require Java 6+ and ant 1.6.5+. 