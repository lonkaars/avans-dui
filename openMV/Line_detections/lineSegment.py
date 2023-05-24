#enable_lens_corr = False # turn on for straighter lines...

import sensor, image, time

sensor.reset()                      # Reset and initialize the sensor.
sensor.set_pixformat(sensor.RGB565) # Set pixel format to RGB565 (or GRAYSCALE)
sensor.set_framesize(sensor.QVGA)   # Set frame size to QVGA (320x240)
sensor.skip_frames(30)     # Wait for settings take effect.
clock = time.clock()                # Create a clock object to track the FPS.
num=25

roi=(0,0,320,75)


# Define the two threshold values
thresholds = (80, 200)

theta=0

# Define the constants for steering control
STEERING_FACTOR = 0.1 # Adjust this to tune the steering response
MAX_STEERING_ANGLE = 1 # Limit the maximum steering angle to avoid overcorrection


while(True):
#clock.tick()                    # Update the FPS clock.
    #img = image.Image("/rtCorner.class/00003.jpg")         # Take a picture and return the image.
    #img = sensor.snapshot()
    img = image.Image("/00018.jpg")         # Take a picture and return the image.


    roiImg = img.copy(roi=roi,copy_to_fb=True)


    imgBin = roiImg.to_grayscale()
    edges = imgBin.find_edges(image.EDGE_CANNY,threshold=thresholds)

    #if enable_lens_corr: img.lens_corr(1.8) # for 2.8mm lens...
    lines = imgBin.find_line_segments(merge_distance=25,max_theta_difference=15)

    left_line = None
    right_line = None
    middle_line = None
    for l in lines:
        length = l.theta()
        if length < 90:
            left_line = l
            imgBin.draw_line(l.line(), color=200,thickness=3)
        else:
            right_line = l
            imgBin.draw_line(l.line(), color=100,thickness=3)


    # Calculate the steering angle
    left_theta=0
    right_theta=0
    if left_line and right_line:
        left_theta = left_line.theta()
        right_theta = right_line.theta()
        center_theta = (left_theta + right_theta) / 2
        #print("left {} right {} center {}".format(left_theta,right_theta,center_theta))
        steering_error = center_theta - 90
        steering_angle = STEERING_FACTOR * steering_error
        steering_angle = min(steering_angle, MAX_STEERING_ANGLE)
        steering_angle = max(steering_angle, -MAX_STEERING_ANGLE)

    elif (right_line and not left_line) or (middle_line and right_line):
        steering_angle = -MAX_STEERING_ANGLE
        #print("right_line:", right_theta)
    elif (left_line and not right_line) or (middle_line and left_line):
        steering_angle = MAX_STEERING_ANGLE
        #print("left line:", left_theta)
    print("Steering angle:", steering_angle)



            ##Test.draw_line(l.line(), color=125,thickness=3)
            #print("lines ({},{},{})".format(l.magnitude(),l.rho(),l.theta()))
            ##theta = l.theta()
            ### left lane
            #if (min_degree < theta and min_degree + 10 > theta):
                ##print("lines ({},{},{})".format(l.magnitude(),l.rho(),l.theta()))
                #roiImg.draw_line(l.line(), color=125,thickness=3)
            ## right lane
            #elif (max_degree < theta and max_degree + 10 > theta):
                ##print("lines ({},{},{})".format(l.magnitude(),l.rho(),l.theta()))
                #roiImg.draw_line(l.line(), color=125,thickness=3)
