# Garage Door Module

I created a garage door module to simulate pressing the open and close buttons on my garage controller.  
While i had GPIO pins left i also added some sensors and made the whole thing on some perf board so they can easily be changed in the future if needed.  
Im using [ESPHome](https://esphome.io/) for the firmware.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/garage_door_module/images/2.jpeg" width="300px"><img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/garage_door_module/images/4.jpeg" width="300px"><img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/garage_door_module/images/5.jpeg" width="300px">

## Purchase all the sensors and components needed
[D1 Mini](https://www.banggood.com/custlink/Gm3KgKZrD4)  
[BH1750 Light Sensor In Dome](https://www.banggood.com/custlink/vGGm4monGe)  
[Mini IR Infrared Pyroelectric PIR](https://www.banggood.com/custlink/3KK3BDIEwm)  
[5V AC-DC Power Supply](https://www.banggood.com/custlink/33Dm43IWdV)  
[Prototype Boards](https://www.banggood.com/custlink/GKvDBmLBqM)  
[Wired Door/Window Magnetic Reed Switch](https://www.banggood.com/custlink/KKmKeDOsKw)  
[PC817 Opto Isolators](https://www.amazon.es/Optoacoplador-60pcs-Optocoupler-%EF%BC%8COptocoupler-Arduino/dp/B07X46SYQT/ref=sr_1_1?__mk_es_ES=%C3%85M%C3%85%C5%BD%C3%95%C3%91&dchild=1&keywords=pc817&qid=1587387133&sr=8-1)

## Hardware

### Step 1
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/garage_door_module/images/1.jpeg" width="300px">
Place all of the components onto the board thinking about the spacing.  
Solder all them down.  

### Step 2
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/garage_door_module/images/9.jpeg" width="300px">
You will need to connect up all of the connections to the D1. I used ethernet cables cut to length to link all of the pins.  
With the Opto Isolators, solder the cathode to ground and the annode to the GPIO pins states below. the collector and emitter for each one are both soldered to the screw terminals.  

### Step 3
If you use the same GPIO pins i used you can follow the software instructions but if you use different pins, make sure you set up the correct pins in Esphome  
* 3.3V - 3.3  
* Ground - GND  
* SCL - D4  
* SDA - D3  
* Open Opto Isolator - D1  
* Close Opto Isolator - D2  
* PIR Data Pin - D6  
* Door Sensor Pin - D5  

**Thats it for the hardware!**

## software

First of all you need to have ESPHome addon installed in homeassistant. See [here](https://esphome.io/guides/getting_started_hassio.html) for instructions on how to do that.  

### Step 1
Go into the ESPHome dashboard and click the `+` to create a new device.
Fill in the prompts like requested. It doesn't actually matter what you put because you will be replacing the config in a moment.  
*Make sure you don't use capital letters when adding a name*  

### Step 2
Once the Dummy file is created, click on the word `edit` and paste the following.  
```
substitutions:
  espname: "garagedoormodule"
  hostname: "Garage Door Module"
  ssid: "yourwifiname"
  ssidpassword: "yourwifipassword"

esphome:
  name: $espname
  platform: ESP8266
  board: d1_mini

wifi:
  ssid: $ssid
  password: $ssidpassword
  ap:
    ssid: $espname
    password: "1234567890"

captive_portal:
logger:
api:
ota:
web_server:
  port: 80

i2c:
  sda: D3
  scl: D4
  scan: True

switch:
  - platform: restart
    name: Restart $hostname
  - platform: gpio
    name: "Open Garage"
    pin: D1
    id: open
    icon: "mdi:flash"
    on_turn_on:
      - delay: 0.5s
      - switch.turn_off: open
  - platform: gpio
    name: "Close Garage"
    pin: D2
    id: close
    icon: "mdi:flash"
    on_turn_on:
      - delay: 0.5s
      - switch.turn_off: close

binary_sensor:
  - platform: gpio
    pin: D6
    name: $hostname Motion
    device_class: motion
  - platform: gpio
    pin:
      number: D5
      mode: INPUT_PULLUP
    name: "Garage Door"
    device_class: garage_door

sensor:
  - platform: wifi_signal
    name: $hostname WiFi Signal
    update_interval: 60s
  - platform: bh1750
    name: "Garage Brightness"
    address: 0x23
    update_interval: 60s

text_sensor:
  - platform: wifi_info
    ip_address:
      name: $hostname IP Address

```
Once you have made the changes to your wifi details and changed the GPIO pins (if you have on the hardware) click `Save`  

As you can see, there is an auto switch off on the open and close switches. This is because we want to simulate a button press. When you toggle the switch it will stay on for half a second then turn off again. just like the push of a button.  

### Step 3
Next click `Validate` and ESPHome will check your config to see if it is written correctly.  
If it is valid then Click the 3 dots on the top right of the device and click `Compile`  
This will create a .bin file. when compiled, click `Download Binary`

### Step 4
Flash the bin file onto your D1Mini

### Step 5
Add the sensors to the module.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/garage_door_module/images/6.jpeg" width="300px"><img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/garage_door_module/images/7.jpeg" width="300px"><img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/garage_door_module/images/8.jpeg" width="300px">

## Homeassistant

ESPHome devices are generally automatically found by Homeassistant and all you need to do is click the notification and add the device to your home automation server.  
You can then find the entities from the `Intergrations` section of your Homeassistant.  

Thats it! Have fun trying it for yourself.
