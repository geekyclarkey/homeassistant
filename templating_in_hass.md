
# Templating in Homeassistant

Here are some examples I have come across and used in my Homeassistant automations, configurations and scripts.  
I have put them all here with detailed comments about how they work to reming myself of what they do and how they work.  
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


### Using UTC Time
This will return true at 1pm UTC  
`{{ (utcnow().hour|int==15) }}`  
As the UTC time doesn't change according to daylight savings time its perfect for automations that use a specific time of the day that change during the summer and winter.


### Using the state of an entity
This will return the current state of this entity  
`{{ (states.sensor.this_months_energy_cost.state|float)|round(2) }}`
The `|float` section allows decimal places.  
The `|round(2)` section rounds the value up to 2 decimal places. For example 1.1636 becomes 1.12  

This will trigger an automation if the current state of one entity is greater than the other  
```
trigger:
  platform: template
  value_template: "{{ (states.sensor.offpeak_max_price.state|float) > (states.input_number.offpeak_price.state|float) }}"
```
As the state of `sensor.offpeak_max_price` goes higher than the state of `input_number.offpeak_price` trigger an automation.  


### Example of a template sensor
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
