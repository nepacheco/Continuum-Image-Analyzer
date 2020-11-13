function theta_mat = AnalyzeFolder(path,varargin)
%ANALYZEFOLDER Takes in a path to a folder which contains images to analyze
%and goes through each image one by one.
%   Optional Argument - numberOfNotches - sets how many notches are to be
%   expected per tube. Default is 5.
%   Optional Argument - isRelative - sets whether the passed in path is
%   relative. Default value is false.


%****** INPUT PARSING *********************
% default values
isRelative = false;
numberOfNotches = 5;

p = inputParser();
addRequired(p,'path',@isstring);
addOptional(p,'numberOfNotches',numberOfNotches,@isnumeric);
addOptional(p, 'isRelative', isRelative, @islogical);
parse(p,path,varargin{:});

isRelative = p.Results.isRelative;
numberOfNotches = p.Results.numberOfNotches;
%*********************************************

if isRelative
    directory = pwd + "\" + path;
else
    directory = path;
end
filesAndFolders = dir(directory);
filesInDir = filesAndFolders(~([filesAndFolders.isdir]));
numOfFiles = length(filesInDir);
theta_mat = zeros(numberOfNotches, numOfFiles);
for i = 1:numOfFiles
    img = imread(directory+filesInDir(i).name);
    theta = AnalyzeImage(img,numberOfNotches);
    theta_mat(:,i) = theta;
end

