import sensor, image, time, math

sensor.reset()
sensor.set_pixformat(sensor.RGB565)
sensor.set_framesize(sensor.HVGA)
sensor.skip_frames(time = 2000)
sensor.set_vflip(True)
sensor.set_hmirror(True)
clock = time.clock()

def main():
  img = sensor.snapshot()
  img.to_grayscale()
  img.scale(copy_to_fb=True, x_size=100)

if __name__ == "__main__":
  while(True):
    main()
    clock.tick()
