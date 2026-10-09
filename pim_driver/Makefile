obj-m += pim_driver.o
linux_dir = /lib/modules/6.8.0-146-generic/build
all:
	make -C $(linux_dir) M=$(PWD) modules

clean:
	make -C $(linux_dir) M=$(PWD) clean