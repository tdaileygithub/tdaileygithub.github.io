---
title:  "PineTime - Zephyr App"
date:   2020-04-11 00:00:01 -0700
categories: pinetime
tags: [zephr, pinetime]

---
# [pinetime-zephyr](https://github.com/najnesnaj/pinetime-zephyr) 

{% highlight bash %}
cd ~/Documents/github.com/
git clone https://github.com/najnesnaj/pinetime-zephyr.git
cd pinetime-zephyr
mkdir work
west init -m https://github.com/najnesnaj/pinetime-zephyr
west update
{% endhighlight %}

## Building Apps

{% highlight bash %}

cd ~/Documents/github.com/pinetime-zephyr/work/pinetime

#always nuke the build directory before building anything - clean is fast
rm -rf build
west build -p -b pinetime samples/gui/lvtouch

ls build/zephyr/zephyr* -alh
{% endhighlight %}