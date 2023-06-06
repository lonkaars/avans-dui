import sensor, image, time, math
import uart
import signs_detect
import traffic_light
from consts import *

sensor.reset()
sensor.set_pixformat(sensor.RGB565)
sensor.set_framesize(sensor.HVGA)
sensor.skip_frames(time = 4000)
clock = time.clock()

WIDTH = 480
HEIGHT = 320

HORIZON = 150
STRETCH = 40
SQUEEZE = 400

STEERING_ENTHOUSIASM = 3.0
ROAD_MIN_BRIGHTNESS = 0xa0

points = [(STRETCH, HORIZON),
          (WIDTH-1-STRETCH, HORIZON),
          (WIDTH-1+SQUEEZE, HEIGHT-1),
          (-SQUEEZE, HEIGHT-1)]

def drive(driveImg):
  img = driveImg.copy()
  img.to_grayscale()
  img.replace(vflip=True, hmirror=True)
  img.rotation_corr(corners=points)
  img.gaussian(3)

  offset_sum = 0.0
  offset_count = 0.0
  for blob in img.find_blobs([(ROAD_MIN_BRIGHTNESS, 0xff)], pixels_threshold=100):
    img.draw_rectangle(blob.rect())
    area_weight = blob.area()
    horizontal_pos = (blob.x() + blob.w()/2) / WIDTH
    offset_sum += horizontal_pos * area_weight
    offset_count += area_weight
  # dit tegen niemand zeggen
  if offset_count < 0.01: return
  avg = offset_sum / offset_count
  avg = avg * 2 - 1
  avg *= STEERING_ENTHOUSIASM
  avg = max(-1, min(1, avg))

  print(avg)
  steerByte = int((avg + 1.0) * (DUI_CMD_STEER_END - DUI_CMD_STEER_START) / 2 + DUI_CMD_STEER_START)
  uart.uart_buffer(steerByte)
  sensor.dealloc_extra_fb()
count = 0
while(True):
  if count == 0:
    count = count + 1
    speed = signs_detect.init_kpts("speed")
    #stop = signs_detect.init_kpts("stop")
    #car = signs_detect.init_kpts("image")
  else:
      img = sensor.snapshot()
      data = traffic_light.traf_lights(img)
      if data is not None:
          uart.uart_buffer(data)

        #data_sign = signs_detect.sign_detection(img)
        #if data_sign is not None:
          #uart.uart_buffer(data_sign)

      drive(img)
      #uart.uart_buffer(DUI_CMD_SPEED_END)
