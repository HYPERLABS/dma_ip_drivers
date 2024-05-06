SHELL = /bin/bash
#
# optional makefile parameters:
# - DEBUG=<0|1>,	enable verbose debug print-out in the driver
# - config_bar_num=,	xdma pci config bar number
# - xvc_bar_num=,	xvc pci bar #
# - xvc_bar_offset=,	xvc register base offset
# 
ifneq ($(xvc_bar_num),)
	XVC_FLAGS += -D__XVC_BAR_NUM__=$(xvc_bar_num)
endif

ifneq ($(xvc_bar_offset),)
	XVC_FLAGS += -D__XVC_BAR_OFFSET__=$(xvc_bar_offset)
endif

$(warning XVC_FLAGS: $(XVC_FLAGS).)

topdir := $(shell cd $(src)/.. && pwd)

TARGET_MODULE:=xdma

EXTRA_CFLAGS := -I$(topdir)/include $(XVC_FLAGS)
ifeq ($(DEBUG),1)
	EXTRA_CFLAGS += -D__LIBXDMA_DEBUG__
endif
ifneq ($(config_bar_num),)
	EXTRA_CFLAGS += -DXDMA_CONFIG_BAR_NUM=$(config_bar_num)
endif
#EXTRA_CFLAGS += -DINTERNAL_TESTING

ifneq ($(KERNELRELEASE),)
	$(TARGET_MODULE)-objs := libxdma.o xdma_cdev.o cdev_ctrl.o cdev_events.o cdev_sgdma.o cdev_xvc.o cdev_bypass.o xdma_mod.o xdma_thread.o
	obj-m := $(TARGET_MODULE).o
else
	BUILDSYSTEM_DIR:=/lib/modules/$(shell uname -r)/build
	PWD:=$(shell pwd)
all :
	$(MAKE) -C $(BUILDSYSTEM_DIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(BUILDSYSTEM_DIR) M=$(PWD) clean
	@/bin/rm -f *.ko modules.order *.mod.c *.o *.o.ur-safe .*.o.cmd

install: all
	$(MAKE) -C $(BUILDSYSTEM_DIR) M=$(PWD)
	install -m 644 -o root -g root xdma.ko /lib/modules/`uname -r`/kernel/drivers/misc
	depmod -a

# copy the udev rules to /etc/udev/rules.d - but only if the file does not already exist
	@if ! [ -e /etc/udev/rules.d/10-xilinx-xdma.rules ]; \
	then \
		cp 10-xilinx-xdma.rules /etc/udev/rules.d/10-xilinx-xdma.rules; \
		echo "Copied 10-xilinx-xdma.rules to /etc/udev/rules.d"; \
	fi
	
# copy the configuration file /etc/modprobe.d - but only if the file does not already exist
	@if ! [ -e /etc/modprobe.d ]; \
	then \
		mkdir /etc/modprobe.d; \
	fi
	@if ! [ -e /etc/modprobe.d/xilinx-xdma.conf ]; \
	then \
		cp xilinx-xdma.conf /etc/modprobe.d/xilinx-xdma.conf; \
		echo "Copied xilinx-xdma.conf to /etc/modprobe.d"; \
	fi


endif
