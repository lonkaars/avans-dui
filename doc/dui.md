# Introduction

\<inleiding iemand?\>

# Problem statement

The following is the original project description (translated to English).
References have been added in superscript that link to requirements set in
section \ref{specifications}.

> I would like to bring to market a vehicle that can drive
> independently\req{autonomous} from A to B. The vehicle must take into account
> traffic rules\req{traffic-rules}, road signs\req{signs}, traffic
> lights\req{traffic-lights}, etc. Research is being conducted using a small
> cart, the Pololu Zumo 32U4\req{zumo}, on which a camera module Nicla
> Vision\req{nicla} is mounted. The aim is to investigate the most appropriate
> method of recognizing the road, traffic signs and traffic lights. This should
> be demonstrated with a proof of concept. The cart does not need to drive
> fast\req{drspeed}, so the image processing\req{mvision} does not need to be
> very fast. Assume one frame per second (or faster)\req{imspeed}.

# Specifications

The following is a list of specifications derived from the original project
description in section \ref{problem-statement}.

\begin{enumerate}
  \item \label{req:autonomous}
    The vehicle is autonomous
  \item
    The vehicle can detect how its positioned and orientated relative to a road
  \item \label{req:traffic-rules}
    The vehicle conforms to the following set of traffic rules
  \begin{enumerate}
    \item Driving when not on a road is not allowed
    \item The vehicle can follow a road by steering itself accordingly
    \item Driving off the road is only allowed when necessary for the camera to
          keep seeing the road
  \end{enumerate}
  \item \label{req:traffic-lights}
  The vehicle handles traffic lights in the following way
  \begin{enumerate}
    \item Stop at a red traffic light
    \item Speed up at an orange traffic light
    \item Continue driving normally at a green traffic light
  \end{enumerate}
  \item \label{req:signs}
    The vehicle acts on traffic signs in the following way
  \begin{enumerate}
    \item Stop at a stop sign, and continue driving after a few seconds
    \item Turn left at a left sign
    \item Turn right at a right sign
    \item Slow down at a low speed limit sign
    \item Speed up to normal speed at a high speed limit sign
  \end{enumerate}
  \item \label{req:zumo}
    The vehicle used is a Pololu Zumo 32U4
  \item \label{req:nicla}
    The camera module used is an Arduino Nicla Vision
  \item \label{req:mvision}
    Computer vision / image processing is used as the only input
  \item \label{req:drspeed}
    There is no minimum speed the car has to drive at
  \item \label{req:imspeed}
    The image processing pipeline runs at 1 frame per second or higher
  \item
    The Zumo displays the name of the last detected sign on it's OLED display
\end{enumerate}

# Architecture

## Overview

![Architecture overview (level 0)
\label{fig:architecture-level-0}](../assets/architecture-level-0.pdf)

Figure \ref{fig:architecture-level-0} shows the hardware used in this project.
Both the Pololu Zumo 32U4 (referred to as just "Zumo"), and the Arduino Nicla
Vision ("Nicla") have additional sensors and/or outputs on-board, but are
unused.

## Distribution of features

Because creating a software architecture that does all machine vision-related
tasks on the Nicla, and all driving related tasks on the Zumo would create
significant overhead, and because the microcontroller on the Zumo is
significantly harder to debug than the Nicla, a monolithic architecture was
chosen. In this architecture, both the detection of 'traffic objects' and the
decisionmaking on how to handle each object is done on the Nicla board.

Figure \ref{fig:architecture-level-0} shows that a bidirectional communication
line exists between the Zumo and Nicla. This line is only used to send control
commands to the Zumo. Section \ref{niclazumo-communication-protocol} describes
which commands are sent over these lines.

## Nicla/Zumo communication protocol

The communication protocol used to control the Zumo from the Nicla uses UART to
send ranged numbers in a single byte. Table \ref{tab:protocol-ranges} shows
which number ranges correspond to which controls.

\begin{table}
\centering
\begin{tabular}{rl}
\toprule
\textbf{Description} & \textbf{Range (inclusive)}\\
\midrule
(unused) & \texttt{0x00}\\
Signs & \texttt{0x01} - \texttt{0x0f}\\
Speed & \texttt{0x10} - \texttt{0x1f}\\
Steering & \texttt{0x20} - \texttt{0xff}\\
\bottomrule
\end{tabular}
\caption{Protocol command ranges}
\label{tab:protocol-ranges}
\end{table}

### Signs

The Zumo stores the last sign received, and displays it's name on the OLED
display using the lookup table in table \ref{tab:protocol-signs}. The sign ID
is calculated by subtracting the start offset of the sign command range from
the command as shown in table \ref{tab:protocol-ranges}.

\begin{table}
\centering
\begin{tabular}{ll}
\toprule
\textbf{ID} & \textbf{Name}\\
\midrule
\texttt{0x00} & (clear sign)\\
\texttt{0x01} & Stop sign\\
\texttt{0x02} & Turn left\\
\texttt{0x03} & Turn right\\
\texttt{0x04} & Low speed limit\\
\texttt{0x05} & High speed limit\\
\texttt{0x06} & Traffic light (red)\\
\texttt{0x07} & Traffic light (orange)\\
\texttt{0x08} & Traffic light (green)\\
\bottomrule
\end{tabular}
\caption{Sign lookup table}
\label{tab:protocol-signs}
\end{table}

### Speed

The speed value ranges from \num{0} to \num{1}, and is converted from the
command using the following formula:

$$ v(n) = \frac{n - 16}{15} $$

### Steering

The steering value is similar to the speed value, but ranges from \num{-1}
(left) to \num{1} (right). The zumo has a built in "influence" value, which
limits the smallest radius the robot can turn at. The steering value is
converted using the following formula:

$$ s(n) = \frac{n - 32}{223}\cdot2-1 $$

## Zumo internal motor control functions

The Zumo robot receives a speed and steering value. Because the protocol has a
limited precision due to the low amount of data sent, the following formula is
used to control motor speeds $M_1$ and $M_2$ from steering value $s$ and speed
value $v$. The constant $C_1$ is used to globally limit the speed the robot can
drive at. $C_2$ represents the amount of influence the steering value has on
the corner radius, where \num{0} is no steering at all and \num{1} completely
turns of one motor when steering fully left or right:

$$ M_{1,2} = \frac{v(\pm s C_2 - C_2 + 2)}{2} C_1 $$

By default, $C_1 = \num{96}$ and $C_2 = \num{0.6}$

The Zumo firmware also smooths incoming values for $s$ and $v$ using a PID
controller. The default constants for the PID controller used are:

\begin{align*}
K_p &= -0.02\\
K_i &= +0.13\\
K_d &= -300.0
\end{align*}

# Research

## Detecting lines

The Zumo robot needs to drive in a road map-like environment where it needs to act like a car. With the nicla vision camera, there needs to be a way for detecting lines in every frame to make the Zumo robot ride between the lines. Read lines from an image there are different algorithms to make it work. We need to make sure that it works on the OpenMV program if we only choose this one. In this research, two techniques are researched: convolution-based and feature-based.

### Different line detection algorithms.

#### Hough Transform

This is a popular algorithm used to detect straight lines in an image. It works by transforming the image from Cartesian space to Hough space, where lines are represented as points. The algorithm then looks for clusters of points in Hough space, which correspond to lines in Cartesian space.

For more information about Hough Transform algorithms check the below links:

- [Wiki hough](https://en.wikipedia.org/wiki/Hough_transform  )
- [Science article](https://www.sciencedirect.com/topics/computer-science/hough-transforms)
- [OpenCV Hough](https://docs.opencv.org/3.4/d9/db0/tutorial_hough_lines.html)
- [OpenMV find_lines](https://docs.openmv.io/library/omv.image.html)

#### EDlines

EDLines, short for Edge Drawing Lines, is a feature-based algorithm that detects straight lines in an image by tracing along the edges of the image. It works by first extracting edges from the image, then building a graph where each edge is represented by a node. The algorithm then uses a greedy strategy to connect the nodes with high edge strength to form line segments. Finally, it merges line segments that are collinear and close to each other to form longer lines. This algorithm does not require a parameter search or optimization and is known for its robustness against noise and partial occlusion.

For more information about EDlines algorithms check the below links:

- [github library](https://github.com/CihanTopal/ED_Lib)
- [Science article](https://www.sciencedirect.com/science/article/abs/pii/S0167865511001772)
- [EDLINES: REAL-TIME LINE SEGMENT DETECTION BY EDGE DRAWING (ED)](https://projet.liris.cnrs.fr/imagine/pub/proceedings/ICIP-2011/papers/1569406487.pdf)
- [OpenCV EDlines doc](https://docs.opencv.org/3.4/d4/d8b/group__ximgproc__edge__drawing.html)

#### Line Segment Detector

LSD (Line Segment Detector) is an algorithm used for detecting line segments in an image. It works by analyzing the gradient information in the image and clustering nearby gradients that form a line segment. The algorithm first computes the gradient information for the image using the Gaussian filter. It then performs a series of operations, such as non-maximum suppression and thresholding, to obtain a binary edge map.

The line segments are detected by applying a series of geometric constraints to the edge map. These constraints include the minimum and maximum length of line segments, the minimum angle between line segments, and the maximum deviation of line segments from a straight line.

Once the line segments are detected, they are refined using a line merging algorithm combining nearby line segments into longer, more continuous lines. The resulting line segments and their endpoints are returned as the output of the algorithm.

For more information about Line Segment Detector algorithms check the below links:

- [LSD: a Line Segment Detector pdf](http://www.ipol.im/pub/art/2012/gjmr-lsd/article.pdf)
- [Working behind LSD](https://saiwa.ai/blog/line-segment-detection-2/)
- [OpenCV LSD doc](https://docs.opencv.org/3.4/db/d73/classcv_1_1LineSegmentDetector.html)
- [OpenMV find_line_segments](https://docs.openmv.io/library/omv.image.html)

#### Radon transform

Radon transform is another popular algorithm used for line detection. It works by computing the line integral of an image along different directions. The algorithm rotates the image at different angles and computes the sum of pixel intensities along each line in the image. The result is a two-dimensional matrix called the Radon transform. Peaks in this matrix correspond to the lines in the original image. The algorithm then applies some post-processing steps to identify and extract the lines from the Radon transform.

For more information about Radon transform algorithms check the below links:

- [Science article](https://www.sciencedirect.com/science/article/abs/pii/0031320396000155)
- [matlab Radon](https://stackoverflow.com/questions/35412573/radon-transform-line-detection)
- [Matlab elaboration Radon](https://www.kevinpolisano.com/Doctorat/doc-matlab-exemple/radon_lines_detection.html)
- [OpenCV Radon doc](https://docs.opencv.org/4.x/d5/d89/radon__transform_8hpp.html)

### Which algorithm is suitable for our project?

We have identified four different types of line detection algorithms that could potentially be used for our project. To decide on the best algorithm, we need to consider various factors such as accuracy, efficiency, and ease of use. While processing time is not a critical factor in our case, we need to ensure that the algorithm we choose meets our requirements and is accessible through the platform we are using, which is currently openMV but may change to openCV in the future. Therefore, our priority is to select an algorithm that is easy to implement, provides accurate results, and is compatible with our platform.

#### OpenMV

The only two algorithms that work with OpenMV are Hough Transform, the function find_lines, and Line Segment Detector, also known as find_line_segments. Both of these have their ups and downs and could be used for our project. find_lines has the most ups whereas find_line_segemtns has the most negative. As the result here below is decently optimized, it is first grayscaled, and then canny edge detection is done to it.

For the test are the straight lines pictures used with different lighting additionality the left lane represents a whitish line and the right lane is drawn with a more darker color. here below are the pictures used:

![picture 1](../RealTime_pictures/rtStraightLines.class/00000.jpg)

![picture 2](../RealTime_pictures/rtStraightLines.class/00018.jpg)

##### find_lines

The find_lines is a very fast function where you can handle straight lines and other lines with at least 45 FPS or more. Also, have a lot of control over the different types of parameters.

This is the outcome of picture 1:
![outcome_picture_1](../assets/hough_straightLines_Pic_0.png)

This is the outcome of picture 2:
![outcome_picture_2](../assets/hough_straightLines_Pic_1.png)

As you can see there isn't much of a difference between the two pictures.

##### find_line_segments

The find_line_segments is a very slow function where you can find segments from a line. This is a easier to use function because it only has two parameters but the frame rate drops significantly. Additionally, the size of the image to run the algorithm on needs to be smaller because of memory.

This is the outcome of picture 1:

![outcome_picture_1](../assets/LSD_straightLines_Pic_0.png)

This is the outcome of picture 2:

![outcome_picture_2](../assets/LSD_straightLines_Pic_1.png)

As you can see there is quite a lot of difference between them. This function needs more refinement but I couldn't find the sweet spot. Also, the right line in different pictures was always the problem, so there needs another solution for this function to work better.

#### OpenCV

All the above algorithms could be used with OpenCV, But the Radon transform needs more work than the others with the amount of information in the doc.

## Communication between the Nicla and Zumo

In order to make the Zumo robot both detect where it is on a road, and steer to
keep driving on said road, some sort of communication needs to exist between
the Nicla and Zumo. As mentioned in section \ref{distribution-of-features}, all
machine vision-related tasks will happen on the Nicla board. Because the Nicla
board is the first to know how much to steer the cart, it makes sense to have
it control the cart by giving the Nicla a 'steering wheel' of sorts.

This section tries to answer the question "What is the best protocol to use
over the existing UART connection between the Nicla and Zumo?". After a
brainstorm session, we came up with the following specifications for the
communication protocol:

1. **Low bandwidth**  
   Less data means more responsive steering
2. **As simple as possible**  
   The Nicla only needs to control speed and steering
3. **Easy to mock and test**  
   The cart should be able to be controlled using a mock driver and the Nicla's
   output should be testable (preferably using unit tests)
4. **Adaptive to noisy data**  
   The cart should gradually change speed and steering direction as to not slip
   or cause excessive motion blur for the camera module on the Nicla
5. **Adaptive to Nicla failure**  
   If the Nicla crashes or can't detect anything, it will stop sending control
   commands. In this case, the Zumo robot should slowly come to a halt.

Where possible, it's generally benificial to re-use existing code to save on
time. Existing code exists for a custom binary protocol and a text-based
command protocol. Both of these were designed without bandwidth or latency in
mind, and mostly focus on robustness in the case of temporary disconnects or
noise on the communication lines, so a new protocol needs to be made.

To address specification 1 and 2, the command length is fixed at 1 byte. This
means that UARTs built-in start/stop bit will take care of message start/end
detection, since most software interfaces for UART (including Arduino) string
multiple sequential messages together even if they're not part of the same UART
packet.

To mock messages from the Nicla to the Zumo robot, a simple USB serial to UART
cable can be used, along with a small C or Python program to convert
keyboard/mouse input into steering/speed commands. A small software layer can
be implemented on the Nicla to log the semantic meaning of the commands instead
of sending actual UART data when run in a unit test.

A PID controller can be used to smoothly interpolate between input
speed/steering values. This would also introduce some lag between when the
Nicla knows how much to steer, and when the Zumo actually steered the wanted
amount. Smoothing the speed/steering values does make it virtually impossible
for the Nicla to make it's own input data unusable because of motion blur, so
the lag needs to be handled in some other way as directly controlling speed
values without interpolation would lead to a garbage-in-garbage-out system. The
simplest solution to motion blur is limiting the maximum speed the Zumo robot
can drive at, which is the solution we're going to use as speed is not one of
the criteria of the complete system\footnote{Problem statement
(section \ref{problem-statement})}.

In the case the Nicla module crashes or fails to detect the road or roadsigns,
it will stop sending commands. If the Zumo robot would naively continue at it's
current speed, it could drive itself into nearby walls, shoes, pets, etc. To
make sure the robot doesn't get 'lost', it needs to slow down once it hasn't
received commands for some time. As mentioned in section \ref{TODO}, the Nicla
module is able to process at about 10 frames per second, so 2 seconds is a
reasonable time-out period.

\def\communicationConclusion{
The complete protocol consists of single byte commands. A byte can either
change the cart speed or steering direction, both will apply gradually. When no
commands have been received for more than 2 seconds, the Zumo robot will
gradually slow down until it is stopped. Exact specifications of commands are
provided in the protocol specification in section
\ref{niclazumo-communication-protocol}.
}
\communicationConclusion

## Compiling and linking code for the Zumo

This section tries to answer the question "What are possible debugging options
for code running on the Zumo robot?".

Debugging running code can usually be done using an on-device debugger, and a
program that interfaces with the debugger and gcc on a computer. Because gcc
only gives valuable information when it has access to the executable file
running on the microcontroller, an attempt at making a makefile-based toolchain
was made.

Pololu provides C++ libraries for controlling various parts of the Zumo's
hardware. These libraries make use of functions and classes that are part of
the Arduino core library. The Arduino libraries are all open source, and can in
theory be compiled and linked using make, but this would take more effort than
it's worth, since the Zumo has very little responsibility in the end product.

\def\buildSystemConclusion{
Because making a custom build system would take too much time, and because the
Zumo robot's code is very simple, unit tests are used to debug the Zumo's code.
For compiling and uploading the full Zumo firmware, the Arduino IDE is used in
combination with the standard Pololu boards and Libraries.
}
\buildSystemConclusion

# Conclusion

\communicationConclusion
\buildSystemConclusion



