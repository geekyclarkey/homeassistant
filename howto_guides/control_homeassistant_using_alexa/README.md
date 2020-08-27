# Control homeassistant using alexa. No subscriptions or cloud services  
Learn how i control my homeassistant lights, scripts and devices using my amazon alexa with no cloud services needed and no subscriptions.
Unfortunatly the echo needs an internet connection to process any command. But the control of the devices is all happening in home locally.

## Install & Setup Node-Red
The first thing we need to do is install node-red.  
Node-red is an addon available in the supervisor section. (previously called Hass.io)  
* Make your way to the add-on store page, search and install the node-red addon.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/node_red_addon.PNG">   

* Follow the installation instructions and start the node-red addon.  

## Setup Node-Red
Firstly we are going to install the amazon alexa pallet.  
* go to the hamburger icon in the top right and click on manage pallet  
* Click on the install tab and search for `node-red-contrib-amazon-echo`
* install the pallet  

If you are using MQTT you need to add your broker in so we can use the MQTT nodes.
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/mqtt_nodes.PNG">    

* Drag out a MQTT node and double click it.
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/mqtt_in_node_red.PNG">  

* Give the Broker a name. (`Mosquitto` for example)
* Click the pencil next to server and add your broker server ip address.
* Click the security tab and add your MQTT username and password.
* Click Update in the top right

## Now we need to create some flows  
Below i have separated each flow individually but you can only have one Amazon Echo Hub on your flow.
You should end up with something like this:  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/whole_alexa_flow.PNG">  

### For Lights that are using MQTT we can set our flow like this
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/mqtt_flow.PNG">  

From left to right we have:  

* MQTT in node - with the state topic of the light we are controlling.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/mqtt_in.PNG">   

* Function node - for the alexa-hass sync. (i´ll explain more on this further down)  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/sync_function.PNG">   

* The Amazon Echo Hub node - Set `process input` to `process`  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/amazon_hub.PNG">   

* The Amazon Echo Device Node - Type in the name of your light (this is the name ask alexa to control)  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/amazon_device_kitchen.PNG">   

* MQTT out node - with the command topic of the light we are controlling.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/mqtt_out.PNG">   


### For scripts you want to execute we can set our flow like this
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/script_flow.PNG">   

From left to right we have:  

* Events-state node - this will let alexa know if homeassistant changes the device.
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/event_state_node_script.PNG">   

* Function node - for the alexa-hass sync. (i´ll explain more on this further down)  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/sync_function.PNG">   

* The Amazon Echo Hub node - Set `process input` to `process`  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/amazon_hub.PNG">   

* The Amazon Echo Device Node - Type in the name of your light (this is the name ask alexa to control)  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/amazon_device_script.PNG">   

* A Switch node - To only allow on commands pass through (because scripts are set to on then go off automatically when the script has been completed)
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/switch_node.PNG">   

* Call Service node - to activate the script in homeassistant
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/call_service_script.PNG">   


### For any other entity that we want to switch on or off we can set our flow like this
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/entity_flow.PNG">   

From left to right we have:  

* Eventnts-state node - this will let alexa know if homeassistant changes the device.
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/event_state_entity.PNG">   

* Function node - for the alexa-hass sync. (i´ll explain more on this further down)  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/sync_function.PNG">   

* The Amazon Echo Hub node - Set `process input` to `process`  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/amazon_hub.PNG">   

* The Amazon Echo Device Node - Type in the name of your light (this is the name ask alexa to control)  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/amazon_device_entity.PNG">   

* Function node - To determine if the requested service is on or off  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/on_off_function.PNG">   

The code is:  
```
if (msg.payload == "on") msg.payload = {"service":"turn_on"}
else if (msg.payload == "off") msg.payload = {"service":"turn_off"}
return msg;
```

* Call Service node - to activate the script in homeassistant
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/call_service_entity.PNG">   

* Notice there is no service in the node. thats because the service is passed in from the function node before it.

### Function node - for the alexa-hass sync

When the entity changes state this function sends the current state from the input and passes the on or off command to the echo device node telling the alexa app that the deviec has been switched on or off.
The code is:  
```
var nodeid="alexa-device-node-id";

if (msg.payload == "on"){
    msg.payload = {
        on: true,
        nodeid: nodeid
    }

} else if(msg.payload == "off"){
    msg.payload = {
        on: false,
        nodeid: nodeid
    }
}

return msg;
```
in the `var nodeid` section add the node id of the alexa device node. To find that, click on the amazon device node and see the information section at the top  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/control_homeassistant_using_alexa/images/node_id.PNG">   
copy and paste the node id from the amazon-device node into the function

## Add Devices to Alexa

As this is all local, all you need to do is ask alexa to "Discover my devices"   
It will scan your local network and find all of the alexa devises you have added.  

# Acknowledgements
I would like to thank the following people for their help in helping me figure out how to do this in the most effective way.
* [The Hookup](http://www.thesmarthomehookup.com/) Here is a link to Robs website He helped me to figure out how to sync the alexa and Homeassistant app.  
* [3ATIVE VFX Studio](https://www.youtube.com/channel/UCuDjPZFSQKFNPwPypJlgZeg) Here is a link to his youtube channel, he helped me with the service function.  

also please check out the other sites and youtube channels below. Everyone in this list are assets to the homeassistant community.  
* [Homeassistant](https://www.home-assistant.io/) Here is a link the Homeassistant website
* [Franck Nijhof](https://github.com/frenck) Here is a link to his Github page
* [DrZzs](http://drzzs.com/) Here is a link to the docs website
* [Digiblur](https://www.digiblur.com/) Here is a link to Travis website
* [Hasscasts](https://www.youtube.com/channel/UCGOCeqMJnLvr-5C-ypUw7IQ/featured) Here is a link to his youtube channel
* [BurnsHa](https://www.youtube.com/channel/UCSKQutOXuNLvFetrKuwudpg) Here is a link to his youtube channel
