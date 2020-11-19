function theta_mat = AnalyzeFolder(path,varargin)
%ANALYZEFOLDER Takes in a path to a folder which contains images to analyze
%and goes through each image one by one.
%   'NumberOfNotches' - Optional Argument sets how many notches are to be
%   expected per tube. Default is 5.
%   'isRelative' - Optional Argument sets whether the passed in path is
%   relative. Default value is false.
%   'SaveLocation' - Optional Argument which determines where to save the
%   output. Abides by the 'isRelative' flag.
%   'Axis' - Optional Argument which is the axis to display the image one
%   'WriteMode' - Name-Argument {'overwrite','append'} that determines how
%   to write to the output file
%   'Style' - Name-Argument {'line','points'} which denotes if you want to
%   analyze a notch using lines or points.
%   'StartFile' - Name-Argument par which denotes what file in the
%   directory we want to start analysis on


%****** INPUT PARSING *********************
% default values
isRelative = true;
numberOfNotches = 5;
saveLocation = "testOutput.csv";
singleFile = false;
writeMode = 'overwrite';
writeOptions = {'overwrite','append'};
style = 'points';
styleOptions = {'line','points'};
startFile = "";

p = inputParser();
addRequired(p,'path',@isstring);
addOptional(p,'numberOfNotches',numberOfNotches,@isnumeric);
addOptional(p, 'isRelative', isRelative, @islogical);
addOptional(p,'axis',0);
addOptional(p,'SaveLocation',saveLocation,@isstring);
addOptional(p,'SingleFile',singleFile, @islogical);
addParameter(p,'WriteMode',writeMode,...
             @(x) any(validatestring(x,writeOptions)));
addParameter(p,'Style',style,@(x) any(validatestring(x,styleOptions)));
addParameter(p,'StartFile', startFile,@isstring);
parse(p,path,varargin{:});

isRelative = p.Results.isRelative;
numberOfNotches = p.Results.numberOfNotches;
ax = p.Results.axis;
if ax == 0
    ax = gca;
end
saveLocation = p.Results.SaveLocation;
singleFile = p.Results.SingleFile;
writeMode = p.Results.WriteMode;
style = p.Results.Style;
startFile = p.Results.StartFile;
%*********************************************

if isRelative
    path = pwd + "\" + path;
    saveLocation = pwd + "\" + saveLocation;
end
if ~singleFile
    % Analyzing multiple files in the directory
    filesAndFolders = dir(path);
    filesInDir = filesAndFolders(~([filesAndFolders.isdir]));
    numOfFiles = length(filesInDir);
    startIndex = 1;
    for f = 1:numOfFiles
        % Goes through the files to determine where to start analyzing
        % images from.
        if strcmp(startFile,filesInDir(f).name)
            startIndex = f;
            break;
        end
    end
    theta_mat = zeros(numOfFiles-startIndex + 1, numberOfNotches);
    for i = startIndex:numOfFiles
        % For loop through the files in the directory and analyze each file
        img = imread(path+filesInDir(i).name);
        try 
        % This is in case someone decides the are done analyzing images but
        % doesn't want to lose their progress.
            theta = AnalyzeImage(img,numberOfNotches,'axis',ax,'Style',style);
            theta_mat(i,:) = theta;
        catch
            break;
        end
    end
else
    % We are only analyzing a single file
    img = imread(path);
    theta = AnalyzeImage(img,numberOfNotches,'axis',ax,'Style',style);
    theta_mat = theta;
end
if (strcmp(writeMode,"append"))
    % Append to the current csv file
    mat = readmatrix(saveLocation);
    writematrix([mat;   theta_mat],saveLocation);
else
    % Overwrite current csv file
    writematrix(theta_mat,saveLocation);
end
close all;

