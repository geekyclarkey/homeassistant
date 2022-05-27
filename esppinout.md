
# ESP8266 & ESP32 Pinout Information  

## ESP8266  

### The ESP8266 12-E chip pinout.
Use this diagram if you’re using an ESP8266 bare chip in your projects.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/images/esp_pinout_images/ESP8266-ESP-12E-chip-pinout-gpio-pin.png" width="600px">  
*Note: not all GPIOs are accessible in all development boards, but each specific GPIO works in the same way regardless of the development board you’re using.*   

### ESP8266-01 Pinout  
If you’re using an ESP8266-01 board, you can use the following GPIO diagram as a reference.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/images/esp_pinout_images/ESP-01-ESP8266-pinout-gpio-pin.png" width="400px">

### ESP8266 NodeMCU  
The ESP8266 12-E NodeMCU kit pinout diagram is shown below.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/images/esp_pinout_images/ESP8266-NodeMCU-kit-12-E-pinout-gpio-pin.png" width="600px">

### Wemos D1 Mini Pinout  
The following figure shows the WeMos D1 Mini pinout.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/images/esp_pinout_images/ESP8266-WeMos-D1-Mini-pinout-gpio-pin.png" width="500px">

### ESP8266 Peripherals  
The ESP8266 peripherals include:  
* 17 GPIOs  
* SPI  
* I2C (implemented on software)  
* I2S interfaces with DMA  
* UART  
* 10-bit ADC  

### Best Pins to Use – ESP8266  
One important thing to notice about ESP8266 is that the GPIO number doesn’t match the label on the board silkscreen. For example, D0 corresponds to GPIO16 and D1 corresponds to GPIO5.   
The following table shows the correspondence between the labels on the silkscreen and the GPIO number as well as what pins are the best to use in your projects, and which ones you need to be cautious.    
The pins highlighted in green are OK to use. The ones highlighted in yellow are OK to use, but you need to pay attention because they may have unexpected behaviour mainly at boot.    
The pins highlighted in red are not recommended to use as inputs or outputs.    
<figure class="wp-block-table rnt-responsive-table"><table class=""><tbody><tr><td><strong>Label</strong></td><td><strong>GPIO</strong></td><td><strong>Input</strong></td><td><strong>Output</strong></td><td><strong>Notes</strong></td></tr><tr><td><strong>D0</strong></td><td><strong>GPIO16</strong></td><td>no interrupt</td><td>no PWM or I2C support</td><td><span class="rnthl rntcorange">HIGH at boot</span><br>used to wake up from deep sleep</td></tr><tr><td><strong>D1</strong></td><td><strong>GPIO5</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td>often used as <span class="rnthl rntclblue">SCL</span> (I2C)</td></tr><tr><td><strong>D2</strong></td><td><strong>GPIO4</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td>often used as <span class="rnthl rntclblue">SDA</span> (I2C) </td></tr><tr><td><strong>D3</strong></td><td><strong>GPIO0</strong></td><td>pulled up</td><td><span class="rnthl rntcgreen">OK</span></td><td>connected to FLASH button, boot fails if pulled LOW</td></tr><tr><td><strong>D4</strong></td><td><strong>GPIO2</strong></td><td>pulled up</td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcorange">HIGH at boot</span><br>connected to on-board LED, boot fails if pulled LOW</td></tr><tr><td><strong>D5</strong></td><td><strong>GPIO14</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcblue">SPI</span> (SCLK)</td></tr><tr><td><strong>D6</strong></td><td><strong>GPIO12</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcblue">SPI</span> (MISO) </td></tr><tr><td><strong>D7</strong></td><td><strong>GPIO13</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcblue">SPI</span> (MOSI) </td></tr><tr><td><strong>D8</strong></td><td><strong>GPIO15</strong></td><td>pulled to GND</td><td><span class="rnthl rntcyellow">OK</span></td><td><span class="rnthl rntcblue">SPI</span> (CS)<br>Boot fails if pulled HIGH</td></tr><tr><td><strong>RX</strong></td><td><strong>GPIO3</strong></td><td><span class="rnthl rntcyellow">OK</span></td><td><span class="rnthl rntcred">RX pin</span></td><td><span class="rnthl rntcorange">HIGH at boot</span></td></tr><tr><td><strong>TX</strong></td><td><strong>GPIO1</strong></td><td><span class="rnthl rntcred">TX pin</span></td><td><span class="rnthl rntcyellow">OK</span></td><td><span class="rnthl rntcorange">HIGH at boot</span><br>debug output at boot, boot fails if pulled LOW</td></tr><tr><td><strong>A0</strong></td><td><strong>ADC0</strong></td><td><span class="rnthl rntcgreen">Analog Input</span></td><td><span class="rnthl rntcred">X</span></td><td></td></tr></tbody></table></figure>  

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
* GPIO10  
* GPIO9   

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
* GPIO5: SCL  
* GPIO4: SDA    

### SPI
The pins used as SPI in the ESP8266 are:  
* GPIO12: MISO  
* GPIO13: MOSI  
* GPIO14: SCLK  
* GPIO15: CS    

### PWM Pins
ESP8266 allows software PWM in all I/O pins: GPIO0 to GPIO16. PWM signals on ESP8266 have 10-bit resolution.  

### Interrupt Pins
The ESP8266 supports interrupts in any GPIO, except GPIO16.  





## ESP32  

### The ESP32 bare chip pinout.  
The figure below illustrates the ESP-WROOM-32 pinout.  
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/images/esp_pinout_images/esp32-pinout-chip-ESP-WROOM-32.png" width="900px">   
*Note: not all GPIOs are accessible in all development boards, but each specific GPIO works in the same way regardless of the development board you’re using.*    

### ESP32 Peripherals  
The ESP32 peripherals include:   
* 18 Analog-to-Digital Converter (ADC) channels  
* 3 SPI interfaces   
* 3 UART interfaces   
* 2 I2C interfaces   
* 16 PWM output channels   
* 2 Digital-to-Analog Converters (DAC)   
* 2 I2S interfaces   
* 10 Capacitive sensing GPIOs   

The ADC (analog to digital converter) and DAC (digital to analog converter) features are assigned to specific static pins. However, you can decide which pins are UART, I2C, SPI, PWM, etc – you just need to assign them in the code. This is possible due to the ESP32 chip’s multiplexing feature.    
Although you can define the pins properties on the software, there are pins assigned by default as shown in the following figure (this is an example for the ESP32 DEVKIT V1 DOIT board with 36 pins – the pin location can change depending on the manufacturer).   
<img src="https://github.com/geekyclarkey/homeassistant/blob/master/images/esp_pinout_images/ESP32-DOIT-DEVKIT-V1-Board-Pinout-36-GPIOs-updated.jpg" width="800px">    

Additionally, there are pins with specific features that make them suitable or not for a specific project. The following table shows what pins are best to use as inputs, outputs and which ones you need to be cautious.   
The pins highlighted in green are OK to use. The ones highlighted in yellow are OK to use, but you need to pay attention because they may have unexpected behavior mainly at boot. The pins highlighted in red are not recommended to use as inputs or outputs.  
<figure class="wp-block-table rnt-responsive-table"><table><tbody><tr><td><strong>GPIO</strong></td><td><strong>Input</strong></td><td><strong>Output</strong></td><td><strong>Notes</strong></td></tr><tr><td><strong>0</strong></td><td><span class="rnthl rntcyellow">pulled up</span></td><td><span class="rnthl rntcyellow">OK</span></td><td>outputs PWM signal at boot</td></tr><tr><td><strong>1</strong></td><td><span class="rnthl rntcred">TX pin</span></td><td><span class="rnthl rntcyellow">OK</span></td><td>debug output at boot </td></tr><tr><td><strong>2</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td>connected to on-board LED</td></tr><tr><td><strong>3</strong></td><td><span class="rnthl rntcyellow">OK</span></td><td><span class="rnthl rntcred">RX pin</span></td><td> HIGH at boot </td></tr><tr><td><strong>4</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>5</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td>outputs PWM signal at boot </td></tr><tr><td><strong>6</strong></td><td><span class="rnthl rntcred">x</span></td><td><span class="rnthl rntcred">x</span></td><td>connected to the integrated SPI flash</td></tr><tr><td><strong>7</strong></td><td><span class="rnthl rntcred">x</span></td><td><span class="rnthl rntcred">x</span></td><td>connected to the integrated SPI flash</td></tr><tr><td><strong>8</strong></td><td><span class="rnthl rntcred">x</span></td><td><span class="rnthl rntcred">x</span></td><td>connected to the integrated SPI flash</td></tr><tr><td><strong>9</strong></td><td><span class="rnthl rntcred">x</span></td><td><span class="rnthl rntcred">x</span></td><td>connected to the integrated SPI flash</td></tr><tr><td><strong>10</strong></td><td><span class="rnthl rntcred">x</span></td><td><span class="rnthl rntcred">x</span></td><td>connected to the integrated SPI flash</td></tr><tr><td><strong>11</strong></td><td><span class="rnthl rntcred">x</span></td><td><span class="rnthl rntcred">x</span></td><td>connected to the integrated SPI flash</td></tr><tr><td><strong>12</strong></td><td><span class="rnthl rntcyellow">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td>boot fail if pulled high</td></tr><tr><td><strong>13</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>14</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td>outputs PWM signal at boot</td></tr><tr><td><strong>15</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td>outputs PWM signal at boot</td></tr><tr><td><strong>16</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>17</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>18</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>19</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>21</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>22</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>23</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>25</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>26</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>27</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>32</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>33</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td><span class="rnthl rntcgreen">OK</span></td><td></td></tr><tr><td><strong>34</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td></td><td><span class="rnthl rntcyellow">input only</span></td></tr><tr><td><strong>35</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td></td><td><span class="rnthl rntcyellow">input only</span></td></tr><tr><td><strong>36</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td></td><td><span class="rnthl rntcyellow">input only</span> </td></tr><tr><td><strong>39</strong></td><td><span class="rnthl rntcgreen">OK</span></td><td></td><td><span class="rnthl rntcyellow">input only</span></td></tr></tbody></table></figure>  

### Input only pins
GPIOs 34 to 39 are GPIs – input only pins. These pins don’t have internal pull-ups or pull-down resistors. They can’t be used as outputs, so use these pins only as inputs:  
* GPIO 34  
* GPIO 35  
* GPIO 36  
* GPIO 39  

### SPI flash integrated on the ESP-WROOM-32  
GPIO 6 to GPIO 11 are exposed in some ESP32 development boards. However, these pins are connected to the integrated SPI flash on the ESP-WROOM-32 chip and are not recommended for other uses. So, don’t use these pins in your projects:  
* GPIO 6 (SCK/CLK)  
* GPIO 7 (SDO/SD0)  
* GPIO 8 (SDI/SD1)  
* GPIO 9 (SHD/SD2)  
* GPIO 10 (SWP/SD3)  
* GPIO 11 (CSC/CMD)  

# Capacitive touch GPIOs
The ESP32 has 10 internal capacitive touch sensors. These can sense variations in anything that holds an electrical charge, like the human skin. So they can detect variations induced when touching the GPIOs with a finger. These pins can be easily integrated into capacitive pads, and replace mechanical buttons. The capacitive touch pins can also be used to wake up the ESP32 from deep sleep.  

Those internal touch sensors are connected to these GPIOs:  
* T0 (GPIO 4)  
* T1 (GPIO 0)  
* T2 (GPIO 2)  
* T3 (GPIO 15)  
* T4 (GPIO 13)  
* T5 (GPIO 12)  
* T6 (GPIO 14)  
* T7 (GPIO 27)  
* T8 (GPIO 33)  
* T9 (GPIO 32)  

### Analog to Digital Converter (ADC)
The ESP32 has 18 x 12 bits ADC input channels (while the ESP8266 only has 1x 10 bits ADC). These are the GPIOs that can be used as ADC and respective channels:  
* ADC1_CH0 (GPIO 36)  
* ADC1_CH1 (GPIO 37)  
* ADC1_CH2 (GPIO 38)  
* ADC1_CH3 (GPIO 39)  
* ADC1_CH4 (GPIO 32)  
* ADC1_CH5 (GPIO 33)  
* ADC1_CH6 (GPIO 34)  
* ADC1_CH7 (GPIO 35)  
* ADC2_CH0 (GPIO 4)  
* ADC2_CH1 (GPIO 0)  
* ADC2_CH2 (GPIO 2)  
* ADC2_CH3 (GPIO 15)  
* ADC2_CH4 (GPIO 13)  
* ADC2_CH5 (GPIO 12)  
* ADC2_CH6 (GPIO 14)  
* ADC2_CH7 (GPIO 27)  
* ADC2_CH8 (GPIO 25)  
* ADC2_CH9 (GPIO 26)  

*Note: ADC2 pins cannot be used when Wi-Fi is used. So, if you’re using Wi-Fi and you’re having trouble getting the value from an ADC2 GPIO, you may consider using an ADC1 GPIO instead, that should solve your problem.*  

The ADC input channels have a 12 bit resolution. This means that you can get analog readings ranging from 0 to 4095, in which 0 corresponds to 0V and 4095 to 3.3V. You also have the ability to set the resolution of your channels on the code, as well as the ADC range.    
The ESP32 ADC pins don’t have a linear behaviour. You’ll probably won’t be able to distinguish between 0 and 0.1V, or between 3.2 and 3.3V. You need to keep that in mind when using the ADC pins.  

### Digital to Analog Converter (DAC)
There are 2 x 8 bits DAC channels on the ESP32 to convert digital signals into analog voltage signal outputs. These are the DAC channels:  
* DAC1 (GPIO25)  
* DAC2 (GPIO26)  

### RTC GPIOs
There is RTC GPIO support on the ESP32. The GPIOs routed to the RTC low-power subsystem can be used when the ESP32 is in deep sleep. These RTC GPIOs can be used to wake up the ESP32 from deep sleep when the Ultra Low Power (ULP) co-processor is running. The following GPIOs can be used as an external wake up source:  
* RTC_GPIO0 (GPIO36)  
* RTC_GPIO3 (GPIO39)  
* RTC_GPIO4 (GPIO34)  
* RTC_GPIO5 (GPIO35)  
* RTC_GPIO6 (GPIO25)  
* RTC_GPIO7 (GPIO26)  
* RTC_GPIO8 (GPIO33)  
* RTC_GPIO9 (GPIO32)  
* RTC_GPIO10 (GPIO4)  
* RTC_GPIO11 (GPIO0)  
* RTC_GPIO12 (GPIO2)  
* RTC_GPIO13 (GPIO15)  
* RTC_GPIO14 (GPIO13)  
* RTC_GPIO15 (GPIO12)  
* RTC_GPIO16 (GPIO14)  
* RTC_GPIO17 (GPIO27)  

### PWM
The ESP32 LED PWM controller has 16 independent channels that can be configured to generate PWM signals with different properties. All pins that can act as outputs can be used as PWM pins (GPIOs 34 to 39 can’t generate PWM).  
To set a PWM signal, you need to define these parameters in the code:  
* Signal’s frequency;  
* Duty cycle;  
* PWM channel;  
* GPIO where you want to output the signal.  

### I2C  
The ESP32 has two I2C channels and any pin can be set as SDA or SCL. When using the ESP32 with the Arduino IDE, the default I2C pins are:  
* GPIO 21 (SDA)  
* GPIO 22 (SCL)  

### SPI
By default, the pin mapping for SPI is:   
<<<<<<< HEAD
| SPI | MOSI    | MISO    | CLK     |   CS   |  
|:--- |:----:   | :----:  | :----:  |   ---: |
|VSPI |	GPIO 23	| GPIO 19	| GPIO 18	| GPIO 5 |
|HSPI |	GPIO 13	| GPIO 12	| GPIO 14	| GPIO 15|
=======
| SPI     | MOSI    | MISO    | CLK     | CS     |  
|:---     | :----:  | :----:  | :----:  |   ---: |
|**VSPI** |	GPIO 23	| GPIO 19	| GPIO 18	| GPIO 5 |
|**HSPI** |	GPIO 13	| GPIO 12	| GPIO 14	| GPIO 15|
>>>>>>> origin/master

### Interrupts
All GPIOs can be configured as interrupts.  

### Strapping Pins
The ESP32 chip has the following strapping pins:  
* GPIO 0  
* GPIO 2  
* GPIO 4  
* GPIO 5 (must be HIGH during boot)  
* GPIO 12 (must be LOW during boot)  
* GPIO 15 (must be HIGH during boot)  

These are used to put the ESP32 into bootloader or flashing mode. On most development boards with built-in USB/Serial, you don’t need to worry about the state of these pins. The board puts the pins in the right state for flashing or boot mode.   
However, if you have peripherals connected to those pins, you may have trouble trying to upload new code, flashing the ESP32 with new firmware or resetting the board. If you have some peripherals connected to the strapping pins and you are getting trouble uploading code or flashing the ESP32, it may be because those peripherals are preventing the ESP32 to enter the right mode. Read the Boot Mode Selection documentation to guide you in the right direction. After resetting, flashing, or booting, those pins work as expected.  

### Pins HIGH at Boot
Some GPIOs change its state to HIGH or output PWM signals at boot or reset. This means that if you have outputs connected to these GPIOs you may get unexpected results when the ESP32 resets or boots.  
* GPIO 1  
* GPIO 3  
* GPIO 5  
* GPIO 6 to GPIO 11 (connected to the ESP32 integrated SPI flash memory – not recommended to use).  
* GPIO 14  
* GPIO 15  

### Enable (EN)
Enable (EN) is the 3.3V regulator’s enable pin. It’s pulled up, so connect to ground to disable the 3.3V regulator. This means that you can use this pin connected to a pushbutton to restart your ESP32, for example.  

### GPIO current drawn
The absolute maximum current drawn per GPIO is 40mA according to the “Recommended Operating Conditions” section in the ESP32 datasheet.  

### ESP32 Built-In Hall Effect Sensor
The ESP32 also features a built-in hall effect sensor that detects changes in the magnetic field in its surroundings.  


# Disclaimer
I did not create information above.  
I found this information on [Here](https://randomnerdtutorials.com/esp8266-pinout-reference-gpios/) and [Here](https://randomnerdtutorials.com/esp8266-pinout-reference-gpios/)  
I added it to my github page so i can access it again in the future or incase the source site/post gets removed.  
All credit for the information has to go to [Random Nerd Tutorials](https://randomnerdtutorials.com/)

# Share the love  
If you found this information helpful please consider [buying me a coffee](https://www.buymeacoffee.com/geekyclarkey)  
Thank you.  
