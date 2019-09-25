# Round pop out custom Card

![](images/pop_out.png)

```
default_open: false
dismiss_default: true
entity: switch.bedroom
hold_action:
  action: toggle
icon: 'mdi:fan'
items:
  - entity: script.bedroom_fan_medium
    hold_action:
      action: more-info
    icon: 'mdi:alpha-m-circle'
    tap_action:
      action: toggle
      haptic: true
  - entity: script.bedroom_fan_high
    hold_action:
      action: more-info
    icon: 'mdi:alpha-h-circle'
    tap_action:
      action: toggle
      haptic: true
  - entity: script.bedroom_fan_light_off
    hold_action:
      action: more-info
    icon: 'mdi:lightbulb'
    tap_action:
      action: toggle
      haptic: true
  - entity: script.bedroom_fan_off
    hold_action:
      action: more-info
    icon: 'mdi:power'
    tap_action:
      action: toggle
      haptic: true
  - entity: script.bedroom_fan_light_on
    hold_action:
      action: more-info
    icon: 'mdi:lightbulb-on'
    tap_action:
      action: toggle
      haptic: true
  - entity: script.bedroom_fan_low
    hold_action:
      action: more-info
    icon: 'mdi:alpha-l-circle'
    tap_action:
      action: toggle
      haptic: true
name: Bedroom Fan Remote
type: 'custom:radial-menu'

```
