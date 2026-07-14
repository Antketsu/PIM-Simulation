Inside disk image:

sudo cp pim_driver.ko /lib/modules/$(uname -r)/extra/
sudo depmod -a
echo 'KERNEL=="pim", MODE="0666"' | sudo tee /etc/udev/rules.d/99-pim.rules
sudo udevadm control --reload-rules
echo "pim_driver" | sudo tee -a /etc/modules