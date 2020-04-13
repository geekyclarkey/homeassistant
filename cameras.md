
# Camera Models and URLs

Here is a list of IP cameras with their stream and still image URLs that I have managed to get working in Homeasistant.  


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

```
