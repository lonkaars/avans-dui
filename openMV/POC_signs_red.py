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

    ThR = 0
    ThG = 255
    ThB = 128
    threshold_r = [(ThR,255,0,255,255,ThG)]

    #Red
    #if(R >= ThR and G <= thG)

    #Blue
    #if(B >= thB)


    blobs_r = img.find_blobs([(0, 100, 25, 63, -128, 127)])
    blobs_b = img.find_blobs([(0, 29, 11, -128, -31, -5)])
    #blobs.count()
    #print(blobs)
    ##kpts = img.find_keypoints()

    print(f"old: { len(blobs_r) + len(blobs_b) }")

    blobs_r[:] = [b for b in blobs_r if (b.convexity() < 0.7 and b.area() > 64)]
    blobs_b[:] = [b for b in blobs_b if (b.convexity() < 0.7 and b.area() > 64)]

    print(f"new: { len(blobs_r) + len(blobs_b) }")

    #for index, b in enumerate(blobs_r):
        #convex = b.convexity()
        #roundn = b.roundness()
        #if convex < 0.8:
            #img.draw_rectangle(b.rect(),[255,int((256)*roundn),0],2)
            #print(index)
        #else:
            #del blobs_r[index]
            #img.draw_rectangle(b.rect(),[128,128,128],4)

    for index, b in enumerate(blobs_r):
        roundn = b.roundness()
        img.draw_rectangle(b.rect(),[255,int((256)*roundn),0],2)
        #print(index)

    for index, b in enumerate(blobs_b):
        roundn = b.roundness()
        img.draw_rectangle(b.rect(),[0,int((256)*roundn),255],2)


    # Note: OpenMV Cam runs about half as fast when connected
    # to the IDE. The FPS should increase once disconnected.

    print("EOC")
