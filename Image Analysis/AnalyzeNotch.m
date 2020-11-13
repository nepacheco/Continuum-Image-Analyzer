function theta = AnalayzeNotch(notchImage,varargin)
%ANALAYZENOTCH Has the user select 4 points to determine the angle the two
%cut sections are in relation to one another.

%****** INPUT PARSING *********************
% default values
f = gcf;

p = inputParser();
addRequired(p,'Image');
addOptional(p,'figure',f);
parse(p,path,varargin{:});

f = p.Results.figure;
%*********************************************

figure(f);
theta = 0;
line_vec = zeros(2,2);
imshow(notchImage);
for i = 1:2
    while(1)
        point = drawpoint();
        point2 = drawpoint();
        pos = [point.Position; point2.Position];
        line = drawline('Position',pos, 'Color','magenta');
        line_vec(:,i) = [(pos(1,1) - pos(2,1));(pos(1,2) - pos(2,2))];
        line_vec(:,i) = line_vec(:,i)./norm(line_vec(:,i));
        choice = menu('Are you happy with your line','Yes','No');
        if choice==1
            break;
        end
    end
end
pause(0.1);

theta = acosd(dot(line_vec(:,1),line_vec(:,2))/(norm(line_vec(:,1))*norm(line_vec(:,2))));
close all;
end

