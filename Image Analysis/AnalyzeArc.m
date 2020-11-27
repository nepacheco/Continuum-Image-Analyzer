function radius = AnalayzeArc(zoomedImg,varargin)
%ANALAYZENOTCH Has the user select 4 points to determine the angle the two
%cut sections are in relation to one another.
%
%   'Axis' - Optional Argument which is the axis to display the image one
%   'Style' - Name-Argument {'line','points'} which denotes if you want to
%   analyze a notch using lines or points.
% 

%****** INPUT PARSING *********************
% default values
style = 'line';
styleOptions = {'line','points'};

p = inputParser();
addRequired(p,'Image');
addOptional(p,'axis',0);
addParameter(p,'Style',@(x) any(validatestring(x,styleOptions)));
parse(p,path,varargin{:});

ax = p.Results.axis;
if ax == 0
    ax = gca;
end
style = p.Results.Style;
%*********************************************

radius = 0;
line_vec = zeros(2,2);
I = imshow(zoomedImg,'Parent',ax);
for i = 1:2
    while(1)
        switch style
            case 'line'
                line = drawpolyline('Color','magenta','Parent',ax);
                pos = line.Position;
            case 'points'
                point1 = drawpoint('Color','magenta','Parent',ax);
                point2 = drawpoint('Color','red','Parent',ax);
                point3 = drawpoint('Color','blue','Parent',ax);
                pos = [point1.Position(1) point1.Position(2); 
                    point2.Position(1) point2.Position(2);
                    point3.Position(1) point3.Position(2)];
                line = drawpolyline('Position',pos,'Color','magenta');
                delete(point1); delete(point2); delete(point3);
        end
        
        choice = listdlg('PromptString',{'Are you happy with your line'},...
            'ListString',{'Yes','No'});
        
        if choice ~=1
            continue;
        end
        
        [radius cen] = fit_circle_through_3_points(pos)
        
        circle = drawcircle('Center', cen', 'Radius', radius, 'Color', 'cyan');
        
        choice = listdlg('PromptString',{'Are you happy with your fit'},...
            'ListString',{'Yes','No'});
        
        if choice==1
            break;
        end
        delete(line)
    end
end
pause(0.1);


end

