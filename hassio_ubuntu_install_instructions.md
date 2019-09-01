

# How to install hassio on ubuntu server 16.04.

* use program like etcher to mount the iso onto a usb stick.
* put the stick in your computer you want to use as hassio server and boot from usb.
* Install ubuntu. Go through setup procedure.
* following steps configuring your keyboard and so on.
* When prompted about user and password, make sure you remember these as these will be needed to use the ubuntu side later on.
* In the section about what packages to install, enable open ssh server when prompted on the setup. this way you will be able to ssh into the computer from another device.

* If using freenass and you are using ubuntu as a vm you may have problems with ubuntu booting. If so try this:
```
    When on UEFI Interactive Shell; type: exit
    In the EFI menu system navigate to "Boot Maintenance Manager"
    Select "Boot from file"
    Locate and select your grubx64.efi file
    When in terminal:
    $ sudo mkdir /boot/efi/EFI/BOOT
    $ sudo cp /boot/efi/EFI/ubuntu/grubx64.efi /boot/efi/EFI/BOOT/bootx64.efi
    $ reboot
```


## when ubuntu is up and running

### update packages by typing:
`sudo apt-get update` (this can take a while as it updates all of the packages)  
then:  
`sudo apt-get upgrade`

### To install hassio, Run this command. type:

`curl sL https://goo.gl/1bcBsW | bash -`  
or  
`curl sL https://raw.githubusercontent.com/savvytv/Repo/master/HASSIO/install.sh | bash -`

Once the script has ran you should have hassio installed and be able to start setting up hass.


### change ip to static:
`sudo nano /etc/network/interfaces`
Below is what mine looks like. You will need to make changes to suit your interface name and network range.
```
#####################################################################
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto enp0s3
iface enp0s3 inet static
        address 192.168.100.53
        netmask 255.255.255.0
        gateway 192.168.100.1
        dns-nameservers 8.8.8.8 8.8.4.4

######################################################################
```
Then type:  
`sudo reboot`  
This will reboot your server and apply the new changes





### stop laptop shutting down after lid close:
`sudo nano /etc/systemd/logind.conf`
change this line and make it:
```
HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
```
Then run this command:
`sudo systemctl restart systemd-logind`


### if open ssh is not installed and enabled from ubuntu install. Do so by typing:
`sudo apt-get install openssh-server`
