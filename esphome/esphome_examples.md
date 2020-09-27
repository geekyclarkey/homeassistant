# ESPHome Examples  

Here are some ESPHome config files that I no longer use or have figured out but not using at the moment.  

I hope anyone who finds this can make use out of them.
I am trying to keep it up to date as much as possible and adding any new setups as i come across them.  
I will also leave a short explanation about each one.  

## Multisensor
This is the config file for the multisensors i use in my house. im using a Wemos D1mini board with a mini pir module also the htu21d temp sensor and bh1750 light sensor. i found that the temp was slightly high due to being inside a housing with the power supply so i use the calibrator to offset the readings.  
```
substitutions:
  espname: "multisensor"
  placename: "Living Room"
  hostname: "Multisensor"
  ssid: "wifi"
  ssidpassword: "password"

esphome:
  name: $espname
  platform: ESP8266
  board: d1_mini

wifi:
  ssid: $ssid
  password: $ssidpassword
  fast_connect: true
  ap:
    ssid: $espname
    password: "1234567890"

captive_portal:
logger:
api:
ota:

i2c:
  sda: D3
  scl: D4
  scan: True

switch:
  - platform: restart
    name: Restart $placename $hostname

binary_sensor:
  - platform: gpio
    pin: D1
    name: $placename PIR
    device_class: motion

sensor:
  - platform: wifi_signal
    name: $placename $hostname WiFi Signal
    update_interval: 300s

  - platform: htu21d
    temperature:
      name: $placename Temperature
      filters:
        - calibrate_linear:
          - 0.0 -> 0.0
          - 27.3 -> 24.8
    humidity:
      name: $placename Humidity
      filters:
        - calibrate_linear:
          - 0.0 -> 0.0
          - 40.3 -> 52.4
    update_interval: 60s

  - platform: bh1750
    name: $placename Brightness
    address: 0x23
    update_interval: 60s

text_sensor:
  - platform: wifi_info
    ip_address:
      name: $placename $hostname IP Address
```

## M5Stack ESP32 Camera
Not much to say... Here is the config file for a M5Stack esp32 camera.  
```
substitutions:
  devicename: 'm5stackcamera'
  hostname: 'm5stack Camera'
  ssid: 'WiFi'
  password: 'password'

captive_portal:
logger:
api:
ota:

esphome:
  name: $devicename
  platform: ESP32
  board: m5stack-core-esp32

wifi:
  ssid: $ssid
  password: $password
  fast_connect: True
  ap:
    ssid: $hostname WiFi Setup
    password: "1234567890"

esp32_camera:
  name: $hostname
  external_clock:
    pin: GPIO27
    frequency: 20MHz
  i2c_pins:
    sda: GPIO25
    scl: GPIO23
  data_pins: [GPIO17, GPIO35, GPIO34, GPIO5, GPIO39, GPIO18, GPIO36, GPIO19]
  vsync_pin: GPIO22
  href_pin: GPIO26
  pixel_clock_pin: GPIO21
  reset_pin: GPIO15
  vertical_flip: true

switch:
  - platform: restart
    name: $hostname Restart

sensor:
  - platform: uptime
    name: $hostname Uptime
  - platform: wifi_signal
    name: $hostname WiFi Signal
    update_interval: 60s

text_sensor:
  - platform: wifi_info
    ip_address:
      name: $hostname IP Address
```

## PN532 RFID/NFC Reader
```
substitutions:
  devicename: 'pn532rfid'
  hostname: 'm5stack Camera'
  ssid: 'WiFi'
  password: 'password'

esphome:
  name: $devicename
  platform: ESP8266
  board: d1_mini

wifi:
  ssid: $ssid
  password: $password
  fast_connect: True
  ap:
    ssid: $hostname WiFi Setup
    password: "1234567890"

captive_portal:
logger:
api:
ota:

spi:
  clk_pin: D0
  miso_pin: D1
  mosi_pin: D2

pn532:
  cs_pin: D3
  update_interval: 1s

binary_sensor:
  - platform: pn532
    uid: 74-10-37-94
    name: "PN532 NFC Tag"

switch:
  - platform: gpio
    name: "LED"
    pin: D7
```

## RC522 RFID Reader
This one you need to add the [rc522_sensor.h](rc522_sensor.h) file to the esphome folder in homeassistant config directory.  
Copy all of the file test. Then save it in /config/esphome/ name the file rc522_sensor.h (no file extention) You should end up with /config/esphome/rc522_sensor.h  
I also added a LED to pin D3 then in homeassistant i have a LED light to use in automations.  
The pinout is as follows:  
| Esp8266 | RC522 |  
|:---     |   ---:|  
|  D2     |  SDA  |  
|  D5     |  SCK  |  
|  D7     |  MOSI  |  
|  D6     |  MISO  |  
|         |  IRQ  |  
|  G      |  GND  |  
|  D1     |  RST  |  
|  3.3    |  3.3  |  

```
substitutions:
  ssid: "wifi"
  ssidpassword: "password"

esphome:
  name: rfid
  platform: ESP8266
  board: nodemcuv2
  includes:
    - rc522_sensor.h  
  libraries:
    - "MFRC522"
    - "SPI"

wifi:
  ssid: $ssid
  password: $ssidpassword
  fast_connect: true
  ap:
    ssid: "Rfid Fallback Hotspot"
    password: "1234567890"

captive_portal:
logger:
api:
ota:

text_sensor:
  - platform: custom
    lambda: |-
      auto my_sensor = new RFIDRC522Sensor();
      App.register_component(my_sensor);
      return {my_sensor->rfid, my_sensor->rfidlast};

    text_sensors:
     - name: "RFID ID"
     - name: "RFID (Last Read)"

switch:
  - platform: restart
    name: Restart RFID Reader
  - platform: gpio
    name: RFID LED
    pin: D3
```

## WS2811 LED Strip
```
substitutions:
  espname: "ws2811ledstrip"
  placename: "kitchen"
  hostname: "LEDs"
  ssid: "wifi"
  ssidpassword: "password"

esphome:
  name: $espname
  platform: ESP8266
  board: nodemcuv2

wifi:
  ssid: $ssid
  password: $ssidpassword
  fast_connect: true
  ap:
    ssid: $espname
    password: "1234567890"

captive_portal:
logger:
api:
ota:

light:
  - platform: fastled_clockless
    chipset: WS2811
    pin: D1
    num_leds: 8
    rgb_order: BRG
    name: $placename $hostname
    effects:
      - random:
      - strobe:
      - flicker:
      - addressable_rainbow:
      - addressable_color_wipe:
      - addressable_scan:
      - addressable_twinkle:
      - addressable_random_twinkle:
      - addressable_fireworks:
```

## ESP32 Camera
```

substitutions:
  devicename: 'espcam'
  hostname: 'Hallcam'
  ssid: 'wifi'
  password: 'password'

wifi:
  ssid: $ssid
  password: $password
  fast_connect: true
  ap:
    ssid: $hostname
    password: "1234567890"
esphome:
  name: $devicename
  platform: ESP32
  board: esp32dev

api:
  reboot_timeout: 0s
ota:
logger:
captive_portal:

esp32_camera:
  external_clock:
    pin: GPIO0
    frequency: 20MHz
  i2c_pins:
    sda: GPIO26
    scl: GPIO27
  data_pins: [GPIO5, GPIO18, GPIO19, GPIO21, GPIO36, GPIO39, GPIO34, GPIO35]
  vsync_pin: GPIO25
  href_pin: GPIO23
  pixel_clock_pin: GPIO22
  power_down_pin: GPIO32
  name: $hostname
  resolution: 640x480
  jpeg_quality: 10
  max_framerate: 10 fps
  idle_framerate: 0.1 fps

output:
  - platform: gpio
    pin: GPIO4
    id: gpio_4

#light:
#  - platform: binary
#    output: gpio_4
#    name: $hostname Light

switch:
  - platform: restart
    name: Restart $hostname

sensor:
  - platform: uptime
    name: $hostname Uptime
  - platform: wifi_signal
    name: $hostname WiFi Signal
    update_interval: 60s

text_sensor:
  - platform: wifi_info
    ip_address:
      name: $hostname IP Address
```

## Dual Relay Shutter Blinds
```
substitutions:
  espname: "kitchenblind"
  devicename: "Kitchen Blind"
  ssid: "wifi"
  ssidpassword: "password"

esphome:
  name: $espname
  platform: ESP8266
  board: esp01_1m

wifi:
  ssid: $ssid
  password: $ssidpassword
  fast_connect: true
  ap:
    ssid: $espname
    password: "1234567890"

captive_portal:
logger:
api:
ota:

i2c:
  sda: GPIO12
  scl: GPIO14

sensor:
  - platform: ade7953
    voltage:
      name: ${devicename} Voltage
    current_a:
      name: ${devicename} Current B
    current_b:
      name: ${devicename} Current A
    active_power_a:
      name: ${devicename} Active Power B
      filters:
        - multiply: -1
    active_power_b:
      name: ${devicename} Active Power A
      filters:
        - multiply: -1
    update_interval: 60s
  - platform: ntc
    sensor: temp_resistance_reading
    name: ${devicename} Temperature
    unit_of_measurement: "°C"
    accuracy_decimals: 1
    icon: "mdi:thermometer"
    calibration:
      b_constant: 3350
      reference_resistance: 10kOhm
      reference_temperature: 298.15K
  - platform: resistance
    id: temp_resistance_reading
    sensor: temp_analog_reading
    configuration: DOWNSTREAM
    resistor: 32kOhm
  - platform: adc
    id: temp_analog_reading
    pin: A0
  - platform: wifi_signal
    name: $devicename WiFi Signal
    update_interval: 300s

status_led:
  pin:
    number: GPIO0
    inverted: yes

binary_sensor:
  - platform: gpio
    internal: true
    pin:
      number: GPIO5
    name: ${devicename} Switch1
    on_press:
      then:
        - if:
            condition:
             switch.is_on: relay_1
            then:
              - cover.stop: ${espname}
            else:
              - cover.open: ${espname}
  - platform: gpio
    internal: true
    pin:
      number: GPIO13
    name: ${devicename} Switch2
    on_press:
      then:
        - if:
            condition:
             switch.is_on: relay_2
            then:
              - cover.stop: ${espname}
            else:
              - cover.close: ${espname}
  - platform: gpio
    pin:
      number: GPIO9
      inverted: True
    name: Open Endstop
    id: open_endstop
    internal: true
  - platform: gpio
    pin:
      number: GPIO10
      inverted: True
    name: Close Endstop
    internal: true
    id: close_endstop

switch:
  - platform: gpio
    internal: true
    id: relay_1
    name: ${devicename} Relay1
    pin: GPIO15
    restore_mode: RESTORE_DEFAULT_OFF
    interlock: [relay_2]
    on_turn_on:
      - delay: 36s
      - switch.turn_off: relay_1
      - cover.stop: ${espname}
  - platform: gpio
    internal: true
    id: relay_2
    name: ${devicename} Relay2
    pin: GPIO4
    restore_mode: RESTORE_DEFAULT_OFF
    interlock: [relay_1]
    on_turn_on:
      - delay: 34s
      - switch.turn_off: relay_2
      - cover.stop: ${espname}
  - platform: restart
    name: Restart ${devicename}

cover:
  - platform: endstop
    name: ${devicename}
    id: ${espname}
    open_action:
      - switch.turn_off: relay_2
      - delay: 0.2s
      - switch.turn_on: relay_1
    open_duration: 35s
    open_endstop: open_endstop
    close_action:
      - switch.turn_off: relay_1
      - delay: 0.2s
      - switch.turn_on: relay_2
    close_duration: 33s
    close_endstop: close_endstop
    stop_action:
      - switch.turn_off: relay_1
      - switch.turn_off: relay_2

text_sensor:
  - platform: wifi_info
    ip_address:
      name: $devicename IP Address
```

## 5V LED Desk lamp
```
substitutions:
  espname: "desklamp"
  placename: "Desk"
  hostname: "Lamp"
  ssid: "wifi"
  ssidpassword: "password"

esphome:
  name: $espname
  platform: ESP8266
  board: d1_mini

wifi:
  ssid: $ssid
  password: $ssidpassword
  fast_connect: true
  ap:
    ssid: $espname
    password: "1234567890"

captive_portal:
logger:
api:
ota:

output:
  - platform: esp8266_pwm
    pin: D4
    frequency: 1000 Hz
    id: output_1
    inverted: true

light:
  - platform: monochromatic
    output: output_1
    name: $placename $hostname
    id: light_1
    default_transition_length: 0s
    restore_mode: RESTORE_DEFAULT_OFF
```

## Teckin SP21 16A Smart Plug
```
substitutions:
  espname: "smartplug"
  hostname: "Mozzie Plug"
  ssid: "wifi"
  ssidpassword: "password"

esphome:
  name: $espname
  platform: ESP8266
  board: esp01_1m

wifi:
  ssid: $ssid
  password: $ssidpassword
  fast_connect: true
  ap:
    ssid: $espname
    password: "1234567890"

captive_portal:
logger:
api:
ota:
web_server:
  port: 80

sensor:
  - platform: uptime
    name: $hostname Uptime

  - platform: wifi_signal
    name: $hostname WiFi Signal
    update_interval: 300s

binary_sensor:
  - platform: gpio
    pin:
      number: GPIO13
      mode: INPUT_PULLUP
      inverted: True
    name: $hostname Button
    internal: true
    on_press:
      - switch.toggle: relay

switch:
  - platform: restart
    name: Restart $hostname

  - platform: gpio
    name: $hostname
    pin: GPIO15
    id: relay
    icon: "mdi:power-socket-eu"
    on_turn_on:
      - switch.turn_on: LED
    on_turn_off:
      - switch.turn_off: LED

  - platform: gpio
    name: $hostname LED
    id: LED
    pin: GPIO2
    inverted: true
    internal: true

text_sensor:
  - platform: wifi_info
    ip_address:
      name: $hostname IP Address

time:
  - platform: homeassistant
    # on_time:
    #   - seconds: 00
    #     minutes: 30
    #     hours: 20
    #     then:
    #       - switch.turn_on: relay
  - platform: homeassistant
    on_time:
      - seconds: 00
        minutes: 00
        hours: 08
        then:
          - switch.turn_off: relay
```

## Sonoff Mini
```
substitutions:
  espname: "workbenchlight"
  hostname: "Workbench Light"
  ssid: "wifi"
  ssidpassword: "password"

esphome:
  name: $espname
  platform: ESP8266
  board: esp01_1m

wifi:
  ssid: $ssid
  password: $ssidpassword
  fast_connect: true
  ap:
    ssid: $espname
    password: "1234567890"

captive_portal:
logger:
api:
ota:
web_server:
  port: 80

sensor:
  - platform: uptime
    name: $hostname Uptime

  - platform: wifi_signal
    name: $hostname WiFi Signal
    update_interval: 300s

binary_sensor:
  - platform: gpio
    pin:
      number: GPIO0
      mode: INPUT_PULLUP
      inverted: True
    name: $hostname Button
    internal: true
    on_press:
      - switch.toggle: relay

  - platform: gpio
    name: $hostname Switch
    internal: true
    pin:
      number: GPIO4
      inverted: true
    on_press:
      - switch.toggle: relay

switch:
  - platform: restart
    name: Restart $hostname

  - platform: gpio
    name: $hostname
    pin: GPIO12
    id: relay
    icon: "mdi:lightbulb"

status_led:
  pin:
    number: GPIO13
    inverted: yes

text_sensor:
  - platform: wifi_info
    ip_address:
      name: $hostname IP Address
```

## Car Presence detection using a D1mini Pro
```
substitutions:
  espname: "carpresence"
  hostname: "Car Presence"
  ssid: "wifi"
  ssidpassword: "password"
  mqtt_ip: 192.168.1.99
  mqtt_user: "user"
  mqtt_pass: "password"

esphome:
  name: $espname
  platform: ESP8266
  board: d1_mini_pro

wifi:
  ssid: $ssid
  password: $ssidpassword
  fast_connect: true
  reboot_timeout: 0s
  use_address: 192.168.1.49
  manual_ip:
    static_ip: 192.168.1.49
    gateway: 192.168.1.1
    dns1: 192.168.1.1
    subnet: 255.255.255.0

logger:
ota:

mqtt:
  discovery: true
  discovery_prefix: homeassistant
  client_id: $espname
  broker: $mqtt_ip
  username: $mqtt_user
  password: $mqtt_pass
  reboot_timeout: 0s
  keepalive: 2s

sensor:
  - platform: uptime
    name: $hostname Uptime
  - platform: wifi_signal
    name: $hostname WiFi Signal
    update_interval: 300s

binary_sensor:
  - platform: status
    name: $hostname
    on_press:
      then:
        - switch.turn_on: led
    on_release:
      then:
        - switch.turn_off: led

switch:
  - platform: gpio
    name: LED
    id: led
    pin: D4
    inverted: true
```
