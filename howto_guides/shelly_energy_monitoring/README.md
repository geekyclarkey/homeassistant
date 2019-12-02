# Whole Home Energy Monitoring With The Shelly EM

## Purchase the components
Below are links to the devices i used.  
[Shelly EM](https://shop.shelly.cloud/shelly-em-50a-clamp-wifi-smart-home-automation-1#139)   

### Setup the Shelly EM in the Shelly App
I haven't flashed the Shelly EM with tasmota. This demonstration uses the Shelly EM stock firmware.  

Follow the on screen instructions to add the Shelly EM to your home network.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/shelly_energy_monitoring/images/shelly_menu_icon.jpeg" width="400px">  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/shelly_energy_monitoring/images/shelly_add_device.jpeg" width="400px">  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/shelly_energy_monitoring/images/shelly_wifi_config.jpeg" width="400px">  

Log onto your Shelly EM's web UI  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/shelly_energy_monitoring/images/shelly_ui.png" width="400px">  
Go to `Internet & Security` then click on `Advanced - Developer Settings`
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/shelly_energy_monitoring/images/shelly_advanced.png" width="400px">  
Type in your MQTT server, username and password Make note of the Topic, (Don't change it) you will need that part next. Click `Save`  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/shelly_energy_monitoring/images/shelly_mqtt.png" width="400px">  

### Add the Shelly EM to your configoration.yaml
in the sensors section add the following:
```
sensor:
  - platform: mqtt
    name: "Shelly EM Power"
    state_topic: "shellies/shellyem-B9F079/emeter/0/power"
    unit_of_measurement: "W"    
  - platform: integration
    source: sensor.shelly_em_power
    name: "Shelly EM Energy"
    unit_prefix: k
    round: 2
```
You can change the name if you like but remember to use the alternative name later on in your setup.  
*You* **will** *need to change the MQTT state topic to your shelly em´s state topic*

### Add More in depth sensors
This next section will use the shelly em power entity and create a cost per KWH. mine in this case is 0.158 euroes per kwh (You will need to change the price per kwh to your tariff)  
still in the sensors section add the following:  
```
sensor:
  - platform: template
    sensors:
      current_energy_cost:
        friendly_name: Current Energy Cost
        value_template: '{{ ((states.sensor.shelly_em_power.state | float * 1 / 1000 * 0.158)) | round(2) }}'
        unit_of_measurement: 'Euro'
```

This next section will use the reading from the utility meter (see next step below) to create an entity showing you todays electricity cost  
still in the sensors section add the following:  
```
sensor:
  - platform: template
    sensors:
      todays_energy_cost:
        friendly_name: Todays Energy Cost
        value_template: '{{ ((states.sensor.home_energy_meter_daily.state | float * 0.158)) | round(2) }}'
        unit_of_measurement: 'Euro'
```

### Add a Utility Meter to your Homeassistant
In your configoration.yaml add a utility meter section if you don't have one by adding the following  
This will create a monthly, weekly and daily reading of your energy readings and store them as entities in your homeassistant.  
```
utility_meter:
  home_energy_meter_monthly:
    source: sensor.shelly_em_energy
    cycle: monthly
  home_energy_meter_weekly:
    source: sensor.shelly_em_energy
    cycle: weekly
  home_energy_meter_daily:
    source: sensor.shelly_em_energy
    cycle: daily
```

### Show your Energy Monitoring in Homeassistant UI

<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/shelly_energy_monitoring/images/home_energy_card.jpeg" width="400px">  

Create a new lovelace card and choose manual card from the bottom  
Copy and paste the following to see the same format as in the example picture  
```
entities:
  - entity: sensor.shelly_em_power
    icon: 'mdi:flash'
    name: Current Power Usage
  - entity: sensor.current_energy_cost
    icon: 'mdi:currency-eur'
  - entity: sensor.home_energy_meter_daily
    icon: 'mdi:alpha-d-circle'
    name: Todays Power Usage
  - entity: sensor.home_energy_meter_weekly
    icon: 'mdi:alpha-w-circle'
    name: This Weeks Power Usage
  - entity: sensor.home_energy_meter_monthly
    icon: 'mdi:alpha-m-circle'
    name: This Months Power Usage
  - entity: sensor.todays_energy_cost
    icon: 'mdi:currency-eur'
show_header_toggle: false
title: Home Energy Monitering
type: entities
```
If you changed and names in your config you will need to edit this example to accommodate.  
