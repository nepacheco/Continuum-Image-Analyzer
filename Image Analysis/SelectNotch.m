function newImage = SelectNotch(origImage)
%SELECTNOTCH Takes in an image and allows the user to select a region. The
%output is a zoomed in picture of that region.

imshow(origImage);
roi = drawrectangle();
xmin = round(roi.Position(1));
ymin = round(roi.Position(2));
xmax = round(roi.Position(1) + roi.Position(3));
ymax = round(roi.Position(2) + roi.Position(4));
newImage = origImage(ymin:ymax, xmin:xmax, :);
close all;
% imshow(newImage)
end

