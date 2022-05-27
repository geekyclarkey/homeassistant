
# Camera Models and URLs

Here is a list of generic IP cameras with their stream and still image URLs that I have managed to get working in Homeasistant.  
[Here](https://www.ispyconnect.com/sources.aspx) is an amazing website with a huge database of stream and still image urls for thousands of cameras.  


```
  - platform: generic
    name: Reolink RLC-420-5MP
    still_image_url: "http://192.168.0.90/cgi-bin/api.cgi?cmd=Snap&amp;channel=0&amp;rs=wuuPhkmUCeI9WG7C&amp;user=admin&amp;password=admin"
    stream_source: "rtsp://admin:admin@192.168.0.90:554/h264Preview_01_main"

  - platform: generic
    name: Panasonic Camera (dont know the model)
    still_image_url: "http://admin:admin@192.168.0.94/cgi-bin/snapshot.cgi?1"
    stream_source: "rtsp://admin:admin@192.168.0.94/cam/realmonitor?channel=1&subtype=00&authbasic=YWRtaW46QWRtaW4xMjM0NQ=="

  - platform: generic
    name: Panasonic WV-SF335
    still_image_url: "http://admin:admin@192.168.0.93/SnapshotJPEG?Resolution=1280x960"
    stream_source: "rtsp://admin:admin@192.168.0.93/Src/MediaInput/h264/stream_1/ch_"

  - platform: generic
    name: Panasonic SP105
    still_image_url: "http://192.168.0.111/cgi-bin/camera"
    stream_source: "rtsp://admin:admin@192.168.0.111/Src/MediaInput/h264/stream_1/ch_"
    username: 'admin'
    password: 'admin'
    authentication: digest

  - platform: generic
    name: Panasonic WV-SF135
    still_image_url: "http://192.168.0.177/cgi-bin/camera"
    stream_source: "rtsp://admin:admin@192.168.0.177/Src/MediaInput/h264/stream_1/ch_"
    username: 'admin'
    password: 'admin'
    authentication: digest

  - platform: generic
    name: Panasonic PTZ SW-395
    still_image_url: "http://" #Cant get the still image out of this one
    stream_source: "rtsp://192.168.0.10/ONVIF/MediaInput?profile=3_def_profile6"

  - platform: generic
    name: Panasonic SW-152
    still_image_url: "http://192.168.0.24/cgi-bin/camera"
    stream_source: "rtsp://admin:admin@192.168.0.24/ONVIF/MediaInput?profile=1_def_profile6"
    username: 'admin'
    password: 'admin'

  - platform: generic
    name: Panasonic SFV-311
    still_image_url: "http://192.168.0.13/cgi-bin/camera"
    stream_source: "rtsp://admin:admin@192.168.0.13/MediaInput/h264"
    username: 'admin'
    password: 'admin'

  - platform: generic
    name: Panasonic SF-336
    still_image_url: "http://admin:admin@192.168.0.50/SnapshotJPEG?Resolution=1280x960"
    tream_source: "rtsp://admin:admin@192.168.0.50/ONVIF/MediaInput?profile=1_def_profile6"

  - platform: generic
    name: Panasonic SF-438
    still_image_url:  "http://admin:admin@192.168.0.11/SnapshotJPEG?Resolution=1280x960"
    stream_source: "rtsp://admin:admin@192.168.0.11/ONVIF/MediaInput?profile=1_def_profile6"

  - platform: generic
    name: Panasonic WV-SFV631L
    still_image_url: "http://192.168.0.13:50009/cgi-bin/camera"
    stream_source: "rtsp://admin:admin@192.168.0.13/MediaInput/h264"
    username: 'admin'
    password: 'admin'
    authentication: digest

  - platform: generic
    name: Panasonic SC-EFK-EP104LWE
    still_image_url: "http://admin:admin@192.168.0.50/cgi-bin/snapshot.cgi?1"
    stream_source: "rtsp://192.168.0.50:554/cam/realmonitor?channel=1&subtype=0&unicast=true&proto=Onvif"

  - platform: generic
    name: Panasonic SC-EF104E
    still_image_url: "http://admin:admin@192.168.0.193/cgi-bin/snapshot.cgi?1"
    stream_source: "rtsp://192.168.0.193:554/cam/realmonitor?channel=1&subtype=1&unicast=true&proto=Onvif"



```


# Share the love  
If you found this information helpful please consider [buying me a coffee](https://www.buymeacoffee.com/geekyclarkey)  
Thank you.  
