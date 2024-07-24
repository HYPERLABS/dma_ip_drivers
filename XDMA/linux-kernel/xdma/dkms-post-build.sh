#!/bin/bash
# We only install here in order to copy in rules and conf files, dkms will place the newly built module under /lib/modules/<kernel>/updates/dkms/
# We don't need the module that make install generates and can remove it.
sudo make install
sudo rm /lib/modules/`uname -r`/kernel/drivers/misc/xdma.ko
