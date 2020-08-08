# Useful Tasmota information!

## button and switch retain command:
```
Backlog SwitchRetain off; ButtonRetain on; ButtonRetain off; PowerRetain on
```
I run this backlog on all of my tasmota switches. This way homeassistant knows exactly what state the switch is in, even after a power cut or reboot.
The switchretain should always be off, the buttonretain is on then off again to have an empty retain message in case there are any lingering around, then the powerretain

## using touch momentary switches:
* `ledpower 0` This turns off the green led on the board because you can see it through the cracks
* `switchmode 3` This turns the button into a momentary switch
* `switchmode3 0` This makes momentary switchmode a toggle switch not on/off so it toggles the state no matter what home assistant is set to


## Long press function in tasmota
Using a button/momentary switch you can make use of the long press function in tasmota to execute an automation. To do so, in the tasmota console type the following:  
`switchmode1 6` or `switchmode1 5` Depending on if you want the relay to activate when you press the button or release it.  
Next type `setoption32 10` This enables long press and sets the trigger time to 1 whole second.  

*Now you need rules*  
* Here is a rule for a single relay device:  
`rule1 on switch#state=2 do power toggle endon on switch#state=3 do publish stat/bedroom/POWER HOLD endon` The first section keeps the normal functionality of the relay, press and release, the relay toggles. The 2nd part publishes an MQTT message when the button/momentary switch is held down.  

* Here is a rule for a dual relay device:  
`rule1 on switch1#state=2 do power1 toggle endon on switch2#state=2 do power2 toggle endon on switch1#state=3 do publish stat/livingroom/POWER1 HOLD endon on switch2#state=3 do publish stat/livingroom/POWER2 HOLD endon` I keep the publish topic the same as my devices mqtt topic and just create a payload of HOLD.  

Now in homeassistant you can create an automation that does something when you hold down the button/momentary switch:
```
alias: Living room light long press - Toggle lamp
initial_state: true
trigger:
  platform: mqtt
  topic: stat/livingroom/POWER1
  payload: "HOLD"
  encoding: "utf-8"
action:
  - entity_id: light.lamp
    service: light.toggle
```


## Sonoff RF:
* RF code rule. Change the RF codes in the rule to suit your devices:
```
rule1 on rfreceived#Data=18290E do publish2 home/sonoffrf/rfrecieve 18290E endon on rfreceived#Data=18290A do publish2 home/sonoffrf/rfrecieve 18290A endon on rfreceived#Data=14AB0A do publish2 home/sonoffrf/rfrecieve 14AB0A endon on rfreceived#Data=14AB0E do publish2 home/sonoffrf/rfrecieve 14AB0E endon
```
* In homeassistant you can set a binary sensor to switch on/off according to the RF code:
```
- platform: mqtt
  name: "Front Door"
  state_topic: "tele/sonoffrf/RESULT"
  value_template: '{{value_json.RfReceived.Data}}'
  payload_on: "14AB0A"
  payload_off: "14AB0E"
  device_class: door
  qos: 1
```
* If the RF device doesn't have a code for the off position you can add an `off_delay` This example will turn the binary sensor off after 3 seconds of receiving the on code.  
```
- platform: mqtt
  name: "Front Yard"
  state_topic: "tele/sonoffrf/RESULT"
  value_template: '{{value_json.RfReceived.Data}}'
  payload_on: "EC2EEE"
  payload_off: "OFF"
  off_delay: 3
  device_class: motion
  qos: 1
```


## Restart using timer 1:
In tazmota, set timer 1 and save
`rule1 on Clock#Timer=1 do Restart 1 endon`
`

## Add PIR sensor to switch2

* `rule1 on switch2#state do publish2 livingroom/pir %value% endon`
* `switchmode2 1` This is so the pir sends a 1 or 0 as the mqtt payload.



## Calibrating the power monitoring in tazmota
If we have a known load connected e.g 60W bulb on a 240V supply with 250mA Current. Issue the commands below to auto calibrate Power, Current and Voltage respectively
```
PowerSet 60
VoltageSet 240
CurrentSet 250
```


## Remember to switch on rules:
* `rule1 1` (switches on rule 1)
* `rule1 0` (switches off rule 1)


## Tasmota templates website with a list of many devices:
* [Click Here](https://blakadder.github.io/templates/) - There are many templates to look at

Shelly 2.5 template.
* `{"NAME":"Shelly 2.5","GPIO":[56,255,17,255,21,83,0,0,6,82,5,22,156],"FLAG":2,"BASE":18}`



## Set a rule to switch off relay after 1 second
`Rule1 on power1#state=1 do backlog delay 10 ; power1 0 endon`
