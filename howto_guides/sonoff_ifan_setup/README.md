# Sonoff IFan Config Setup

Nothing fancy to explain, below is the config setup if you have a Sonoff ifan with Tasmota

```
fan:
  - platform: mqtt  
    name: "Gym Fan"
    command_topic: "cmnd/gymfan/FanSpeed"
    speed_command_topic: "cmnd/gymfan/FanSpeed"    
    state_topic: "stat/gymfan/RESULT"
    speed_state_topic: "stat/gymfan/RESULT"
    state_value_template: >
      {% if value_json.FanSpeed is defined %}
        {% if value_json.FanSpeed == 0 -%}0{%- elif value_json.FanSpeed > 0 -%}4{%- endif %}
      {% else %}
        {% if states.fan.gymfan.state == 'off' -%}0{%- elif states.fan.bedroo_fan.state == 'on' -%}4{%- endif %}
      {% endif %}
    speed_value_template: "{{ value_json.FanSpeed }}"
    availability_topic: tele/gymfan/LWT
    payload_off: "0"
    payload_on: "4"
    payload_low_speed: "1"
    payload_medium_speed: "2"
    payload_high_speed: "3"
    payload_available: Online
    payload_not_available: Offline
    speeds:
      - off
      - low
      - medium
      - high
  - platform: mqtt
    name: "Gym Light"
    command_topic: "cmnd/gymfan/power1"
    state_topic: "stat/gymfan/POWER1"
    qos: 1
    payload_on: "ON"
    payload_off: "OFF"
    retain: true
```

# Share the love  
If you found this information helpful please consider [buying me a coffee](https://www.buymeacoffee.com/geekyclarkey)  
Thank you.  
