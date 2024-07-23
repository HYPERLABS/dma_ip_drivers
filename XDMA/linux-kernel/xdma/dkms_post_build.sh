#!/bin/bash
sudo make install
sudo rm /lib/modules/`uname -r`/kernel/drivers/misc/xdma.ko
