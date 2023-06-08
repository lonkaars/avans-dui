clf
clc
hold on;

x = imread('010.jpg');
x = imrotate(x, 180);
o = x;
x = rgb2hsv(x);

t = x(:,:,3);
t = imadjust(t);
t = t < 0.15;

[lmap, lcount] = bwlabel(t);

imshow(label2rgb(lmap, 'jet', 'black'));
imshow(o);
for i = 1:lcount
    s = regionprops(lmap == i, 'BoundingBox').BoundingBox;
    sx = s(1);
    sy = s(2);
    lx = s(1) + s(3);
    ly = s(2) + s(4);
    width = lx - sx;
    height = ly - sy;
    area = width * height;
    if area < 450
        continue
    end
    aspect = height / width;
    % stoplichten zullen wel een verhouding van ongeveer 2.2 hebben
    if abs(aspect - 2.2) > 0.5
        continue
    end

    red_light = [round(sx + width / 2), round(sy + 0.2 * height)];
    yellow_light = [round(sx + width / 2), round(sy + 0.5 * height)];
    green_light = [round(sx + width / 2), round(sy + 0.8 * height)];

    light_status = 0; % 0 = geen lamp, 1 = rood, 2 = geel, 3 = groen
    
    % x(red_light(2), red_light(1), :)
    if (light_status == 0) && ...
       (abs(x(red_light(2), red_light(1), 1) - 0.5) > 0.4) && ...
       (x(red_light(2), red_light(1), 2) > 0.4)
        light_status = 1;
        plot(red_light(1), red_light(2), '.');
    end
    if (light_status == 0) && ...
       (abs(x(yellow_light(2), yellow_light(1), 1) - 0.1) < 0.1) && ...
       (x(yellow_light(2), yellow_light(1), 2) > 0.4)
        light_status = 2;
        plot(yellow_light(1), yellow_light(2), '.');
    end
    if (light_status == 0) && ...
       (abs(x(green_light(2), green_light(1), 1) - 0.4) < 0.1) && ...
       (x(green_light(2), green_light(1), 2) > 0.4)
        light_status = 3;
        plot(green_light(1), green_light(2), '.');
    end

    if light_status == 0
        continue
    end
    
    rectangle('Position', [s(1) s(2) s(3) s(4)], 'EdgeColor', 'green');
    status = ["rood" "geel" "groen"]; status(light_status)
end

