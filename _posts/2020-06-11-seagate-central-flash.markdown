---
title:  "Seagate Central - Root Access"
date:   2020-06-11 00:00:01 -0700
categories: homelab
tags: [homelab]

---
# Root Access on Seagate-Central - and SSH Mount

SMB 1 support was disabled in Windows 10 by default.  This makes the Seagate Central not usable.
However, mounting over SSH is pretty simple.

This blog post describes the process exactly for gaining elevated root shell access. 

[https://seagatecentralenhancementclub.blogspot.com/2015/11/root-su-recovery-for-seagate-central.html]()

## GPL source code from seagate

[https://www.seagate.com/support/downloads/item/central-gpl-fw-master-dl]()

## Get New Firmware

[https://www.seagate.com/support/external-hard-drives/network-storage/seagate-central/]()

## A script someone made

I followed the blogspot article above instead.

[https://raw.githubusercontent.com/detain/seagate_central_sudo_firmware/master/seagate_patch_root.sh]()

## Mount in windows as SFTP Net Drive - eg fuse style only on windows

It used to be www.sftpnetdrive.com -- my 2017 version indicates

Now it appears to be [https://www.nsoftware.com/sftp/drive/order.aspx]()   ??