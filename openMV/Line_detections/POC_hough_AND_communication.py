#enable_lens_corr = False # turn on for straighter lines...

import sensor, image, time
from pyb import Pin, delay, udelay

zumo_tx = Pin("PA10", Pin.IN)
zumo_rx = Pin("PA9", Pin.OUT_PP)

def uart_send(byte):
    zumo_rx.value(0)
    udelay(1000)
    for x in range(8):
        bit = (byte & (1 << 7)) >> 7
        byte <<= 1
        zumo_rx.value(bit)
        udelay(1000)
    zumo_rx.value(1)
	
sensor.reset()                      # Reset and initialize the sensor.
sensor.set_pixformat(sensor.RGB565) # Set pixel format to RGB565 (or GRAYSCALE)
sensor.set_framesize(sensor.QVGA)   # Set frame size to QVGA (320x240)
sensor.skip_frames(30)     # Wait for settings take effect.
clock = time.clock()                # Create a clock object to track the FPS.

# zumo constants
DUI_CMD_NULL = 0x00
DUI_CMD_SIGN_START = 0x01
DUI_CMD_SIGN_END = 0x0f
DUI_CMD_SPEED_START = 0x10
DUI_CMD_SPEED_END = 0x20
DUI_CMD_STEER_START = 0x21
DUI_CMD_STEER_END = 0xff

num=25

roi=(0,0,320,80) # region of interest

img_XStride=4 # sizeof x pixels
img_YStride=1 # sizeof y pixels
img_threshold=3500
img_thetaMargin=num
img_rhoMargin=num

# threholds values for edge detection
thresholds = (80, 200)

theta=0

# constants for steering
STEERING_FACTOR = 0.1
MAX_STEERING_ANGLE = 1

#if enable_lens_corr: img.lens_corr(1.8) # for 2.8mm lens...

while(True):
    #img = image.Image("/rtCorner.class/00003.jpg")         # Take a picture and return the image.
    #img = sensor.snapshot()

    # put images in nicla to use this line of code
    img = image.Image("/00018.jpg")


    # copy image to frame buffer
    roiImg = img.copy(roi=roi,copy_to_fb=True)

    # grayscale image
    imgBin = roiImg.to_grayscale()

    # find edges in image
    edges = imgBin.find_edges(image.EDGE_CANNY,threshold=thresholds)

    # find different lines in image
    lines = edges.find_lines(x_stride=img_XStride,y_stride=img_YStride,threshold=img_threshold,
    theta_margin=img_thetaMargin,rho_margin=img_rhoMargin)

    left_line = None
    right_line = None
    middle_line = None
    for l in lines:
        length = l.theta()
        if length > 85 and length < 95:
            middle_line = l
        else:
            if length < 90:
                left_line = l
                imgBin.draw_line(l.line(), color=200,thickness=3)
            else:
                right_line = l
                imgBin.draw_line(l.line(), color=100,thickness=3)


    # Calculate the different steering angle.
    #
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

    elif (left_line and not right_line) or (middle_line and left_line):
        steering_angle = MAX_STEERING_ANGLE

    else:
        steering_angle = MAX_STEERING_ANGLE

    # print("Steering angle:", steering_angle)

	# steering angle byte calculation
	steerByte = int((steering_angle + 1.0) * (DUI_CMD_STEER_END - DUI_CMD_STEER_START) / 2 + DUI_CMD_STEER_START)


	# sending data:
	uart_send(steerByte)
	uart_send(DUI_CMD_SPEED_END)


