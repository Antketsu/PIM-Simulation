obj-m += pim_driver.o

all:
        make -C /lib/modules/6.8.0-134-generic/build M=$(PWD) modules

clean:
        make -C /lib/modules/6.8.0-134-generic/build M=$(PWD) clean