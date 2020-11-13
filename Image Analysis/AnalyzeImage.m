clc;clear;close all;
img = imread('TestFile/20DegDiff.png');
imshow(img);

bw = im2bw(img);

% Find rectangular regions and their orientation
rects = regionprops(bw,'Area','Centroid','BoundingBox','Orientation');
% Display found rectangles along with their orientation
hold on
for i = 1:numel(rects)
    rectangle('Position', rects(i).BoundingBox, ...
    'Linewidth', 3, 'EdgeColor', 'r', 'LineStyle', '--');
    pos = rects(i).Centroid;
    quiver(pos(1),pos(2),sind(rects(i).Orientation),cosd(rects(i).Orientation),...
        sqrt(rects(i).Area), 'Linewidth', 3);
end
diff([rects(1).Orientation, rects(2).Orientation])