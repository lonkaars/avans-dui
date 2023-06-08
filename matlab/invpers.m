clf
clc

WIDTH = 480;
HEIGHT = 320;
MAX_AREA = WIDTH * HEIGHT / 10;

HORIZON = 140;
STRETCH = 105;
SQUEEZE = 145;

movingPoints = [STRETCH HORIZON; (WIDTH-STRETCH) HORIZON; WIDTH HEIGHT; 0 HEIGHT];
fixedPoints = [0 0;WIDTH 0; (WIDTH-SQUEEZE) HEIGHT; SQUEEZE HEIGHT];
t = fitgeotrans(movingPoints,fixedPoints,'projective');

x = imread('00021.jpg');
x = imrotate(x, 180);
o = x;

r = imref2d(size(x),[1 size(x,2)],[1 size(x,1)]);
x = imwarp(x,r,t,'OutputView',r);

x = imgaussfilt(x, 3);
x = rgb2hsv(x);

x = x(:,:,3);
x = imadjust(x);
x = x > 0.8;

[lmap, lcount] = bwlabel(x);

subplot(2,1,1);
hold on;
imshow(o);
plot([(WIDTH/2) (WIDTH/2)], [0 HEIGHT], 'Color', '#888', 'LineWidth', 2);

subplot(2,1,2);
hold on;
imshow(label2rgb(lmap, 'jet', 'black'));

sum = 0;
count = 0;
for i = 1:lcount
    props = regionprops(lmap == i, 'BoundingBox', 'Area');
    s = props.BoundingBox;
    sx = s(1);
    sy = s(2);
    lx = s(1) + s(3);
    ly = s(2) + s(4);
    width = lx - sx;
    height = ly - sy;
    area_weight = 40 + min(MAX_AREA, width * height);
    horizontal_pos = (sx + width/2) / WIDTH;
    sum = sum + horizontal_pos * area_weight;
    count = count + area_weight;
    rectangle('Position', [s(1) s(2) s(3) s(4)], 'EdgeColor', 'green');
end

avg = sum / count;
avg = avg * 2 - 1;
avg = max(-1, min(1, avg));
avg

subplot(2,1,1);
quiver(WIDTH/2,HEIGHT/2,avg*WIDTH/2,0,0,'linewidth',3,'color','r')

if abs(avg) < 0.1
    "straight ahead"
else
    temp = ["left", "right"];
    temp((sign(avg) + 1) / 2 + 1)
end