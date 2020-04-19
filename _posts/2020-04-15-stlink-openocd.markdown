---
title:  "ST-Link V2 with openocd"
date:   2020-04-11 00:00:01 -0700
categories: pinetime
tags: [zephr, pinetime, stlink, openocd]

---
# ST-Link V2 with openocd

I bought this one $8

[Aideepen ST-Link V2 Programming Unit Mini STM8 STM32](https://www.amazon.com/dp/B01J7N3RE6)

With only 4 wires and the cable that comes with the dev kit you can flash pinetime.  You have to use a raspberry pi to remove flash protection first but then you can just use the stlink.

## build deps

{% highlight bash %}
sudo apt-get install libusb-1.0-0-dev autotools libhidapi-dev automake autotools-dev libtool
{% endhighlight %}

## stlink tools

{% highlight bash %}
git clone https://github.com/texane/stlink stlink.git
cd stlink
make
sudo cp build/Debug/st-* /usr/local/bin
sudo cp etc/udev/rules.d/49-stlinkv* /etc/udev/rules.d/
sudo udevadm control --reload
{% endhighlight %}

## openocd tools

{% highlight bash %}
git clone https://github.com/ntfreak/openocd
cd openocd
./bootstrap
./configure --enable-cmsis-dap
{% endhighlight %}

# Flashing A File

cd openocd

Add a stlink nrf52 config file

## nrf52.cfg
{% highlight bash %}
source [find interface/stlink.cfg]
transport select hla_swd
source [find target/nrf52.cfg]
init
{% endhighlight %}

In One Terminal

{% highlight bash %}
./src/openocd -s tcl -f nrf52.cfg -d3
{% endhighlight %}

In Another Terminal

{% highlight bash %}
telnet localhost 4444

program /home/tim/mcuboot.bin
reset init
{% endhighlight %}