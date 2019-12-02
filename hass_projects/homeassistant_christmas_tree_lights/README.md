# Homeassistant Christmas Tree Lights
How to make any standard, dumb christmas tree lights smart.  
I have done this using a D1 Mini and relay because the lights have a contoller that cycles through effects. to make use of these effects we need to simulate pressing the button on the controler to cycle through the different options.  
The realy will go on and off within 300 miliseconds simulating the press of the button. We do this using rules in tasmota. (More info below)
While i had a D1 Mini in there i decided to use a 2 channel relay and also power the lights with that instead of using a smart plug or sonoff.  

## Purchase the components needed
Below are links to the devices i used.  
[D1 Mini](https://www.banggood.com/custlink/Gm3KgKZrD4)  
[2 Channel Relay](https://www.banggood.com/custlink/K3mveKON0G)  
[Dupont Junper Cables](https://www.banggood.com/custlink/vDvD6DjOQt)

### The Main Build  
Lets build the project. Follow the steps below to recreate what i have.

<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/homeassistant_christmas_tree_lights/images/lights_pcb.jpeg" width="300px">  
First take the controler apart and inspect the PCB.  
You need to locate the button that you press to cycle through the effets.  
using the continuity feature of a multimeter, find 2 pins that make contact when the button is pressed.  

<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/homeassistant_christmas_tree_lights/images/lights_pcb_soldered.jpeg" width="300px">  
Solder 2 thin wires to the two pins that you have determined. Make sure thet are long enough to come out of the controler and connect to your relay.  

<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/homeassistant_christmas_tree_lights/images/lights_controler.jpeg" width="300px">  
Close up the controler and use cable tie to hold the soldered wires, just in case they move and break free.  

<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/homeassistant_christmas_tree_lights/images/lights_controler_with_relays.jpeg" width="300px">  
connect the soldered wires to your relay. I added them to the common and normaly open ports. It doesnt matter whether you use the normaly open or normaly closed because you can change the relay to inverted in tasmota later.  
As i said above i am also using the 2nd relay to initially power the lights so i connect one side to the normaly open side of the relay and patch a live wire into the common of the relay.  
I also added a usb plug thats connected directly to the mains wire, this will power the D1 Mini.  

### Flash Your D1 Mini With Tasmota
Because tasmota is the best! Every esp8266 chip should have tasmota.
[Click Here](https://www.youtube.com/watch?v=KMiP9Ku71To) for a video tutorial on how to flash tasmota. The video is a for the sonoff basic, but the D1 is even easier. you dont need the FTDI adaptor, and you dont need to hold down pins to put it into flash mode.  
Follow the steps on how to use the Flash Easy Firmware. Just connect your usb cable to the D1 Mini and your computer then skip the video to 4min 10sec in.
*The video is owned and created by DrZzs Check out his [website](http://drzzs.com/) and [youtube channel](https://www.youtube.com/channel/UC7G4tLa4Kt6A9e3hJ-HO8ng) for more great tutorials. If you like what he's doing consider [becoming one of his patrons](https://www.patreon.com/DrZzs/overviewbuying) to thank him for all of his hard work*

### Use Termite to set up your D1 Mini
Like DrZzs did in the video, open termite and use the backlog command to add your wifi and MQTT into onto the D1 Mini.  
Make sure to reboot youur D1 Mini after flashing before starting this part, and make sure you have the correct com port selsicted and the baud rate is set to 115200  

### Connect the wires to your D1 Mini
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/homeassistant_christmas_tree_lights/images/lights_all_connected.jpeg" width="300px">  
Next Connect up the D1 Mini. **Please make sure you have flashed your D1 before connecting up these cables.** Flashing while they are connected could damage your D1 Mini.

* Connect the VCC to the 3.3v pin on the D1  
* Connect the ground to the G pin on the D1  
* Connect the in1 to the D1 pin on the D1  
* connect the in2 to the D2 pin on the D1  
(if you are not using the D1 mini to power the lights you only need the D1 pin to be connected)  

### Set up Tasmota
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/homeassistant_christmas_tree_lights/images/lights_tasmota.jpeg" width="300px">  


```

```

