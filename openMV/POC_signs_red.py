# Hello World Example
#
# Welcome to the OpenMV IDE! Click on the green run arrow button below to run the script!

import sensor, image, time

# Color Tracking Thresholds (Grayscale Min, Grayscale Max)
min_rgb = 128
max_rgb = 255
threshold_list = [(min_rgb, max_rgb)]# only bright grey colours will get tracked.
threshold_rgb = [(0, 100, 75, 32, 2, 127)] #only find red
#threshold_rgb = [(18, 78, -8, 127, 24, 127)]

sensor.reset()                      # Reset and initialize the sensor.
sensor.set_pixformat(sensor.RGB565) # Set pixel format to RGB565 (or GRAYSCALE)
#sensor.set_pixformat(sensor.GRAYSCALE)
sensor.set_framesize(sensor.QVGA)   # Set frame size to QVGA (320x240)
sensor.skip_frames(time = 2000)     # Wait for settings take effect.
clock = time.clock()                # Create a clock object to track the FPS.

while(True):
    clock.tick()                    # Update the FPS clock.
    img = sensor.snapshot()         # Take a picture and return the image.

    #lines = img.find_lines()
    #for i in lines:
        #img.draw_line(i.line(), 255, 8)

    #gray = img
    #gray.to_grayscale()
    #img.find_edges(0)



    blobs = img.find_blobs(threshold_rgb)
    #blobs.count()
    #print(blobs)
    ##kpts = img.find_keypoints()
    for index, b in enumerate(blobs, 1):
        convex = b.convexity()
        if convex < 0.8:
            img.draw_rectangle(b.rect(),int((512+256)*convex),2)
        print(b.convexity())

    #img.draw_line(12,12,200,200,255,8)

    print(clock.fps())              # Note: OpenMV Cam runs about half as fast when connected
                                    # to the IDE. The FPS should increase once disconnected.
