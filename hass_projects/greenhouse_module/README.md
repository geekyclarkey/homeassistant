# All In One Greenhouse Management Station

I don't have a greenhouse myself but my uncle does. Even though we both live in different countries we have found a way to create this via video calls and messages.   
We have both been working together to make the ultimate greenhouse module with fully automated watering system and so much more.  
Light, humidity, motion sensors and relays to control everything from the irrigation to the heating and cooling.  
This project was fun for me as i felt like a teacher, guiding my uncle through the setup procedure. Even though i didn't get my hands dirty i still feel like i accomplished something.  

## Purchase all the sensors and components needed
[ESP32](https://www.banggood.com/custlink/mKDDMq5dIY)   
[BH1750FVI Digital Light Intensity Sensor](https://www.banggood.com/custlink/DGKG0KZp3q)  
[21mm PIR Motion Sensor](https://www.banggood.com/custlink/KmKGeGan88) or [Mini IR Infrared Pyroelectric PIR](https://www.banggood.com/custlink/3KK3BDIEwm)  
[HTU21D Temperature Humidity Sensor](https://www.banggood.com/custlink/m3KG0m8CYD) or [SHT30 Temperature Humidity Sensor](https://www.banggood.com/custlink/G33KeDOeZO)  
[8 Channel Relay](https://www.banggood.com/custlink/vKGK4mLbe4)  
[Capacitive Soil Moisture Sensor](https://www.banggood.com/custlink/D3GmqQcD4V)  
[3/4" Male to Male Solenoid Water Valve](https://www.banggood.com/custlink/mGDmM2sWTu)  

## Hardware

## Software
We used ESPHome for this. You need to have ESPHome addon installed in Homeassistant. See [here](https://esphome.io/guides/getting_started_hassio.html) for instructions on how to do that.  
Once thats installed you will need to create a new ESPHome file. Create a dummy file using the `+` icon and give it the name `greenhousemodule`  
Here is a copy of the ESPHome code we used. You may need to adapt this to your sensors.  
```
substitutions:
  espname: "greenhousemodule"
  hostname: "Greenhouse"
  ssid: "yourwifiname"
  ssidpassword: "yourwifipassword"

esphome:
  name: $espname
  platform: ESP8266
  board: nodemcuv2

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

i2c:
  sda: D3
  scl: D4
  scan: True
  id: bus_a

sensor:
  - platform: uptime
    name: $hostname Uptime

  - platform: wifi_signal
    name: $hostname WiFi Signal
    update_interval: 60s

  - platform: htu21d
    temperature:
      name: $hostname Temprature
      filters:
        - calibrate_linear:
          - 0.0 -> 0.0
          - 23.3 -> 23.8
    humidity:
      name: $hostname Humidity
    update_interval: 10s

  - platform: bh1750
    name: $hostname Brightness
    address: 0x23
    update_interval: 10s
    filters:
      - calibrate_linear:
        - 0.0 -> 0.0
        - 196.3 -> 118.0

  - platform: adc
    name: $hostname Soil Moisture Level
    update_interval: 2s
    pin: A0
    filters:
      - lambda: |-
          if (x > 0.81) {
            return 0;
          } else if (x < 0.48) {
            return 100;
          } else {
             return (0.81-x) / (0.81-0.48) * 100.0;
          }
    accuracy_decimals: 0
    icon: mdi:cup-water
    unit_of_measurement: "%"

binary_sensor:
  - platform: gpio
    pin:
      number: D5
      mode: INPUT_PULLUP
    name: $hostname Movement
    device_class: motion

switch:
  - platform: restart
    name: Restart $hostname

  - platform: gpio
    name: $hostname Irrigation
    pin: D1
    id: irrigation
    icon: "mdi:water-pump"


text_sensor:
  - platform: wifi_info
    ip_address:
      name: $hostname IP Address
```

### Lets break this down:  
* Here you will need to put your wifi ssid and password. Nothing special.  
```
substitutions:
  espname: "greenhousenodemcu"
  hostname: "Greenhouse"
  ssid: "yourwifiname"
  ssidpassword: "yourwifipassword"
```

* This will use the wifi info you entered above and if the board can not connect to your wifi it will generate its own wifi name so you can connect to it and adapt the wifi config. The password for the captive portal is set to `1234567890` you can change this if you like.  
```
wifi:
  ssid: $ssid
  password: $ssidpassword
  ap:
    ssid: $espname
    password: "1234567890"

captive_portal:
```

* This is the I2C bus, because we have sensors that use I2C we need to tell ESPHome what pins we used for the clock and data. If you followed out pinout you wont need to change anything.  
```
i2c:
  sda: D3
  scl: D4
  scan: True
  id: bus_a
```

* Here is the Temp and humidity sensor. As you can see we slightly calibrated the temperature sensor. To do this you need another temperature sensor for a reference. Then the 23.3 is what ESPHome was saying the temp was and 23.8 was another more accurate sensor said. Now ESPHome will make amendments to its value to show more accurate reading.  
```
- platform: htu21d
  temperature:
    name: $hostname Temprature
    filters:
      - calibrate_linear:
        - 0.0 -> 0.0
        - 23.3 -> 23.8
  humidity:
    name: $hostname Humidity
  update_interval: 10s
```

* The same calibration was made to the Brightness sensor. If you don't have another brightness sensor to compare then its not essential to have a true lux reading. You only need it as a reference to how light or dark it is. You can just use whatever value you would consider to be dark or light in the automations. its not crucial.
```
- platform: bh1750
  name: $hostname Brightness
  address: 0x23
  update_interval: 10s
  filters:
    - calibrate_linear:
      - 0.0 -> 0.0
      - 196.3 -> 118.0
```

* This is for the capacitive soil sensor. We set up the lambda filter like so...   
First comment out the lambda filter and boot up the board with the soil sensor connected. As the sensor is analogue you will see a voltage reading.  
Now check the logs of ESPHome to see the values when you do the following, when the sensor is completely dry add that to the if statement `0.81` then take a reading when it was submerged in water and added that to the esle if statement `0.48` Now in the else statement you need to add the values again using mine as a reference, this will give you a percentage from dry 0% to wet 100% and everything in-between.  
```
- platform: adc
  name: $hostname Soil Moisture Level
  update_interval: 2s
  pin: A0
  filters:
    - lambda: |-
        if (x > 0.81) {
          return 0;
        } else if (x < 0.48) {
          return 100;
        } else {
           return (0.81-x) / (0.81-0.48) * 100.0;
        }
  accuracy_decimals: 0
  icon: mdi:cup-water
  unit_of_measurement: "%"
```

* This is the motion sensor, You may or may not need the `INPUT_PULLUP` Remove it if necessary.  
```
binary_sensor:
  - platform: gpio
    pin:
      number: D5
      mode: INPUT_PULLUP
    name: $hostname Movement
    device_class: motion
```

## Homeassistant
ESPHome devices are generally automatically found by Homeassistant and all you need to do is click the notification and add the device to your home automation server.  
You can then find the entities from the `Intergrations` section of your Homeassistant.  

We used a template sensor here to show the soil state according to the percentage value of the soils sensor. You may need to change the values to better suit your setup.  
Add the following the sensor section of your configoration.yaml adapt the entity id if you used something else.  
```
- platform: template
  sensors:
    greenhouse_soil_moisture_state:
      friendly_name: "Soil Moisture State"
      value_template: >-
        {% if states('sensor.greenhouse_soil_moisture_level')|float < 25 %}
          Dry
        {% elif states('sensor.greenhouse_soil_moisture_level')|float >= 25 and states('sensor.greenhouse_soil_moisture_level')|float < 40 %}
          Moist
        {% elif states('sensor.greenhouse_soil_moisture_level')|float >= 40 and states('sensor.greenhouse_soil_moisture_level')|float < 60 %}
          Very Moist
        {% elif states('sensor.greenhouse_soil_moisture_level')|float >= 60 and states('sensor.greenhouse_soil_moisture_level')|float < 80 %}
          Wet
        {% else %}
          Saturated
        {% endif %}
```

Now the entities are in Homeasistant we can start adding them into lovelace.  

## Automations

Here is an automation that turns the irrigation Solenoid on and off according to the moisture levels. Again, you may need to change the values to better suit your setup.  
Add the following to your automations.yaml
```
- alias: Irrigation auto turn on
  trigger:
    - platform: numeric_state
      entity_id: sensor.greenhouse_soil_moisture_level
      below: 25
  action:
    - service: switch.turn_on
      entity_id: switch.greenhouse_irrigation

- alias: Irrigation auto turn off
  trigger:
    - platform: numeric_state
      entity_id: sensor.greenhouse_soil_moisture_level
      above: 60
  action:
    - service: switch.turn_off
      entity_id: switch.greenhouse_irrigation
```









### Thats it! Have fun trying it for yourself.
