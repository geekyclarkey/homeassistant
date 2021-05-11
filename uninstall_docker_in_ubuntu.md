

# How to uninstall docker on ubuntu server 16.04.


To completely uninstall Docker:

## Step 1
```
dpkg -l | grep -i docker
```
To identify what installed package you have:

## Step 2
```
sudo apt-get purge -y docker-engine docker docker.io docker-ce
sudo apt-get autoremove -y --purge docker-engine docker docker.io docker-ce
```
The above commands will not remove images, containers, volumes, or user created configuration files on your host.  
If you wish to delete all images, containers, and volumes run the following commands:
```
sudo rm -rf /var/lib/docker /etc/docker
sudo rm /etc/apparmor.d/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock
```
You have removed Docker from the system completely.



# Disclaimer
I did not come up with the instructions above.  
I found these steps from [This Stack Exchange page](https://askubuntu.com/questions/935569/how-to-completely-uninstall-docker)  
I only copied it and added it to my github page so i can access it again in the future easily if needed.
