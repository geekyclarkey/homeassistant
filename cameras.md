
# Camera Models and URLs


```
  - platform: generic
    name: Garage Camera
    still_image_url: !secret garage_camera_still_image_url
    stream_source: !secret garage_camera_stream_source

  - platform: generic
    name: Front Yard Camera
    still_image_url: !secret front_yard_camera_still_image_url
    stream_source: !secret front_yard_stream_source

  - platform: generic
    name: Hall Camera
    still_image_url: !secret hall_camera_still_image_url
    stream_source: !secret hall_camera_stream_source

  - platform: generic
    name: Workbench Camera
    still_image_url: !secret workbench_camera_still_image_url
    stream_source: !secret workbench_camera_stream_source

  - platform: generic
    name: Panasonic SP105
    still_image_url: "http://192.168.0.111/cgi-bin/camera"
    stream_source: "rtsp://admin:admin@192.168.0.111/Src/MediaInput/h264/stream_1/ch_"
    username: 'admin'
    password: 'admin'
    authentication: digest

 - platform: generic
   name: Old Hall Camera
   still_image_url: "http://192.168.100.177/cgi-bin/camera"
   stream_source: "rtsp://admin:Admin12345@192.168.100.177/Src/MediaInput/h264/stream_1/ch_"
   username: 'admin'
   password: 'Admin12345'
   authentication: digest

```
