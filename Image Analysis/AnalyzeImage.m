function notchAngles = AnalyzeImage(Image,varargin)
%ANALYZEIMAGE analyzes the passed in image by asking the user to select
%notches and draw lines to determine the angle between notches
%
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

p = inputParser();
addRequired(p,'Image');
addOptional(p,'numberOfNotches',numberOfNotches,@isnumeric);
addOptional(p,'axis',0);
addParameter(p,'Style',@(x) any(validatestring(x,styleOptions)));
parse(p,path,varargin{:});

numberOfNotches = p.Results.numberOfNotches;
ax = p.Results.axis;
if ax == 0
    ax = gca;
end
style = p.Results.Style;
%*********************************************

notchAngles = zeros(numberOfNotches,1);
rectanglePositions = [];
for i = 1:numberOfNotches
    [notchImage, roi] = SelectNotch(Image,'previousRegions',rectanglePositions,...
        'axis',ax);
    rectanglePositions = [rectanglePositions; roi];
    theta = AnalyzeNotch(notchImage,'axis',ax,'Style',style);
    notchAngles(i) = theta;
end
end

