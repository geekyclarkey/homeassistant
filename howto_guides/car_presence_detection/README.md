# Car Presence Detection

## Purchase the components
Obviously as of the nature of my GitHub you will need Homeassistant. [Click Here](https://www.home-assistant.io/) to find out more about Homeassistant.  
Below are links to the device i used.  
[D1 Mini](https://www.banggood.com/custlink/Gm3KgKZrD4)  

## Link to the how to guide  

This guide is perfectly written with links to all alternative setups you will need to do.  
I don't think there is any need for me to make another one. [Click Here](https://community.home-assistant.io/t/wifi-mqtt-car-presence-sensor-for-garage-door-automation/32886) to go to the guide.  

He uses the D1 mini pro because it has an external antenna. I have an access point in my garage so the wifi of the original D1 is more than enough. Its up to you.  

## Setting up the automation
Here i will show you how i have my car presence automation set up.  
I know Luma also shows you in his how-to but why not?  

Once you have the car presence modules as an entity in Homeassistant you can use the following automations to your automations.yaml:


```
- alias: Car Presence Auto Open
 trigger:
   - platform: state
     entity_id: binary_sensor.CarPresence
     to: 'on'
   - platform: state
     entity_id: binary_sensor.CarPresenceHayley
     to: 'on'
 condition:
 - condition: state
   entity_id: binary_sensor.garage_door
   state: 'off'
 action:
 - service: script.open_garage_door
```  
This will open the garage door (Run the `script.open_garage_door`) when either `binary_sensor.CarPresence` or `binary_sensor.CarPresenceHayley` become `on` in Homeasistant.  
This will happen when either i put the keys into the ignition of my car or my wife's car. Also when any one of us arrive home and the module connect to the wifi, it also becomes `on`  


```
- alias: Car Presence Auto Close 1
 trigger:
   platform: state
   entity_id: binary_sensor.CarPresence
   to: 'off'
 condition:
   condition: and
   conditions:
     - condition: state
       entity_id: binary_sensor.garage_door
       state: 'on'
     - condition: state
       entity_id: script.close_garage_door
       state: 'off'
     - condition: state
       entity_id: binary_sensor.CarPresenceHayley
       state: 'off'
 action:
 - service: script.close_garage_door
```
This will close the garage door (Run the `script.close_garage_door`) when `binary_sensor.CarPresence` becomes `off` in Homeasistant. There is a condition that checks to see if `binary_sensor.CarPresenceHayley` is also off and if `binary_sensor.garage_door`(the reed sensor on the garage door) is open.  


```
- alias: Car Presence Auto Close 2
 trigger:
   platform: state
   entity_id: binary_sensor.CarPresenceHayley
   to: 'off'
 condition:
   condition: and
   conditions:
     - condition: state
       entity_id: binary_sensor.garage_door
       state: 'on'
     - condition: state
       entity_id: script.close_garage_door
       state: 'off'
     - condition: state
       entity_id: binary_sensor.CarPresence
       state: 'off'
 action:
 - service: script.close_garage_door
```
This will close the garage door (Run the `script.close_garage_door`) when `binary_sensor.CarPresenceHayley` becomes `off` in Homeasistant. There is a condition that checks to see if `binary_sensor.CarPresence` is also off and if `binary_sensor.garage_door`(the reed sensor on the garage door) is open.  

I hope this helps someone. I did a demonstration on my Instagram [click here](https://www.instagram.com/p/B-69Z2fgNe0/) to see it. Consider following me, i post all of my projects and ideas. 
**I have to say, I use this device and automation every day. I would like to give a huge thanks to Luma for showing us how its done.**  

## All credit has to go to Luma
[Here](https://github.com/aderusha) is a link to his GitHub page. Consider buying him a coffee.
