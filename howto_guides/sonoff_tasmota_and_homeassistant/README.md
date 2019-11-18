# Sonoff, Tasmota and Homeassistant
Here is tips i have found about the sonoff and using it with homeassistant.

## Purchase the components
Below are links to the devices i used.  


### Adding a Low Pass Filter
When using a sonoff and using gpio pins to switch the relay, if the sonoff is installed in the wall or near high fequeuncy electricicty cables you may experience ghost switching.  
Thats when the relay switches on and off randomly. To avoid this you can install a low pass filter.  

You put a resistor between the GPIO pin you’re using and a 3.3v pin.  And you put a capacitor between the GPIO pin you’re using and Ground.  
*I use a 4.7k ohm resistor and a 33 nanofarad capacitor.  

<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/sonoff_tasmota_and_homeassistant/images/lpf1.jpeg" width="400px">  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/sonoff_tasmota_and_homeassistant/images/lpf2.jpeg" width="400px">  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/sonoff_tasmota_and_homeassistant/images/lpf3.jpeg" width="400px">  

It works because the capacitor allows higher frequency signals to pass through easily but it creates high resistance to low frequency signals. In our case the signal we want to pass through is just dc voltage, there’s no frequency at all. The interference that is causing our ghost switching is high frequency. The resistor is there to direct the load current through the capacitor. 

The same thing will work to keep interference from messing with other devices, like a D1 mini, or a NodeMCU.   












## Disclaimer
I found out this information from [DrZzs](http://drzzs.com/) Here is a link to the docs website.  Im only adding it to my github so i can access the info easily in the future.
[Here](https://www.youtube.com/watch?v=aq8_os6g13s&t=173s) is a link to his youtube video on the subject.

I would not know what i do about homeassistant without this man and many others in the homeassistant comunity. So please, All credit has to go to those guys.