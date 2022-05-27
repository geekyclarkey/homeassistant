# CCTV in Homeassistant with recording

## Purchase the components needed
Below are links to the devices i used.  
[SONOFF PIR2 Wireless Infrared Detector](https://www.banggood.com/custlink/D33DBG9dwS)  
[SONOFF RF Bridge](https://www.banggood.com/custlink/DGDv0K9Jvc)  
[Reolink RLC-420-5MP PoE Camera](https://www.amazon.es/dp/B07F3CH6QQ?aaxitk=QMqLThvgTKUSpHpc00uVFA&pd_rd_i=B07F3CH6QQ&pf_rd_p=a1981982-b06b-419a-9b66-495420231b59&hsa_cr_id=9512477600402&sb-ci-n=productDescription&sb-ci-v=C%C3%A1mara%20de%20Seguridad%20PoE%20Reolink%205MP%20HD%20Ranura%20para%20Tarjeta%20SD%20incorporada%20Soporte%20de%20Audio%20Vigilancia%20en%20el%20hogar%20al%20Aire%20Libre%20IR%20Impermeable%20Visi%C3%B3n%20Nocturna%20C%C3%A1mara%20IP%20RLC-420-5MP&sb-ci-a=B07F3CH6QQ) I personally own this camera and can recommend it. The picture quality is the best i have seen so far. I have added the camera entity down below if anyone also has this camera model

### Flash Your sonoff RF Bridge with tasmota
Because tasmota is the best! Every esp8266 chip should have tasmota.
[Click Here](https://www.youtube.com/watch?v=OfSbIFIJPuc) for a video tutorial on how to flash the Sonoff RF Bridge.  
*The video is owned and created by DrZzs Check out his [website](http://drzzs.com/) and [youtube channel](https://www.youtube.com/channel/UC7G4tLa4Kt6A9e3hJ-HO8ng) for more great tutorials. If you like what he's doing consider [becoming one of his patrons](https://www.patreon.com/DrZzs/overviewbuying) to thank him for all of his hard work*

### Find out the RF code for your motion sensor.
Every device will have a different code. The example below is mine. Yours will be different so **please don't skip this part.**  
Log into the RF bridge web ui and go into the console. Wave your hans or walk in front of the sensor to trigger it. The model i used flashed green when it detects movement and sends the rf code. The RF code for your device will show up in the console.

### Set up the motion sensor in Homeassistant
Add the following to the binary_sensor section of your configuration.yaml file  
```
binary_sensor:
  - platform: mqtt
    name: "Front Yard"
    state_topic: "home/sonoffrf/rfrecieve"
    value_template: '{{value_json.RfReceived.Data}}'
    payload_on: "EC2EEE"
    payload_off: "OFF"
    off_delay: 3
    device_class: motion
```
as the motion sensor doesn't have a 2nd code for `no movement detected`. The off payload can be anything you like, just add the off_delay to switch the entity off after 3 seconds in my example.
the `state_topic: "tele/sonoffrf/RESULT"` in my example is this because i made the MQTT topic `sonoffrf` if you chose something else remember to make it the same.  
Once you have added the motion sensor as a binary sensor, restart homeassistant. I added the sensor as an entity in lovelace and tested it by walking in front of it. The entity showed as `detected` for  about 3 seconds then went back to `clear`. Everything is working correctly.

### Set up the camera as an entity
Add the camera entity into your configoration.yaml file.
```
camera:
  - platform: generic
    name: Front Yard Camera
    still_image_url: "http://username:password@192.168.10.222/SnapshotJPEG?Resolution=1280x960"
    stream_source: "rtsp://username:password@192.168.10.222/Src/MediaInput/h264/stream_1/ch_"
```
Your camera entity will probably look different, you may need to research how to add your camera into homeassistant.
I am using the Panasonic WV-SF335 and the example above is how to incorporate that particular make and model.  
You can find many stream urls from [this website](https://www.ispyconnect.com/sources.aspx)
```
camera:
  - platform: generic
    name: Garage Camera
    still_image_url: "http://192.168.10.221/cgi-bin/api.cgi?cmd=Snap&amp;channel=0&amp;rs=wuuPhkmUCeI9WG7C&amp;user=user&amp;password=password"
    stream_source: "rtsp://user:password@192.168.10.221:554/h264Preview_01_main"
```
This is the Camera entity setup for the [Reolink RLC-420-5MP PoE Camera](https://www.amazon.es/dp/B07F3CH6QQ?aaxitk=QMqLThvgTKUSpHpc00uVFA&pd_rd_i=B07F3CH6QQ&pf_rd_p=a1981982-b06b-419a-9b66-495420231b59&hsa_cr_id=9512477600402&sb-ci-n=productDescription&sb-ci-v=C%C3%A1mara%20de%20Seguridad%20PoE%20Reolink%205MP%20HD%20Ranura%20para%20Tarjeta%20SD%20incorporada%20Soporte%20de%20Audio%20Vigilancia%20en%20el%20hogar%20al%20Aire%20Libre%20IR%20Impermeable%20Visi%C3%B3n%20Nocturna%20C%C3%A1mara%20IP%20RLC-420-5MP&sb-ci-a=B07F3CH6QQ)  
Just change the username and password to your camera

### Set up the input booleans for the lovelace card
These booleans will be for us to take instant snapshots and recordings from the lovelace interface.
```
input_boolean:
  frontyardcam_snapshot:
    name: Frontyardcam Snapshot
    icon: mdi:camera
  frontyardcam_record:
    name: Frontyardcam Record
    icon: mdi:record-rec
```
Change the name to anything you like, just remember to set up the automations and scripts using the same name.

### Create the camera as a card in lovelace
Here is the lovelace card configuration
```
camera_image: camera.front_yard_camera
entities:
  - input_boolean.frontyardcam_record
  - input_boolean.frontyardcam_snapshot
  - switch.front_yard
  - binary_sensor.front_yard
title: Front Yard Camera
type: picture-glance
```
![](images/front_yard_card.PNG)

### Create the directory for your recordings and snapshots
inside the **config folder** you should see a folder called **www**. if you dont then create one.  
Inside that folder create a folder called `recordings` and another called `snapshots`  


### Set up a script for the recording and snapshots
Add the following to your scripts.yaml
```
frontyardcam_record:
  sequence:
    - service: camera.record
      data_template:
        entity_id: camera.front_yard_camera
        filename: '/config/www/recordings/frontyard_{{ now ().day }}{{ now ().month }}{{ now ().year }}_{{ now ().hour }}{{ now ().minute }}.mp4'
        duration: 30

frontyardcam_snapshot:
  sequence:
    - service: camera.snapshot
      data_template:
        entity_id: camera.front_yard_camera
        filename: '/config/www/snapshots/frontyard_{{ now ().day }}{{ now ().month }}{{ now ().year }}_{{ now ().hour }}{{ now ().minute }}.jpg'
```
Change the names from `frontyardcam` to whatever you would like.  
As you can see the recorded file will be stored as `frontyard_{{ now ().day }}{{ now ().month }}{{ now ().year }}_{{ now ().hour }}{{ now ().minute }}.mp4` this will take the current date and time and add those figures onto the end of `frontyard`
You can keep this format or make it something else. Its up to you.

This record automation when triggered will record a 30 second clip.

### Create the automations
These automations are for the buttons in the entity card so we can press them and do an instant snapshot or 30 second record.
```
- alias: frontyardcam capture
  initial_state: true
  trigger:
  - entity_id: input_boolean.frontyardcam_snapshot
    platform: state
    to: 'on'
  action:
    - service: script.frontyardcam_snapshot
    - delay:
        seconds: 0.5
    - service: input_boolean.turn_off
      entity_id: input_boolean.frontyardcam_snapshot

- alias: frontyardcam record
  initial_state: true
  trigger:
  - entity_id: input_boolean.frontyardcam_record
    platform: state
    to: 'on'
  action:
    - service: script.frontyardcam_record
    - delay:
        seconds: 0.5
    - service: input_boolean.turn_off
      entity_id: input_boolean.frontyardcam_record
```

This automation will trigger when motion is detected in the front yard with the condition, both me and my wife are not home or it is between 11pm and 7am.  
It will turn on the light for better visibility, record a 30 second clip and record another if more movement is detected 30 second later, and will repeat until no more movement is detected.  
It will also send a notification to me and my wife letting us know there is movement and that a recording has been made.
```
- alias: Record Clip of front yard if motion detected while we are away
  initial_state: true
  trigger:
  - platform: state
    entity_id: binary_sensor.front_yard
    to: 'on'
  condition:
    condition: or
    conditions:
      - condition: time
        after: '23:00:00'
        before: '07:00:00'
      - condition: and
        conditions:
          - condition: state
            entity_id: 'device_tracker.sean'
            state: 'not_home'
          - condition: state
            entity_id: 'device_tracker.hayley'
            state: 'not_home'
  action:
    - service: switch.turn_on
      entity_id: switch.front_yard
    - service: script.frontyardcam_record
    - service: notify.notify
      data:
        message: Motion was just detected in your front yard, a clip has been recorded.
    - service: automation.turn_off
      entity_id: automation.record_clip_of_front_yard_if_motion_detected_while_we_are_away
    - delay:
        seconds: 30
    - service: automation.turn_on
      entity_id: automation.record_clip_of_front_yard_if_motion_detected_while_we_are_away
```

<img src="https://github.com/geekyclarkey/homeassistant/blob/master/hass_projects/cctv_with_recording_in_homeassistant/images/notification.jpg" width="300px">

The `notify.notify` will send a notification to all my ios devices with the homeassistant app installed and signed in.  
If you are an android user, **i can't help with notifications.** I don't have any android devices to try!

## Restart homeassistant and Thats it! Have fun trying it for yourself.

# Share the love  
If you found this information helpful please consider [buying me a coffee](https://www.buymeacoffee.com/geekyclarkey)  
Thank you.  
