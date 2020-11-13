function [outputArg1,outputArg2] = AnalyzeFolder(path,n,varargin)
%ANALYZEFOLDER Takes in a path to a folder which contains images to analyze
%and goes through each image one by one.
%   Detailed explanation goes here


%****** INPUT PARSING *********************
% default values
isRelative = false;

p = inputParser();
addRequired(p,'path',@isstring);
addRequired(p,'n',@isnumeric);
addOptional(p, 'isRelative', isRelative, @islogical);
parse(p,path,n,varargin{:});

isRelative = p.Results.isRelative;
%*********************************************

if isRelative
    directory = pwd + "\" + path;
else
    directory = path;
end
filesAndFolders = dir(directory);
filesInDir = filesAndFolders(~([filesAndFolders.isdir]));
numOfFiles = length(filesInDir);
theta_mat = zeros(n,numOfFiles);
for (i = 1:numOfFiles)
    img = imread(directory+filesInDir(i).name);
    theta = AnalyzeImage(n,img);
    theta_mat(:,i) = theta;
end

