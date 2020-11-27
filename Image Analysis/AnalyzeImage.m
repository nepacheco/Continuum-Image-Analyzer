function notchAngles = AnalyzeImage(Image,varargin)
%ANALYZEIMAGE analyzes the passed in image by asking the user to select
%notches and draw lines to determine the angle between notches
%
%   'ImgType' - Optional Argument to select if analyzing curve or notches {'notches', 'curvature'}
%   'NumberOfNotches' - Optional Argument determines how many notches should
%   be expected on each tube. Default is 5.
%   'Axis' - Optional Argument which is the axis to display the image one
%   'Style' - Name-Argument {'line','points'} which denotes if you want to
%   analyze a notch using lines or points.

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
        notchAngles = zeros(1,numberOfNotches);
        rectanglePositions = [];
        for i = 1:numberOfNotches
            [notchImage, roi] = SelectNotch(Image,'previousRegions',rectanglePositions,...
                'axis',ax);
            rectanglePositions = [rectanglePositions; roi];
            theta = AnalyzeNotch(notchImage,'axis',ax,'Style',style);
            notchAngles(i) = theta;
        end
    case 'curvature'
        % set scale and calc bending radius
        disp('analyzing curvature');
        radius = 0;
        % 'select notch' to zoom in 
        [notchImage, roi] = SelectNotch(Image, 'axis',ax);
        % make line to set scale
        radius = AnalyzeArc(notchImage, 'axis', ax, 'Style', style);
        % zoom in on separate section to create arc using AnalyzeArc
        

end

