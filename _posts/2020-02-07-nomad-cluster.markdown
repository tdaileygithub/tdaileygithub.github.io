---
title:  "Nomad Cluster Info"
date:   2020-02-07 20:10:34 -0700
categories: homelab
tags: [hashicorp, consul, nomad]
---

# Virtual Machines

All lans are vmware internal port group and v-switch

| server       | lan ip          | cpu | ram | disk  |
|--------------|-----------------|-----|-----|-------|
| nomadsrv1    | 192.168.200.200 | 8   | 4GB | 60GB |
| nomadsrv2    | 192.168.200.201 | 8   | 4GB | 60GB |
| nomadsrv3    | 192.168.200.202 | 8   | 4GB | 60GB |
| nomadcl1     | 192.168.200.203 | 8   | 4GB | 60GB |
| nomadnfs     | 192.168.200.100 | 2   | 4GB | 100GB |
| nomadgitlab  | 192.168.200.101 | 2   | 4GB | 100GB |
| nomadjenkins | 192.168.200.102 | 8   | 8GB | 500GB |
| nomadpfsense | 192.168.200.254 | 2   | 2GB | 10GB  |

# SSH tunnels

## Gitlab Web Access and Containers

{% highlight bash %}
sudo ssh -L 5050:192.168.200.101:5050 -L 5558:192.168.200.101:22 -L443:192.168.200.101:443 tdailey@nomadgitlab
{% endhighlight %}

{% highlight bash %}
docker login 127.0.0.1:5050
{% endhighlight %}

- [https://127.0.0.1]()
- ssh://git@127.0.0.1:5558/root/mnist

**Note:** Root is default gitlab ce username not actually root

**Note:** The docker login needs 443 to be forwarded as it try to login to https://127.0.0.1 and it is unknown how to change that default for pushing images.

# Consul and Nomad Web Access

{% highlight bash %}
ssh -L5555:127.0.0.1:8500 -L5556:192.168.200.200:4646 nomadsrv1
{% endhighlight %}

- [http://127.0.0.1:5555/ui/]()
- [http://127.0.0.1:5556/ui/]()