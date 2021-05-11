

# How to uninstall Hassio on FreeNAS/TrueNAS as a virtual machine

*Requirements:* FreeNAS/TrueNAS machine, VM software running on a PC ie. Virtual Box, a way of transferring files (approx. 6GB, the size of the HassOS install) from PC to FreeNAS/TrueNAS, terminal access to FreeNAS (or use of Shell in FreeNAS GUI).

## On your PC:

### Step 1
Download the virtual machine disk drive [here](https://www.home-assistant.io/installation/alternative)  
Download VirtualBox (.VDI) image  

### Step 2  
Unrar it! (.gz is an archive file; use a program like 7zip or winrar to unrar it).

### Step 3
if not already installed, install Oracle Virtual Box on your PC [Link Here](https://www.virtualbox.org/wiki/Downloads)

### Step 4
Convert the virtual machine disk drive (in this case vdi drive for Oracle’s Virtual Box but vmdk should work too) to img by running (if running on Windows open a Command Prompt and change directory to Virtual Box install folder - defaults to c:\Program Files\Oracle\VirtualBox)
(replace source/hassos_vm.vdi and destination/hassos_vm.img with own locations)

`VBoxManage clonehd source/hassos_vm.vdi destination/hassos_vm.img --format raw`

The size of the img should be around 6 GB (up from 400 MB for the vdi).

### Step 5
Copy the hassos_vm.img to FreeNAS/TrueNAS

## On FreeNAS/TrueNAS:

### Step 1
Create a new Zvol  
Navigate to Storage -> Pools and click the three dots -> Add Zvol

Set a reasonable size for the Zvol (at least 32 GiB; it should be noted that the space is immediately allocated to Zvol and not accessible for file storage anymore; this is particularly important if already running FreeNAS with free space below 20% of the pool size as it will crash FreeNAS).

The new Zvol will then be accessible at /dev/zvol/pool_name/zvol_name (its path will be needed later).

### Step 2
Create a new VM (don’t power it yet)

Step 1: Navigate to Virtual Machines add Virtual Machine (VM)
Step 2: Set Guest OS as Linux and Boot Method as UEFI
Step 3: Add number of Virtual CPUs and Memory size accessible to the VM (this can be modified later)
Step 4: Select Use existing disk image and select the Zvol created above
Step 5: Modify Network Adapter if needed (ie. in order to easily locate the NIC when router leases its IP)
Step 6: Next (don’t add installation image)
Step 7: Submit

### Step 3
Burn the hassos_vm.img to the Zvol created above by running the following command:

`dd if=/mnt/pool_name/dataset_name/location_of_hassos_vm/hassos_vm.img of=/dev/zvol/pool_name/zvol_name`
In my case the code would be:  
`dd if=/mnt/HDDs/sean/PC/OperatingSystems/hassos_vm.img of=/dev/zvol/HDDs/hassio` Yours will obviously be different.

### Step 4
Power on the VM (hassos will then occupy the entire Zvol storage that was set above)





# Disclaimer
I did not come up with the instructions above.  
I fount these steps from [This community Hassio page](https://community.home-assistant.io/t/alternative-way-of-running-hassos-full-os-on-freenas-without-iocage-or-docker/133738)  
I only copied it and added it to my github page so i can access it again in the future easily if needed.  
All credit for this tutorial must go to the original author [PetriciaM](https://community.home-assistant.io/u/Petrica/summary)
