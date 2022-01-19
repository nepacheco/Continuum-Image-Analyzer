function output = AnalyzeImage(Image,varargin)
%ANALYZEIMAGE analyzes the passed in image by asking the user to select
%notches and draw lines to determine the angle between notches
%
%   'TubeParameter' - Optional Argument determines how many notches should
%   be expected on each tube or the outer diameter of a constant curvature
%   tube. Default is 5 notches or 5 mm.
%   'Axis' - Optional Argument which is the axis to display the image one
%   'Style' - Name-Argument {'line','points'} which denotes if you want to
%   analyze a notch using lines or points.
%   'ImgType' - Name-Argument {'notches', 'curvature'} to select if analyzing curve or notches 

%****** INPUT PARSING *********************
% default values
tubeParameter = 5;
style = 'line';
styleOptions = {'line','points'};
imgType = 'curvature';
imgOptions = {'notches', 'curvature'};

p = inputParser();
addRequired(p,'Image');
addOptional(p,'TubeParameter',tubeParameter,@isnumeric);
addOptional(p,'axis',0);
addParameter(p,'Style',@(x) any(validatestring(x,styleOptions)));
addOptional(p,'ImgType', imgType, @(x) any(validatestring(x,imgOptions)));
parse(p,path,varargin{:});

tubeParameter = p.Results.TubeParameter;
ax = p.Results.axis;
if ax == 0
    ax = gca;
end
style = p.Results.Style;
imgType = p.Results.ImgType;
%*********************************************

switch imgType
    case 'notches'
        % zoom on each notch gather data on angles
        output = zeros(1,tubeParameter);
        rectanglePositions = [];
        for i = 1:tubeParameter
            [notchImage, roi] = SelectNotch(Image,'previousRegions',rectanglePositions,...
                'axis',ax,'title',"Select notch to analyze");
            rectanglePositions = [rectanglePositions; roi];
            theta = AnalyzeNotch(notchImage,'axis',ax,'Style',style);
            output(i) = theta;
        end
    case 'curvature'
        % set scale and calc bending radius
        radius = 0;
        
        % prompt to rotate image
        Image = RotateImage(Image, 'axis',ax);
        
        % 'select notch' to zoom in 
        [scaleImage, roi] = SelectNotch(Image, 'axis',ax, 'title',  "Select area to zoom in to set scale");
        
        % make line to set scale
        scale = SetScale(scaleImage, 'axis', ax, 'Style', style, 'OD', tubeParameter)
        
        % 'select notch' to zoom in 
        [arcImage, roi] = SelectNotch(Image, 'axis',ax, 'title', "Select area to zoom in on to find curvature");
        
        % make polylines to create arc
        r_vecPX = AnalyzeArc(arcImage, 'axis', ax, 'Style', style);
        output = r_vecPX(1);
        r_vec = r_vecPX * scale
%         output = r_vec(1) + OD/2;
        output2 = mean(r_vec);

end

