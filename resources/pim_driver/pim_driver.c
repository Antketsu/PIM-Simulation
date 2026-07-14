// pim_driver.c
#include <linux/module.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/mm.h>
#include <linux/uaccess.h>
#include <linux/io.h>

#define DEVICE_NAME "pim"
#define CLASS_NAME  "pim_class"

#define PIM_PHYS_ADDR   0x280000000UL   
#define PIM_SIZE        0xC0000000UL    // 3GB

static dev_t dev_num;
static struct cdev pim_cdev;
static struct class *pim_class;
static struct device *pim_device;

static int pim_mmap(struct file *filp, struct vm_area_struct *vma)
{
    unsigned long size = vma->vm_end - vma->vm_start;
    unsigned long pfn = PIM_PHYS_ADDR >> PAGE_SHIFT;

    if (size > PIM_SIZE) {
        pr_err("pim: mmap size %lu exceeds PIM size %lu\n", size, PIM_SIZE);
        return -EINVAL;
    }

    // Uncached mapping for PIM memory
    vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);

    if (remap_pfn_range(vma, vma->vm_start, pfn, size, vma->vm_page_prot)) {
        pr_err("pim: remap_pfn_range failed\n");
        return -EAGAIN;
    }

    pr_info("pim: mmap ok, size=%lu at phys=0x%lx\n", size, PIM_PHYS_ADDR);
    return 0;
}

static int pim_open(struct inode *inode, struct file *filp)
{
    return 0;
}

static int pim_release(struct inode *inode, struct file *filp)
{
    return 0;
}

static const struct file_operations pim_fops = {
    .owner   = THIS_MODULE,
    .open    = pim_open,
    .release = pim_release,
    .mmap    = pim_mmap,
};

static int __init pim_init(void)
{
    int ret;

    ret = alloc_chrdev_region(&dev_num, 0, 1, DEVICE_NAME);
    if (ret < 0) {
        pr_err("pim: failed to allocate char device region\n");
        return ret;
    }

    cdev_init(&pim_cdev, &pim_fops);
    ret = cdev_add(&pim_cdev, dev_num, 1);
    if (ret < 0) {
        pr_err("pim: cdev_add failed\n");
        unregister_chrdev_region(dev_num, 1);
        return ret;
    }

    pim_class = class_create(CLASS_NAME);
    if (IS_ERR(pim_class)) {
        cdev_del(&pim_cdev);
        unregister_chrdev_region(dev_num, 1);
        return PTR_ERR(pim_class);
    }

    pim_device = device_create(pim_class, NULL, dev_num, NULL, DEVICE_NAME);
    if (IS_ERR(pim_device)) {
        class_destroy(pim_class);
        cdev_del(&pim_cdev);
        unregister_chrdev_region(dev_num, 1);
        return PTR_ERR(pim_device);
    }

    pr_info("pim: driver loaded, /dev/%s created\n", DEVICE_NAME);
    return 0;
}

static void __exit pim_exit(void)
{
    device_destroy(pim_class, dev_num);
    class_destroy(pim_class);
    cdev_del(&pim_cdev);
    unregister_chrdev_region(dev_num, 1);
    pr_info("pim: driver unloaded\n");
}

module_init(pim_init);
module_exit(pim_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Antonio");
MODULE_DESCRIPTION("Simple PIM memory access driver for gem5 FS");