---
title:  "Micropython, Nordic, S132"
date:   2020-12-26 00:00:01 -0700
categories: embedded
tags: [micropython]

---
# List modules

    help ('modules')

## List function in modules

    import ble
    dir (ble)

# Python BLE

https://www.afantor.cc/mpy/html/nrf52/ubluepy.html

## Modules

    import ble
    import ubluepy

## BLE Mac Address

    import ble
    ble.address()

# S132 Nordic BLE Protocol Stack

https://www.nordicsemi.com/Software-and-Tools/Software/S132/Download

https://devzone.nordicsemi.com/nordic/short-range-guides/b/software-development-kit/posts/getting-started-with-nordics-secure-dfu-bootloader


## bootloader/src/main.c

**todo**: modify bootloader to allow for more than one connection ??

need to rtfm on setting up the nordic soft device for bluetooth connections - but the follow are relevant

    // Configure the maximum number of connections.
    varclr(&blecfg);
    blecfg.gap_cfg.role_count_cfg.adv_set_count = 1;
    blecfg.gap_cfg.role_count_cfg.periph_role_count  = 1;
    blecfg.gap_cfg.role_count_cfg.central_role_count = 0;
    blecfg.gap_cfg.role_count_cfg.central_sec_count  = 0;
    APP_ERROR_CHECK( sd_ble_cfg_set(BLE_GAP_CFG_ROLE_COUNT, &blecfg, ram_start) );

https://www.bluetooth.com/specifications/gatt/
https://www.bluetooth.org/docman/handlers/downloaddoc.ashx?doc_id=292957    
https://developer.apple.com/accessories/Accessory-Design-Guidelines.pdf