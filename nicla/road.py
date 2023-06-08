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
MAX_AREA = WIDTH * HEIGHT / 10
MIN_AREA = 40

HORIZON = 150
STRETCH = 40
SQUEEZE = 400

STEERING_ENTHOUSIASM = 3.0
ROAD_MIN_BRIGHTNESS = 0xa0

points = [(STRETCH, HORIZON),
          (WIDTH-1-STRETCH, HORIZON),
          (WIDTH-1+SQUEEZE, HEIGHT-1),
          (-SQUEEZE, HEIGHT-1)]


def drive(img):
    img.to_grayscale()
    img.replace(vflip=True, hmirror=True)
    img.rotation_corr(corners=points)
    img.gaussian(3)

    offset_sum = 0.0
    offset_count = 0.0
    for blob in img.find_blobs([(ROAD_MIN_BRIGHTNESS, 0xff)], pixels_threshold=100):
        img.draw_rectangle(blob.rect())
        area_weight = MIN_AREA + min(MAX_AREA, blob.w() * blob.h()) # limit max area_weight so small blobs still have impact
        horizontal_pos = (blob.x() + blob.w()/2) / WIDTH
        offset_sum += horizontal_pos * area_weight
        offset_count += area_weight
    # dit tegen niemand zeggen
    if offset_count < 0.01: return
    avg = offset_sum / offset_count
    avg = avg * 2 - 1
    avg *= STEERING_ENTHOUSIASM
    avg = max(-1, min(1, avg))

    steerByte = int((avg + 1.0) * (DUI_CMD_STEER_END - DUI_CMD_STEER_START) / 2 + DUI_CMD_STEER_START)

    uart.uart_buffer(steerByte)



while(True):

      #img = sensor.snapshot()
      #data = traffic_light.traf_lights(img)
      #if data is not None:
          #uart.uart_buffer(data)


      sign_img = sensor.snapshot()
      data_sign = signs_detect.sign_detection(sign_img)
      if data_sign is not None:
        uart.uart_buffer(data_sign)

      drive_img = sensor.snapshot()
      drive(drive_img)
      uart.uart_buffer(0x1f)
