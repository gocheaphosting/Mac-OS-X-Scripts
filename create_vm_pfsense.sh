#!/bin/bash
# Avoid spaces in the strings below.

# Machine config data:
VMUSER="james"
VMNAME="pfsense-vm"
OSTYPE="FreeBSD_64"
MEM="1024"
HDSIZE="8000"
BRIDGE1="eth1"
BRIDGE2="eth0"
PROMISC1="allow-all"
PROMISC2="allow-all"
VRDE="on"
VRDEPORT="3389-3399"
AUTOSTART="on"
NONROTATIONAL="on"
DISCARD="on"
HPET="on"

# Set system strings from machine config data.
HDNAME=${VMNAME}.vdi
INSTALL=/home/$VMUSER/${VMNAME}_install.iso
IDENAME="IDE Controller"

vboxmanage createvm --name $VMNAME --ostype $OSTYPE --register
vboxmanage modifyvm $VMNAME --memory $MEM --acpi on --nic1 bridged --nic2 bridged
vboxmanage modifyvm --bridgeadapter1 $BRIDGE1 --bridgeadapter2  $BRIDGE2
vboxmanage modifyvm --nictype1 virtio --nictype2 virtio
vboxmanage modifyvm --nicpromisc1 $PROMISC1 --nicpromisc2 $PROMISC2
vboxmanage modifyvm --cableconnected1 on --cableconnected on
vboxmanage createhd --filename $HDNAME --size $HDSIZE
vboxmanage storagectl $VMNAME --name "$IDENAME" --add ide --controller PIIX4
vboxmanage storageattach $VMNAME --storagectl "$IDENAME" --port 0 --device 0 --type hdd --medium $HDNAME --nonrotational $NONROTATIONAL --discard $DISCARD
vboxmanage storageattach $VMNAME --storagectl "$IDENAME" --port 0 --device 1 --type dvddrive --medium $INSTALL
vboxmanage modifyvm --vrde $VRDE
vboxmanage modifyvm --vrdeport "$VRDEPORT"
vboxmanage modifyvm --autostart-enabled $AUTOSTART
vboxmanage modifyvm --hpet $HPET

echo "To start the virtual machine do the following:"
echo "VBoxHeadless --startvm "'<vmname>'
echo "To share a USB device with the vm do the following:"
echo "rdesktop-vrdp -r usb -a 16 -N "'<vm.server.address>'" (not the address of the vm)"
echo "To export to a virtual appliance do the following:"
echo "VBoxManage export "'<vmname>'" --manifest,nomacs"
