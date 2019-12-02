# How to change TV channels with your Alexa

## Purchase the components
Obviously as of the nature of my GitHub you will need Homeassistant. [Click Here](https://www.home-assistant.io/) to find out more about Homeassistant.  
Below are links to the devices i used.  
[Broadlink RM Mini](https://www.banggood.com/Broadlink-Black-Bean-Smart-Home-Wifi-Remote-IR-Controller-Universal-Appliances-Smart-Control-p-1049494.html?p=VJ050124584579201809&custlinkid=605494&cur_warehouse=CN)  
[Amazon Echo](https://www.amazon.es/echo-dot-3-generacion-altavoz-inteligente-con-alexa-tela-de-color-antracita/dp/B07PHPXHQS/ref=sr_1_3?__mk_es_ES=%C3%85M%C3%85%C5%BD%C3%95%C3%91&keywords=echo&qid=1575247703&smid=A1AT7YVPFBWXBL&sr=8-3)  

### Set up your Broadlink RM Mini
I have already done a writeup on how to setup the broadlink RM  [Click Here](https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/broadlink_rm_mini3_and_homeassistant/README.md) to check it out.  
Come back here when you have that part sorted to continue with the setup.  

### Create Remote Control Scripts
Simulate button presses using the Broadlink RM in a sequence so it requests the channel you want.  
Below is a copy of my `BBC One script`
```
livingroom_bbc1:
  alias: "BBC One"
  sequence:
     - service: broadlink.send
       data:
         host: 192.168.10.91
         packet:
           - "JgAsAB4dPB0eOh4dHh08Oh4dPDo8Oh4AC54eHTwdHToeHh4dPDoeHTw6OzseAA0FAAAAAAAAAAAAAAAA" # Replicates the tv button on the Remote
           - "JgA0AB4dPB0dOh4eHR47HR4dHhweHR0dHjoeAAubHh47HR46Hh0eHTwdHhweHR4cHh0dOh4ADQUAAAAA" # Replicates the 1 button on the remote
           - "JgAWAB4eHh08Oh4dHh08Ojw6Hh08HB4ADQUAAA==" # Replicates the OK button on the remote
     - service: switch.turn_on
       entity_id: switch.samsung_tv_power
     - delay:
         seconds: 6
     - service: broadlink.send
         data:
           host: 192.168.10.91
           packet:
             - "JgBGAJKVETkRORE5ERQQFRAVERQQFRE5ETkROREUERQRFBEUERQRORAVERUPOxAVDzsQOhA6EBUQOhA6EBUQOhAVEBUPFhAADQUAAA==" # Sends the Samsung HDMI1 command
```

Lets work through the script above to explain how it works.  
All scripts start the the top of the sequence and run the service then move onto the next one.  
* the first service uses the broadlink send service to send 3 ir commands one after another.  First the TV button so the receiver loads onto live view, just in case it happens to be on the menu screen or settings for some reason.  
* Next it switches on my Samsung TV. I am using the switch part of the broadlink entity that i set up earlier. here is an example of the switch entity in my configoration.yaml
```
switch:
  - platform: broadlink
    host: 192.168.10.91
    mac: '74:2a:75:5b:ca:c9'
    friendly_name: "Livingroom RM Mini"
    timeout: 15
    switches:
      samsung_tv_power:
        friendly_name: "Samsung TV Power"
        command_on: 'JgBGAJKVETkRORA6ERQRFBEUERQRFBE5ETkQOhAVEBUQFREUEBUQOhEUERQRORE5EBURFBA6EBUQOhE5EBUQFRA6EDoRFBEADQUAAA=='
        command_off: 'JgBGAJOVEDoQOhA6DxYPFhAVEBUQFRA6ETkROREUERQRFBEUEBUQFREUERQRORE5EBUQFRE5ETkRORE5ERUQFRA6DzsPFhAADQUAAA=='

```
* Next it waits 6 seconds, you do this by adding in a `delay`. I have it wait because if the tv is off when i ask Alexa to "Switch on BBC One" the tv needs time to start up before choosing the input source. The 6 seconds delay allows for that. The down side is if the TV is already on, i still have to wait the 6 seconds for the tv to change source. As the channel change is at the start of the script, if the TV is already on the correct source, the channel changes immediately.  
* Next the broadlink sends the command to change to HDMI 1 becuase my set top box is on HDMI 1. I have a list of broadlink ir codes with some tv brands direct HDMI port commands [here](https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/broadlink_rm_mini3_and_homeassistant/Broadlink_IR_Codes.md) if your brand does not have a direct code you will not be abot to do the source change as homeassistant does not know your current source so it cant know how many times to press the source button. If you have a smart TV thats intergrated into homeassistant you can use the `media_player.select_source` service. Find out more [here](https://www.home-assistant.io/integrations/media_player/)  

### Add as many channels or simulated buttons as you like
You can create scripts for simple tasks like just one sequence. the script below will simply change the tv source to HDMI 3  
```
livingroom_hdmi3:
  alias: "HDMI 3"
  sequence:
     - service: broadlink.send
         data:
           host: 192.168.10.91
           packet:
             - "JgBGAJOUEDoRORE5ERQRFRAUERQRFBE5EDsQOhAVEBUPFg8WDxYPFhA6EBUPFg8WEBUROQ87EDoQFQ87EDoQOhA6EBUPFhAADQUAAA==" # Sends the Samsung HDMI3 command
```

### Create buttons for your channels in the homeassistant UI  
You dont need to do this for the Alexa part, but its nice to have it there in case you need it.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/howto_guides/changing_tv_channels_with_alexa/images/channel_buttons.jpeg" width="400px">  

Add the text below to a manual card in homeassistant, This config adds 2 rows of 4 buttons. You will need to change the entity names to whatever you have called your scripts:  
```
cards:
  - cards:
      - entity: script.livingroom_bbc1
        icon: 'mdi:remote'
        name: BBC 1
        tap_action:
          action: toggle
        type: entity-button
      - entity: script.livingroom_bbc2
        icon: 'mdi:remote'
        name: BBC 2
        tap_action:
          action: toggle
        type: entity-button
      - entity: script.livingroom_itv1
        icon: 'mdi:remote'
        name: ITV 1
        tap_action:
          action: toggle
        type: entity-button
      - entity: script.livingroom_itv2
        icon: 'mdi:remote'
        name: ITV 2
        tap_action:
          action: toggle
        type: entity-button
    type: horizontal-stack
  - cards:
      - entity: script.livingroom_itvbe
        icon: 'mdi:remote'
        name: ITV Be
        tap_action:
          action: toggle
        type: entity-button
      - entity: script.livingroom_e4
        icon: 'mdi:remote'
        name: E4
        tap_action:
          action: toggle
        type: entity-button
      - entity: script.livingroom_e
        icon: 'mdi:remote'
        name: E!
        tap_action:
          action: toggle
        type: entity-button
      - entity: script.livingroom_cartoon_network
        icon: 'mdi:remote'
        name: Cartoon Net
        tap_action:
          action: toggle
        type: entity-button
    type: horizontal-stack
type: vertical-stack
```

### Add your script into Alexa
To do this i use the homeassistant cloud service. It costs 5$ a month but its worth it for the ease of integrating your Alexa into homeassistant, plus it helps contribute to the developers and keeps homeassistant going. You also need the homeassistant skill installed on your Alexa device.  

You Add your new script into the cloud entity in your configoration.yaml (I have mine filtered so i can control what entities get added into my Alexa app)  
```
cloud:
  Alexa:
    filter:
      include_entities:
      - script.livingroom_bbc1
      - script.livingroom_hdmi3
```

### Ask Alexa to discover devices
Simply ask your Alexa to "discover my devices"  
She will scan and find your new scripts and see them as scenes.  
Then all you need to do is ask Alexa to "Switch on BBC One" (the Alias is the name the Alexa will use)  
She will run the script/scene and de exactly as i showed in my [Instagram Post](https://www.instagram.com/p/B5d27TIAnFZ/)  

## Thats it! have fun adding channel requests to your Alexa device.
