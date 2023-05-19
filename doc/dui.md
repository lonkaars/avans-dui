# Introduction

# Problem statement

The following is the original project description (translated to English):

> I would like to bring to market a vehicle that can drive independently from A
> to B. The vehicle must take into account traffic rules, road signs, traffic
> lights, etc. Research is being conducted using a small cart, the Pololu Zumo
> 32U4, on which a camera module Nicla Vision is mounted. The aim is to
> investigate the most appropriate method of recognizing the road, traffic
> signs and traffic lights. This should be demonstrated with a proof of
> concept. The cart does not need to drive fast, so the image processing does
> not need to be very fast. Assume one frame per second (or faster).

# Specifications

# Architecture

## Nicla/Zumo communication protocol

The communication protocol used to control the Zumo from the Nicla uses UART to
send ranged numbers in a single byte. Figure \ref{tab:protocol-ranges} shows
which number ranges correspond to which controls.

\begin{figure}[h]
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
\end{figure}

### Signs

The Zumo stores the last sign received, and displays it's name on the OLED
display using the lookup table in figure \ref{tab:protocol-signs}. The sign ID
is calculated by subtracting the start offset of the sign command range from
the command as shown in figure \ref{tab:protocol-ranges}.

\begin{figure}[h]
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
\end{figure}

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

## Communication between the Nicla and Zumo

In order to make the Zumo robot both detect where it is on a road, and steer to
keep driving on said road, some sort of communication needs to exist between
the Nicla and Zumo. As mentioned earlier\footnote{dit is nog niet benoemd}, all
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
provided in the protocol specification document\footnote{dit document bestaat
nog niet}.
}
\communicationConclusion

# Conclusion

\communicationConclusion
