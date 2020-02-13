# Control homeassistant using alexa. No subscriptions or cloud services  
Learn how i control my homeassistant lights, scripts and devices using my amazon alexa with no cloud services needed and no subscriptions.
Unfortunatly the echo needs an internet connection to process any command. but the control of the devices is all happening in home locally.

## Install & Setup Node-Red
The first thing we need to do is install node-red.  
Node-red is an addon availiable in the supervisor section. (previously called Hass.io)  
* Make your way to the add-on store page, search and install the node-red addon.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/hassio_google_backup/images/hassio_page.PNG" width="400px">  
* Follow the instalation instructions and start the node-red addon.  

## Setup Node-Red
Firstly we are going to install athe pallet.  
* go to the hamburger icon in the top right and click on manage pallet  
* Click on the install tab and search for `node-red-contrib-amazon-echo`
* install the pallet  

If you are using MQTT you need to add your broker in sop we can use the MQTT nodes.
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/hassio_google_backup/images/hassio_page.PNG" width="400px">   
* Drag out a MQTT node and double click it. 
* Give the Broaker a name. (`Mosquitto` for example) 
* Click the pencil next to server anc add your broaker server ip address.
* Click the security tab and add your MQTT username and password.
* Click Update in the top right 

## Now we need to create some flows  
### For Lights that are using MQTT we can set our flow like this
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/hassio_google_backup/images/hassio_page.PNG" width="400px">  

From left to right we have:  

* MQTT in node - with the state topic of the light we are controlling.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/hassio_google_backup/images/hassio_page.PNG" width="400px">  

* Function node - for the alexa-hass sync. (i´ll explain more on this further down)  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/hassio_google_backup/images/hassio_page.PNG" width="400px">  

* The Amazon Echo Hub node - Set `process input` to `process`  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/hassio_google_backup/images/hassio_page.PNG" width="400px">  

* The Amazon Echo Device Node - Type in the name of your light (this is the name ask alexa to control)  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/hassio_google_backup/images/hassio_page.PNG" width="400px">  

* MQTT out node - with the command topic of the light we are controlling.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/hassio_google_backup/images/hassio_page.PNG" width="400px">  


### For scripts that we want to exicute we can set our flow like this






## Add Devices to Alexa

# Acknowledgments
I would like to thank the following people for their help in helping me figure out how to do this in the most effective way.
* [The Hookup](http://www.thesmarthomehookup.com/) Here is a link to Robs website He helped me to figure out how to sync the alexa app with th Homeassistant app.  
* [3ATIVE VFX Studio](https://www.youtube.com/channel/UCuDjPZFSQKFNPwPypJlgZeg)Here is a link to his youtube channel, he helped me with the service function.  

also please check out the other sites and youtube channels below. Everyone in this list are assets to the homeassistant community.  
* [Homeassistant](https://www.home-assistant.io/) Here is a link the Homeassistant website
* [Franck Nijhof](https://github.com/frenck) Here is a link to his Github page
* [DrZzs](http://drzzs.com/) Here is a link to the docs website
* [Digiblur](https://www.digiblur.com/) Here is a link to Travis website
* [Hasscasts](https://www.youtube.com/channel/UCGOCeqMJnLvr-5C-ypUw7IQ/featured) Here is a link to his youtube channel
* [BurnsHa](https://www.youtube.com/channel/UCSKQutOXuNLvFetrKuwudpg) Here is a link to his youtube channel 
