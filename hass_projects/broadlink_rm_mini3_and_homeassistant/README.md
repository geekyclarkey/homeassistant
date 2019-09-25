# How to setup a Broadlink RM Mini3 in Homeassistant

## Purchase the components needed
Below are links to the devices i used.  
[Broadlink RM Mini3](https://www.banggood.com/custlink/KD3GBKOZT9)  

### Connect the RM Mini3 to your network
* Plug the Broadlink RM Mini3 in and wait for the blue led to start blinking.  
* Download the [e-Control app](https://apps.apple.com/us/app/broadlink-e-control/id793152994) from the app store.  
* Open the app, skip the cloud setup and click the + button at the top right  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/broadlink_rm_mini3_and_homeassistant/images/add_button.jpg" width="200px">  

* Click add device  
* Enter your wifi name and password. (make sure your phone is connected to the 2.4Ghz wifi network too. dont use 5Ghz)
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/broadlink_rm_mini3_and_homeassistant/images/wifi.jpg" width="200px">   

* Click Configure and wait for the app to complete the setup. It will find the broadlink device and configure the wifi.
* Go to Device list and you will see your RM Mini htere. Make note of the mac address. You will need that later.
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/broadlink_rm_mini3_and_homeassistant/images/device_list.jpg" width="200px">
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/broadlink_rm_mini3_and_homeassistant/images/mac.jpg" width="200px">  

Log into your router and find the IP address the RM Mini has been assigned. Make note of that too.
Once this is set up you wont need the app again you can remove it if you like.

### Set up the RM Mini3 in Homeassistant
Add the following to the switch section of your configuration.yaml file  
```
switch:
  - platform: broadlink
    host: 192.168.10.91
    mac: '74:2a:75:5b:ca:c9'
    friendly_name: "Livingroom RM Mini"
    timeout: 15
    switches:
      samsung_tv_power:
        friendly_name: "Samsung TV Power"
        command_on: 'JgBGAJKVETkRORA6ERQRFBEUERQRFBE5ETkQOhAVEBUQFREUEBUQOhEUERQRORE5EBURFBA6EBUQOhE5EBUQFRA6EDoRFBEADQUAAA=='
        command_off: 'JgBGAJOVEDoQOhA6DxYPFhAVEBUQFRA6ETkROREUERQRFBEUEBUQFREUERQRORE5EBUQFRE5ETkRORE5ERUQFRA6DzsPFhAADQUAAA=='
```
This will create a switch entity called `switch.samsung_tv_power` then the switch is turned on the RM Mini will transmit the `command_on` code and the same when turned off.  
This is fine if you just want to turn a tv on and off, but if you want more advanced features like volume or number presses, i would suggest using scripts.

### Create scripts to simulate button presses
Add the following to your scripts.yaml
```
livingroom_volume_up:
  sequence:
     - service: broadlink.send
       data:
         host: 192.168.10.91
         packet:
           - "JgBYAAABK5EVEhUREjgTExITEhQTExQTFDUVNBIUFzMTNxI3FzMTNxMTEhQSFRQ1EhMSFBIUEhQTNxM2FDcTExI3FTQVNRU1EwAFyQABKEoTAAycAAEnSxMADQU="
livingroom_volume_down:
  sequence:
     - service: broadlink.send
       data:
         host: 192.168.10.91
         packet:
           - "JgBYAAABK5EVEhUREjgTExITEhQTExQTFDUVNBIUFzMTNxI3FzMTNxMTEhQSFRQ1EhMSFBIUEhQTNxM2FDcTExI3FTQVNRU1EwAFyQABKEoTAAycAAEnSxMADQU="
```

When these scripts are executed in lovelace, they make the RM Mini send a one off code that in this example turns the tv volume up or down.  
Now with this i can make a button in lovelace and use that as a remote or have an automation action turn the tv down.

```
livingroom_bbc1:
  alias: "BBC 1"
  sequence:
     - service: broadlink.send
       data:
         host: 192.168.10.91
         packet:
           - "JgAsAB4dPB0eOh4dHh08Oh4dPDo8Oh4AC54eHTwdHToeHh4dPDoeHTw6OzseAA0FAAAAAAAAAAAAAAAA"
           - "JgA0AB4dPB0dOh4eHR47HR4dHhweHR0dHjoeAAubHh47HR46Hh0eHTwdHhweHR4cHh0dOh4ADQUAAAAA"
           - "JgAsAB4dPB0eOh4dHh08Oh4dPDo8Oh4AC54eHTwdHToeHh4dPDoeHTw6OzseAA0FAAAAAAAAAAAAAAAA"
     - service: switch.turn_on
       entity_id: switch.samsung_tv_power
     - delay:
         seconds: 6
     - service: media_player.select_source
       data:
         entity_id: media_player.living_room_tv
         source: HDMI 1
```
This automation changes my set top box to BBC One by simulating the buttons 1-0-1 then switched the tv on waits 6 seconds (because of the boot screen) then changes the TV input over to HDMI 1  
These actions will be played out one after the other starting from the top. All from one executable button in lovelace, or an automation could run this script as the action.

### Generating your own RF codes
You can find the rf code for any infrared remote.  
* Go to the Developer tools in homeassistant
* Click the services tab
* In the service section choose `broadlink.learn`
* in the json section type `{"host": "192.168.10.91"}` (Change the ip to the ip of your RM Mini)
* The light on your RM Mini will light up
* Point the remote at the RM Mini and press the button on you remote you want to learn
* the light on the RM Mini will go off when it has received the signal
* in homeassistant you will see a 1 on the notifications bell
* Click on the bell and double click the code to highlight the learned code
* Copy the code by pressing CMD+C (Mac) or CTRL+C (PC)
* Then paste the code somewhere for you to use later

## Restart homeassistant and Thats it! Have fun trying it for yourself.

## Other Github projects for the Broadlink RM Mini3
Try the [Smart IR](https://github.com/smartHomeHub/SmartIR) custom component by [Vassilis Panos](https://github.com/smartHomeHub)  
**I personally use this custom component for controlling my air conditioning units.**

There is also a windows program for learning ir codes.
See This [Website](https://sourceforge.net/u/tech-blog/profile/) and choose the `broadlink manager` project for the latest version

I have uploaded the latest version as of 04/09/19 in case the project ever gets deleted. [Click here](https://github.com/geekyclarkey/homeassistant/raw/master/hass_projects/broadlink_rm_mini3_and_homeassistant/Broadlink_Manager.exe) to download the version i have installed on my pc. I can confirm it works perfectly.
