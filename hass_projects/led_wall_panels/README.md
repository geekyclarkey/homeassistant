# LED Wall panels for my media wall

## Purchase all the sensors and components needed
[esp32](https://www.amazon.es/Tablero-Desarrollo-ESP-WROOM-32-ESP-32S-Bluetooth/dp/B071JR9WS9/ref=sr_1_9?crid=2IX8Y5R7MXL6J&keywords=12v+esp32&qid=1651913171&s=electronics&sprefix=12v+esp32%2Celectronics%2C58&sr=1-9)   
[Pack of resistors](https://www.amazon.es/HUAREW-metálico-valores-resistencias-surtido/dp/B09NSPVFRM/ref=sr_1_1_sspa?crid=3ERYCEIV3LGVT&keywords=resistors&qid=1651913277&s=industrial&sprefix=risistors%2Cindustrial%2C64&sr=1-1-spons&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUExWUdSTEpNS05EOFZQJmVuY3J5cHRlZElkPUEwOTc5NTkyMjAzQUZMNDBaQ1ZGTyZlbmNyeXB0ZWRBZElkPUEwOTQ2NTc2MjNWTTM4MEhUNkNLWSZ3aWRnZXROYW1lPXNwX2F0ZiZhY3Rpb249Y2xpY2tSZWRpcmVjdCZkb05vdExvZ0NsaWNrPXRydWU=)  
[N-channel MOSFETs](https://www.amazon.es/gp/product/B087LXSXNF/ref=ppx_yo_dt_b_asin_title_o04_s00?ie=UTF8&psc=1)  
[12v power supply](https://www.amazon.es/gp/product/B0151MBLY0/ref=ppx_yo_dt_b_asin_title_o05_s00?ie=UTF8&th=1)  
[12v LED Strips](https://www.amazon.es/gp/product/B0151MBLY0/ref=ppx_yo_dt_b_asin_title_o05_s00?ie=UTF8&th=1)  

Wood, wall hooks and wallpaper can be purchased from your local DIY store.  

### Step 1
i started by using some project board and soldering on the gpio ins so the esp32 can be easily replaced if necessary.  
I also used screw terminals for the wires and soldered wires to the necessary pins.   
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/1.jpg" width="300px">  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/2.jpg" width="300px">  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/3.jpg" width="300px">  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/4.jpg" width="300px">   
*Its not in the previous pictures but i added screw terminals for a push button switch thats placed on my wall to toggle the lights on and off.*

### Step 2
Flash The esp32 With the ESPHome config.  
The code i used is below:  
```
substitutions:
  espname: "mediawalllights"
  placename: "Media Wall"
  hostname: "Lights"
  ssid: "your_wifi_ssid"
  ssidpassword: "your_wifi_password"

esphome:
  name: $espname
  platform: ESP32
  board: esp-wrover-kit

wifi:
  ssid: $ssid
  password: $ssidpassword
  fast_connect: true
  ap:
    ssid: $espname
    password: "1234567890"

captive_portal:
logger:
api:
ota:

output:
  - platform: ledc
    pin: GPIO18
    id: pwm_gpio
    frequency: 100Hz
    zero_means_zero: True

light:
  - platform: monochromatic
    output: pwm_gpio
    id: pwm_light
    name: $placename
    #default_transition_length: 700ms
    effects:
      - flicker:
      - random:
      - pulse:
      - pulse:
          name: "Fast Pulse"
          transition_length: 0.5s
          update_interval: 0.5s
      - pulse:
          name: "Slow Pulse"
          # transition_length: 1s      # defaults to 1s
          update_interval: 2s
      - strobe:

switch:
  - platform: restart
    name: Restart $placename $hostname

binary_sensor:
  - platform: gpio
    pin:
      number: GPIO13
      mode: INPUT_PULLUP
      inverted: true
    name: $hostname Button
    internal: true
    on_click:
      - min_length: 70ms
        max_length: 500ms
        then:
          - light.toggle: pwm_light
```

### Step 3
Essentially you need to connect the + of your 12v power supply to the VIN pin of the esp32 and also to the + output to the LEDs.  
The - of your 12v power supply goes to the GND of the esp32 and the source of the MOSFET.  
GPIO18 of the esp32 goes to the gate of the MOSFET with a 10k resistor between.  
then the drain of the MOSFET goes to the - output to the LEDs.  
Here is a badly drawn schematic.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/21.jpg" width="300px">  

### Step 4
Once all everything is connected it should work and you should be able to control the power and brightness in homeassistant.  
*If you drop the brightness down below 10% they go off completely.*   
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/5.JPG" width="300px"> <img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/19.png" width="300px">   

### Step 5
Next i built the panels by adding some 5cm standoffs to the back of pieces of chipboard.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/7.JPG" width="300px"> <img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/8.JPG" width="300px"> <img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/9.JPG" width="300px">   

### Step 6
When i built the media wall i ran tubes to the centre in preparation for the led power cables.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/10.JPG" width="300px">    

### Step 7
Quick position test to make sure they fit nicely and are both level.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/11.JPG" width="300px">     

### Step 8
I took the boards back off to install the led strips to the back of each board.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/12.JPG" width="300px">   

### Step 9
I ran the LEDS 4-5cm from the edge of the panel from the top centre all the way around using the adhesive on the LED strips
and some staples to hold them in place more permanently.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/13.JPG" width="300px"> <img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/14.JPG" width="300px">   

### Step 10
After mounting the panels and wiring up the LEDs, I put the power supply and the esp32 into an electrical box that sits inside the media wall.
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/15.JPG" width="300px"> <img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/16.JPG" width="300px">  

## And here it is!
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/17.JPG" width="300px">  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/led_wall_panels/images/18.JPG" width="300px">  
