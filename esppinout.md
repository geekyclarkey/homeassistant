
# Esp8266 & Esp32 pinout information  

## Esp8266  

### The ESP8266 12-E chip pinout.
Use this diagram if you’re using an ESP8266 bare chip in your projects.  
* Note: not all GPIOs are accessible in all development boards, but each specific GPIO works in the same way regardless of the development board you’re using. If you’re just getting started with the ESP8266  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/images/esp_pinout_images/ESP8266-ESP-12E-chip-pinout-gpio-pin.png" width="400px">

### ESP8266-01 Pinout  
If you’re using an ESP8266-01 board, you can use the following GPIO diagram as a reference.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/images/esp_pinout_images/ESP-01-ESP8266-pinout-gpio-pin.png" width="400px">

### ESP8266 NodeMCU  
The ESP8266 12-E NodeMCU kit pinout diagram is shown below.  

### Wemos D1 Mini Pinout  
The following figure shows the WeMos D1 Mini pinout.  

### ESP8266 Peripherals  
The ESP8266 peripherals include:  
17 GPIOs  
SPI  
I2C (implemented on software)  
I2S interfaces with DMA  
UART  
10-bit ADC  

### Best Pins to Use – ESP8266  
One important thing to notice about ESP8266 is that the GPIO number doesn’t match the label on the board silkscreen. For example, D0 corresponds to GPIO16 and D1 corresponds to GPIO5.   
The following table shows the correspondence between the labels on the silkscreen and the GPIO number as well as what pins are the best to use in your projects, and which ones you need to be cautious.    
The pins highlighted in green are OK to use. The ones highlighted in yellow are OK to use, but you need to pay attention because they may have unexpected behavior mainly at boot.    
The pins highlighted in red are not recommended to use as inputs or outputs.    

### GPIOs connected to the Flash Chip  
GPIO6 to GPIO11 are usually connected to the flash chip in ESP8266 boards. So, these pins are not recommended to use.    

### Pins used during Boot  
The ESP8266 can be prevented from booting if some pins are pulled LOW or HIGH. The following list shows the state of the following pins on BOOT:  
* GPIO16: pin is high at BOOT  
* GPIO0: boot failure if pulled LOW  
* GPIO2: pin is high on BOOT, boot failure if pulled LOW  
* GPIO15: boot failure if pulled HIGH  
* GPIO3: pin is high at BOOT  
* GPIO1: pin is high at BOOT, boot failure if pulled LOW  
* GPIO10: pin is high at BOOT  
* GPIO9: pin is high at BOOT  

### Pins HIGH at Boot  
There are certain pins that output a 3.3V signal when the ESP8266 boots. This may be problematic if you have relays or other peripherals connected to those GPIOs. The following GPIOs output a HIGH signal on boot:  
* GPIO16  
* GPIO3  
* GPIO1  
GPIO10  
GPIO9  
Additionally, the other GPIOs, except GPIO5 and GPIO4, can output a low-voltage signal at boot, which can be problematic if these are connected to transistors or relays.    
GPIO4 and GPIO5 are the most safe to use GPIOs if you want to operate relays.  

### Analog Input  
The ESP8266 only supports analog reading in one GPIO. That GPIO is called ADC0 and it is usually marked on the silkscreen as A0.    
The maximum input voltage of the ADC0 pin is 0 to 1V if you’re using the ESP8266 bare chip.    
If you’re using a development board like the ESP8266 12-E NodeMCU kit, the voltage input range is 0 to 3.3V because these boards contain an internal voltage divider.    

### On-board LED  
Most of the ESP8266 development boards have a built-in LED. This LED is usually connected to GPIO2.    
The LED is connected to a pull-down resistor, so when you send a HIGH signal the LED turns off.    

### RST Pin  
When the RST pin is pulled LOW, the ESP8266 resets. This is the same as pressing the on-board RESET button.    

### GPIO0
When GPIO0 is pulled LOW, it sets the ESP8266 into bootloader mode. This is the same as pressing the on-board FLASH/BOOT button.   

### GPIO16  
GPIO16 can be used to wake up the ESP8266 from deep sleep. To wake up the ESP8266 from deep sleep, GPIO16 should be connected to the RST pin.  

### I2C
The ESP8266 doens’t have hardware I2C pins, but it can be implemented in software. So you can use any GPIOs as I2C. Usually, the following GPIOs are used as I2C pins:  
GPIO5: SCL  
GPIO4: SDA    

### SPI
The pins used as SPI in the ESP8266 are:  
GPIO12: MISO  
GPIO13: MOSI  
GPIO14: SCLK  
GPIO15: CS    

### PWM Pins
ESP8266 allows software PWM in all I/O pins: GPIO0 to GPIO16. PWM signals on ESP8266 have 10-bit resolution.  

### Interrupt Pins
The ESP8266 supports interrupts in any GPIO, except GPIO16.  









# Disclaimer
I did not create or write the information above.  
I fount this information from [This website](https://randomnerdtutorials.com/esp8266-pinout-reference-gpios/)  
I only copied it and added it to my github page so i can access it again in the future or incase the source site/post gets removed.  
