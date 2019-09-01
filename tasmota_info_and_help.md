# Useful Tasmota information!

## button and switch retain command:
```
Backlog SwitchRetain off; ButtonRetain on; ButtonRetain off; PowerRetain on
```


using touch momentary switches:
* `ledpower 0` This turns off the green led on the board because you can see it through the cracks
* `switchmode 3` This turns the button into a momentary switch
* `switchmode3 0` This makes momentary switchmode a toggle switch not on/off so it toggles the state no matter what home assistant is set to



## Sonoff RF Rule:
Change the RF codes in the rule to suit your devices:
```
rule1 on rfreceived#Data=18290E do publish2 home/sonoffrf/rfrecieve 18290E endon on rfreceived#Data=18290A do publish2 home/sonoffrf/rfrecieve 18290A endon on rfreceived#Data=14AB0A do publish2 home/sonoffrf/rfrecieve 14AB0A endon on rfreceived#Data=14AB0E do publish2 home/sonoffrf/rfrecieve 14AB0E endon
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



### Set a rule to switch off relay after 1 second
`Rule1 on power1#state=1 do backlog delay 10 ; power1 0 endon`
