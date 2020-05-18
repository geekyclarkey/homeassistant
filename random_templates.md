
# Random Templates

## Here are some of my templates i use in my homeassistant configuration
If they can help anyone else i am glad i could help!  

### This is not used in homeassistant i just made it to help me figure out customers electricity bills 
```
{% set kwh_amount = {
   00: 0.800,
   01: 0.744,
   02: 0.607,
   03: 0.555,
   04: 0.505,
   05: 0.537,
   06: 0.528,
   07: 0.648,
   08: 0.590,
   09: 0.736,
   10: 0.769,
   11: 0.884,
   12: 0.868,
   13: 0.881,
   14: 0.814,
   15: 0.881,
   16: 1.191,
   17: 1.036,
   18: 1.223,
   19: 1.921,
   20: 1.952,
   21: 1.412,
   22: 1.103,
   23: 0.953,
} %}

{% set other = {
   "potencia": 10.56,
   "meter_rental": 0.74,
   "handling_fee": 5,
} %}

{% set price_per_kwh = {
   "peak": 0.101,
   "offpeak": 0.0307,
} %}

{% set month_kwh = {
   "peak": (kwh_amount.13+kwh_amount.14+kwh_amount.15+kwh_amount.16+kwh_amount.17+kwh_amount.18+kwh_amount.19+kwh_amount.20+kwh_amount.21+kwh_amount.22)*30,
   "offpeak": (kwh_amount.23+kwh_amount.00+kwh_amount.01+kwh_amount.02+kwh_amount.03+kwh_amount.04+kwh_amount.05+kwh_amount.06+kwh_amount.07+kwh_amount.08+kwh_amount.09+kwh_amount.10+kwh_amount.11+kwh_amount.12)*30,
} %}

{% set final = {
   "peak": month_kwh.peak*price_per_kwh.peak,
   "offpeak": month_kwh.offpeak*price_per_kwh.offpeak,
} %}

The Price for 1 months bill is estimated at...

{{ (((((final.peak+final.offpeak+other.potencia+other.handling_fee)/100*5.11)+(final.peak+final.offpeak+other.potencia+other.handling_fee)+other.meter_rental)/100*21)+(((final.peak+final.offpeak+other.potencia+other.handling_fee)/100*5.11)+(final.peak+final.offpeak+other.potencia+other.handling_fee)+other.meter_rental))|round(2) }}€
```
