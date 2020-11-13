function theta = AnalayzeNotch(notchImage,varargin)
%ANALAYZENOTCH Has the user select 4 points to determine the angle the two
%cut sections are in relation to one another.

%****** INPUT PARSING *********************
% default values

p = inputParser();
addRequired(p,'Image');
addOptional(p,'axis',0);
parse(p,path,varargin{:});

ax = p.Results.axis;
if ax == 0
    ax = gca
end
%*********************************************

theta = 0;
line_vec = zeros(2,2);
I = imshow(notchImage,'Parent',ax);
for i = 1:2
    while(1)
        point = drawpoint('Parent',ax);
        point2 = drawpoint('Parent',ax);
        pos = [point.Position; point2.Position];
        line = drawline('Position',pos, 'Color','magenta','Parent',ax);
        line_vec(:,i) = [(pos(1,1) - pos(2,1));(pos(1,2) - pos(2,2))];
        line_vec(:,i) = line_vec(:,i)./norm(line_vec(:,i));
        choice = lst('Are you happy with your line','Yes','No');
        if choice==1
            break;
        end
    end
end
pause(0.1);

theta = acosd(dot(line_vec(:,1),line_vec(:,2))/(norm(line_vec(:,1))*norm(line_vec(:,2))));
end

