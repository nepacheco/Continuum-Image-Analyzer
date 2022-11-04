function save_mat = AnalyzeFolder(path,varargin)
%ANALYZEFOLDER Takes in a path to a folder which contains images to analyze
%and goes through each image one by one.
%
%   To run:
%       theta_mat = AnalyzeFolder("C:\users\nickp\pictures\",false,5)

%   'TubeParameter' - Optional Argument determines how many notches should
%   be expected on each tube or the outer diameter of a constant curvature
%   tube. Default is 5 notches or 5 mm.
%   'isRelative' - Optional Argument sets whether the passed in path is
%   relative. Default value is true.
%   'SaveLocation' - Optional Argument which determines where to save the
%   output. Abides by the 'isRelative' flag.
%   'Axis' - Optional Argument which is the axis to display the image one
%   'WriteMode' - Name-Argument {'overwrite','append'} that determines how
%   to write to the output file
%   'Style' - Name-Argument {'line','points'} which denotes if you want to
%   analyze a notch using lines or points.
%   'StartFile' - Name-Argument par which denotes what file in the
%   directory we want to start analysis on
%   'ImgType' - Name-Argument {'notches', 'curvature'} to select if analyzing curve or notches
%   'OD' - Optional Argument for outer diameter of tube for scale


%****** INPUT PARSING *********************
% default values
isRelative = true;
tubeParameter = 5;
saveLocation = "testOutput.csv";
singleFile = false;
writeMode = 'overwrite';
writeOptions = {'overwrite','append'};
style = 'points';
styleOptions = {'line','points'};
imgType = 'notches';
imgOptions = {'notches', 'curvature'};
startFile = "";

p = inputParser();
addRequired(p,'path',@isstring);
addOptional(p, 'isRelative', isRelative, @islogical);
addOptional(p,'TubeParameter',tubeParameter,@isnumeric);
addOptional(p,'ImgType', imgType, @(x) any(validatestring(x,imgOptions)));
addOptional(p,'axis',0);
addOptional(p,'SaveLocation',saveLocation,@isstring);
addOptional(p,'SingleFile',singleFile, @islogical);
addParameter(p,'WriteMode',writeMode,...
    @(x) any(validatestring(x,writeOptions)));
addParameter(p,'Style',style,@(x) any(validatestring(x,styleOptions)));
addParameter(p,'StartFile', startFile,@isstring);
parse(p,path,varargin{:});

isRelative = p.Results.isRelative;
tubeParameter = p.Results.TubeParameter;
imgType = p.Results.ImgType;
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
    results_array = cell(numOfFiles-startIndex + 1, 1);
    for i = startIndex:numOfFiles
         % For loop through the files in the directory and analyze each file
        try
            % This is in case someone decides the are done analyzing images but
            % doesn't want to lose their progress.
            img = imread(path+filesInDir(i).name);
            img_results = AnalyzeImage(img,tubeParameter, 'ImgType', imgType, 'axis',ax,'Style',style);
            results_array{i-startIndex + 1} = img_results;
        catch e
            errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
                e.stack(1).name, e.stack(1).line, e.message);
            fprintf(2, '%s\n', errorMessage);
            fprintf(2,'The identifier was:\n%s\n',e.identifier);
%             break;
        end
    end
else
    % We are only analyzing a single file
    img = imread(path);
    img_results = AnalyzeImage(img,tubeParameter, 'ImgType', imgType, 'axis',ax,'Style',style);
    results_array = {img_results};
end

save_mat = cell2mat(results_array); % Conver the cell array to a matrix for saving
if (strcmp(writeMode,"append"))
    % Append to the current csv file
    mat = readmatrix(saveLocation);
    writematrix([mat;   save_mat],saveLocation);
else
    % Overwrite current csv file
    writematrix(save_mat,saveLocation);
end
close all;
