
# Templating in Homeassistant

Here are some examples I use in my Homeassistant automations, configurations and scripts.  
I have put them all here with detailed comments to remind myself of what they do and how they work.  
If anyone else finds this information useful i am glad to be of service.  


### Using a specific day of the month
This will return true on the 1st Wednesday of the month  
`{{ (now().strftime("%d")|int>=1) and (now().strftime("%d")|int <=8) and (now().strftime("%w")|int==3) }}`  
The `(now().strftime("%d")` will return the current day of the month. The `|int>=1` will return true if todays day of the month is more than or equal too the 1st.  
The `|int <=8)` will return true if today is less than or equal too the 8th. **This would mean just the 1st week of the month.**  
The  `(now().strftime("%w")|int==3)` will return true if the day of the week is the 3rd. 0=Sunday, 1=Monday, 2=Tuesday etc.  


### Using the last day of the month
This will return True on the last day of the current month  
`{{ (as_timestamp(now()) + 86400)|timestamp_custom('%d', true) == '01' }}`  
The `(as_timestamp(now()) + 86400)` will return the current time in seconds plus 86400 seconds (which is 1 day).  
The `|timestamp_custom('%d', true) == '01'` will return the current day of the month with 1 added onto it. So... if the 1st is represented os `02` the the last day of the month will be represented as `01` because the last day of the month, plus 1 day is the 1st day of the next month.  
**I think! Im not too sure i understand this one properly, but thats how i have interoperated it.**  


### The user who did the action
This i use for a notification automation, i use it to tell me which homeassistant user switched enabled and disabled the house alarm.  
```
{% for person in states.person %}
{{ person.name + ' has enabled the house alarm' if person.attributes.user_id == states.input_boolean.alarm_enabled.context.user_id }}
{% endfor %}
```
To use this for yourself you need to make sure the `person` is set up in homeassistant (not just a user) and change the `input_boolean.alarm_enabled` to the entity you want to use.   


### Using UTC Time
This will return true at 1pm UTC  
`{{ (utcnow().hour|int==15) }}`  
As the UTC time doesn't change according to daylight savings time its perfect for automations that use a specific time of the day that change during the summer and winter.


### Using the state of an entity
* This will return the current state of this entity  
`{{ (states.sensor.this_months_energy_cost.state|float)|round(2) }}`  
The `|float` section adds decimal places and allows math to be applied to the template.  
The `|round(2)` section rounds the value up to 2 decimal places. For example 1.1636 becomes 1.12  

* This will trigger an automation if the current state of one entity is greater than the other  
```
trigger:
  platform: template
  value_template: "{{ (states.sensor.offpeak_max_price.state|float) > (states.input_number.offpeak_price.state|float) }}"  
```
As the state of `sensor.offpeak_max_price` goes higher than the state of `input_number.offpeak_price` trigger an automation.  


### Examples of a template sensors

* This sensor shows the current energy cost of my home according to peak and offpeak prices.  
This one is quite complex so below i will break it down and try to explain what each section is doing.  
The `if` statement calculates the value using the peak or offpeak price according to the hour of the day.  
```
- platform: template
  sensors:
    current_energy_cost:
      friendly_name: Current Energy Cost
      value_template: >
          {% if utcnow().hour in [11, 12, 13, 14, 15, 16, 17, 18, 19, 20] %}
            {{  (((((((states.sensor.shelly_em_power.state|float)/1000*(states.input_number.peak_price.state|float))+0.022)/100*5.11)+((states.sensor.shelly_em_power.state|float)/1000*(states.input_number.peak_price.state|float))+0.022)/100*21)+(((((states.sensor.shelly_em_power.state|float)/1000*(states.input_number.peak_price.state|float))+0.022)/100*5.11)+((states.sensor.shelly_em_power.state|float)/1000*(states.input_number.peak_price.state|float))+0.022))|round(2) }}           
          {% else %}
            {{  (((((((states.sensor.shelly_em_power.state|float)/1000*(states.input_number.offpeak_price.state|float))+0.022)/100*5.11)+((states.sensor.shelly_em_power.state|float)/1000*(states.input_number.offpeak_price.state|float))+0.022)/100*21)+(((((states.sensor.shelly_em_power.state|float)/1000*(states.input_number.offpeak_price.state|float))+0.022)/100*5.11)+((states.sensor.shelly_em_power.state|float)/1000*(states.input_number.offpeak_price.state|float))+0.022))|round(2) }}           
          {% endif %}
      unit_of_measurement: '€'
```
`(states.sensor.shelly_em_power.state|float)/1000*(states.input_number.peak_price.state|float)` This takes the current state of the shelly em (the amount of watts currently being used)   
divides that by 1000 to get 1 kwh and multiplies that by the price per kwh.   
`+0.022)/100*5.11` adds on the handling fee (0.022€)and divides the whole amount by 100 and multiplies it by 5.11 to get 5.11% of the value witch is a government fee.   
Next it calculates the same value again and divides it by 100 and multiplies it by 21 to get 21% tax of the value `/100*21`        
Lastly it calculates the whole amount again and adds it to the 21% taxed amount.    
`|round(2)` rounds the final amount p to 2 decimal places.   
*The brackets are important and the template will break if they are not used correctly. Bear that in mind if you adapt this template*  
**I'm not sure i have explained that well but i'm sure with the template above you can work out what's going on.**  


* This is one of the sensors i use for my washing machine. It displays the current state of the washing machine according to the information provided by the smart plug i have connected to it.  
```
- platform: template
  sensors:
    washing_machine_state:
      friendly_name: "Washing Machine State"
      value_template: >-
        {% if is_state('switch.washing_machine_plug', 'off') %}
          Off
        {% elif states('sensor.washing_machine_power')|float > 120 and states('sensor.washing_machine_power')|float < 300 %}
          Washing
        {% elif states('sensor.washing_machine_power')|float >= 300 and states('sensor.washing_machine_power')|float < 500 %}
          Spinning
        {% elif states('sensor.washing_machine_power')|float >= 500 %}
          Drying
        {% else %}
          Idle
        {% endif %}
```

* This one uses the `last_called` attribute of each of the alexa media player custom integration.  
From the list of entities it finds the one that has the attribute `last_called == true` and maps that entity_id to the state of `sensor.last_alexa`
```
- platform: template
  sensors:
    last_alexa:
      entity_id:
        - media_player.living_room_echo_dot
        - media_player.kitchen_echo_dot
        - media_player.charlies_echo_dot
        - media_player.lias_echo_dot
        - media_player.bedroom_echo_dot
        - media_player.garage_echo_dot
      value_template: >
        {{ states.media_player | selectattr('attributes.last_called','eq',True) | map(attribute='entity_id') | first }}
```

### Templates and Tasmota
This gives simple math template to a temperature sensor. Im using Tasmota and MQTT to bring the sensor into homeassistant.  
The math takes the value of the sensor and minuses it by 2.5 then rounds the value to the nearest 2 decimal places.  
I use this is to calibrate the temperature sensor slightly.  
```
- platform: mqtt
  name: "Living Room Temperature"
  state_topic: "tele/multisensor/SENSOR"
  value_template: "{{ (value_json['SHT3X-0x44'].Temperature - 2.5)|float|round(2) }}"
  unit_of_measurement: '°C'
```

### Homeassistant docs
More examples and information can be found in the [Homeassistant docs](https://www.home-assistant.io/docs/configuration/templating/)  
