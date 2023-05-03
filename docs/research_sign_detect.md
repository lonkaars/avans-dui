# The traffic sign problem:

We divide the reviewed detection methods into five main categories: color-based methods, shape-based methods, color- and shape-based methods, machine-learning-based methods, and LIDAR-based methods

# Traffic Sign Detection (TSD)

## Color based

The distinct color characteristics of traffic signs can attract drivers’ attention and can also provide important cues to design color based detection methods. In the past decades, a large amount of detection methods are designed to detect distinct traffic sign colors such as blue, red and yellow. These methods can be directly used for traffic sign detection, and can also be used for preliminary reduction of the search space,  followed by other detection methods

### RGB

One can easily look at the RGB values to detect a certain color. Although the r,g and b values are heavily effected by different illuminations, therefore this isn't a reliable solution in variating lighting conditions.

An example implementation: 

```py
#Red
if(R >= ThR and G <= thG)

#Blue
if(B >= thB)

#Yellow
if((R + G) >= ThY)

```

It is possible to enhance the colors with maximum and minimum operations:

```
fR(i) = max(0, min(iR − iG, iR − iB)/s),
fB(i) = max(0, min(iB − iR, iB − iG)/s),
fY(i) = max(0, min(iR − iB, iG − iB)/s).
```

This method can result in some issues on the blue channel (see source 1 page 86583 for more explanation). As a solution to this issue use the following formula for the blue channel instead:
```
f′B(i) = max(0, iB − iR)/s).
```

### HSV

The HSV/HSI color space is more immune to the illumination challenges of RGB. The hue and saturation channels can be calculated using RGB, which increases the processing time.

The following pseudo code shows how to detect the red, blue and yellow colors in this space.

```python
#Red
if (H <= Th1 or 
    H >= Th2)

#Blue
if (H >= Th1 and 
    H <= Th2)

#Yellow

if (H >= Th1 and 
    H <= Th2 and 
    H <= Th3)

```

### LAB

This color space is used for finding uncorrelated color components, the L\*a\*b\* space was used for detecting blue, red, yellow and green colors. 


### Pixel classification

This method avoids the use of fixed thresholds that might need adjusting at times. In order to resolve this some authors tried to transfer the problem into pixel classification where a neural network classifies every pixel in the input image, the pixel classification algorithms are often slower than other color extraction methods.

### results

The above described methods where also applied to a database in order to compare each method. This resulted in the conclusion that using a normalized RGB space is giving the most accurate results. See source 1 page 86584 for the full report.

## Shape based

Common standard shapes of traffic signs are triangle, circle, rectangle, and octagon. Shape characteristics used for shape detection include standard shapes, boundaries, texture, key points, etc.

### Hough



### Barnes *et al* (fast radial symmetry)


### Fourier


### Key points detection


## Color & Shape based


## Neural networks



# Traffic Sign Recognition (TSR)
After traffic sign detection or tracking, traffic sign recognition is performed to classify the detected traffic signs into correct classes.

![signs example](imgs/signs.png)

## Binary tree
The binary-tree-based classification method usually classify traffic signs according to the shapes and colors in a coarse-to-fine tree process.

## Support Vector Machine (SVM)
As a binary-classification method, SVM classifies traffic signs using one-vs-one or one-vs-others classification process.



# Sources:

1. [IEEE, Digital Object Identifier June 26, 2019 (pages 86578 - 86596)](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8746141)