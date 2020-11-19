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


%****** INPUT PARSING *********************
% default values
isRelative = true;
numberOfNotches = 5;
saveLocation = "testOutput.csv";
singleFile = false;
writeMode = 'overwrite';
writeOptions = {'overwrite','append'};
style = 'line';
styleOptions = {'line','points'};

p = inputParser();
addRequired(p,'path',@isstring);
addOptional(p,'numberOfNotches',numberOfNotches,@isnumeric);
addOptional(p, 'isRelative', isRelative, @islogical);
addOptional(p,'axis',0);
addOptional(p,'SaveLocation',saveLocation,@isstring);
addOptional(p,'SingleFile',singleFile, @islogical);
addParameter(p,'WriteMode',writeMode,...
             @(x) any(validatestring(x,writeOptions)));
addParameter(p,'Style',@(x) any(validatestring(x,styleOptions)));
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
%*********************************************

if isRelative
    path = pwd + "\" + path;
    saveLocation = pwd + "\" + saveLocation;
end
if ~singleFile
    filesAndFolders = dir(path);
    filesInDir = filesAndFolders(~([filesAndFolders.isdir]));
    numOfFiles = length(filesInDir);
    theta_mat = zeros(numOfFiles, numberOfNotches);
    for i = 1:numOfFiles
        img = imread(path+filesInDir(i).name);
        theta = AnalyzeImage(img,numberOfNotches,'axis',ax,'Style',style);
        theta_mat(i,:) = theta;
    end
else
    img = imread(path);
    theta = AnalyzeImage(img,numberOfNotches,'axis',ax,'Style',style);
    theta_mat = theta;
end
if (strcmp(writeMode,"append"))
    mat = readmatrix(saveLocation);
    writematrix([mat;   theta_mat],saveLocation);
else
    writematrix(theta_mat,saveLocation);
end
close all;

