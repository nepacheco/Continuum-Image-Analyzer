function notchAngles = AnalyzeImage(Image,varargin)
%ANALYZEIMAGE analyzes the passed in image by asking the user to select
%notches and draw lines to determine the angle between notches
%
%   Optional argument, numberOfNotches, determines how many notches should
%   be expected on each tube. Default is 5.

%****** INPUT PARSING *********************
% default values
numberOfNotches = 5;

p = inputParser();
addRequired(p,'Image');
addOptional(p,'numberOfNotches',numberOfNotches,@isnumeric);
parse(p,path,varargin{:});

numberOfNotches = p.Results.numberOfNotches;
%*********************************************

notchAngles = zeros(numberOfNotches,1);
rectanglePositions = [];
for i = 1:numberOfNotches
    [notchImage, roi] = SelectNotch(Image,'previousRegions',rectanglePositions);
    rectanglePositions = [rectanglePositions; roi];
    theta = AnalyzeNotch(notchImage);
    notchAngles(i) = theta;
end
end

