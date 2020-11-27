function output = AnalyzeImage(Image,varargin)
%ANALYZEIMAGE analyzes the passed in image by asking the user to select
%notches and draw lines to determine the angle between notches
%
%   'NumberOfNotches' - Optional Argument determines how many notches should
%   be expected on each tube. Default is 5.
%   'Axis' - Optional Argument which is the axis to display the image one
%   'Style' - Name-Argument {'line','points'} which denotes if you want to
%   analyze a notch using lines or points.
%   'OD' - Optional Argument to set outer diameter
%   'ImgType' - Name-Argument {'notches', 'curvature'} to select if analyzing curve or notches 

%****** INPUT PARSING *********************
% default values
numberOfNotches = 5;
style = 'line';
styleOptions = {'line','points'};
imgType = 'curvature';
imgOptions = {'notches', 'curvature'};
OD = 4;

p = inputParser();
addRequired(p,'Image');
addOptional(p,'numberOfNotches',numberOfNotches,@isnumeric);
addOptional(p,'axis',0);
addParameter(p,'Style',@(x) any(validatestring(x,styleOptions)));
addOptional(p,'OD', OD, @isnumeric);
addOptional(p,'ImgType', imgType, @(x) any(validatestring(x,imgOptions)));
parse(p,path,varargin{:});

numberOfNotches = p.Results.numberOfNotches;
ax = p.Results.axis;
if ax == 0
    ax = gca;
end
style = p.Results.Style;
OD = p.Results.OD;
imgType = p.Results.ImgType;
%*********************************************

switch imgType
    case 'notches'
        % zoom on each notch gather data on angles
        output = zeros(1,numberOfNotches);
        rectanglePositions = [];
        for i = 1:numberOfNotches
            [notchImage, roi] = SelectNotch(Image,'previousRegions',rectanglePositions,...
                'axis',ax);
            rectanglePositions = [rectanglePositions; roi];
            theta = AnalyzeNotch(notchImage,'axis',ax,'Style',style);
            output(i) = theta;
        end
    case 'curvature'
        % set scale and calc bending radius
        disp('analyzing curvature');
        radius = 0;
        % 'select notch' to zoom in 
        [scaleImage, roi] = SelectNotch(Image, 'axis',ax);
        
        % make line to set scale
        scale = SetScale(scaleImage, 'axis', ax, 'Style', style, 'OD', OD);
        
        % 'select notch' to zoom in 
        [arcImage, roi] = SelectNotch(Image, 'axis',ax);
        
        % make polylines to create arc
        radius = AnalyzeArc(arcImage, 'axis', ax, 'Style', style);
        output = radius * scale + OD/2;

end

