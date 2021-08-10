---
title:  "Pinetime - SWD debug with JLink and RTT"
date:   2021-08-10 00:00:01 -0700
categories: pinetime
tags: [pinetime]

---
# Debugging NRF52 on Infnitime

The following describes the configuration of my debug setup for Infnitime.

It uses a jlink for programming, a opened pinetime with SWD soldered on, and remote arm GDB.

![jlink swd debug](/assets/images/pinetime-jlink-debug.jpg)

## Install build tools

{% highlight bash %}
sudo pip3 install cryptography cbor setuptools intelhex
{% endhighlight %}

## JLink - GDB Server

Open a *new terminal* and start a GDB Server instance

The following starts a GDB Server listener on 127.0.0.1:2431 that connects to the target using SWD and a breakout cable.
It also starts listening for telnet connections on 2434 which the target can use to send debug messages back to the host.

**Note:** 261001881 is the identifier of my Jlink

{% highlight bash %}
JLinkGDBServerCLExe \
-device NRF52 \
-if swd \
-endian little \
-port 2431 \
-swoport 2432 \
-telnetport 2433 \
-RTTTelnetport 2434 \
-vd \
-noir \
-localhostonly 1 \
-strict \
-timeout 0 \
-select USB=261001881
{% endhighlight %}

## JLinkRTTClient 

Open a *new terminal* and start a JLink RTT listener.

{% highlight bash %}
JLinkRTTClient -RTTTelnetPort 2434
{% endhighlight %}

### Configure logging in the Infnitime source code

The following constants should be set in the source to all RTT messages to be sent by the target

**File:** src/sdk_config.h

{% highlight cpp %}
#ifndef NRF_LOG_ENABLED
#define NRF_LOG_ENABLED 1
#endif

#ifndef NRF_LOG_BACKEND_RTT_ENABLED
#define NRF_LOG_BACKEND_RTT_ENABLED 1
#endif
{% endhighlight %}

## Start GDB and connect to remote 127.0.0.1:2431

Open a *new terminal* and start a new arm gdb session

Where pinetime-app-0.10.0.hex is build output.

{% highlight bash %}
#Set PATH to arm toolchain.
export PATH=$PATH:/home/tim/gcc-arm-none-eabi-9-2019-q4-major/bin

arm-none-eabi-gdb

(gdb) target remote 127.0.0.1:2431
(gdb) monitor reset
(gdb) file /home/tim/Documents/github.com/Pinetime-develop/build/src/pinetime-app-0.10.0.hex
(gdb) load
(gdb) continue
{% endhighlight %}



## JLink - Connect to Target and Run Commands

Open a *new terminal* and start jlink telling it to connect to the target.

{% highlight bash %}
JLinkExe  -device nrf52 \
          -if swd \
          -speed 4000 \
          -autoconnect 1 \
          -CommandFile ./jlink-app-commands.jlink
{% endhighlight %}

### jlink-app-commands.jlink

- r = REST
- sleep = sleep time in milliseconds
- loadfile = load the application binary at offset 0x8000
- g = go
- q = quit

{% highlight text %}
r
sleep 1000
loadfile ./build/src/image.bin 0x8000
sleep 1000
r
g
q
{% endhighlight %}
