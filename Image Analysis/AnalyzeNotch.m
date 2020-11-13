function theta = AnalayzeNotch(notchImage)
%ANALAYZENOTCH Has the user select 4 points to determine the angle the two
%cut sections are in relation to one another.
    
theta = 0;
imshow(notchImage);
point1 = drawpoint();
point2 = drawpoint();
l1pos = [point1.Position; point2.Position];
line1 = drawline('Position',l1pos, 'Color','magenta');

point3 = drawpoint();
point4 = drawpoint();
l2pos = [point3.Position; point4.Position];
line2 = drawline('Position',l2pos, 'Color','red');
pause(0.1);

vec1 = [(l1pos(1,1) - l1pos(2,1));(l1pos(1,2) - l1pos(2,2))];
vec1 = vec1./norm(vec1);

vec2 = [(l2pos(1,1) - l2pos(2,1));(l2pos(1,2) - l2pos(2,2))];
vec2 = vec2./norm(vec2);

theta = acosd(dot(vec1,vec2)/(norm(vec1)*norm(vec2)));
close all;
end

