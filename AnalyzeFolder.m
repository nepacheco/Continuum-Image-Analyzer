function save_mat = AnalyzeFolder(path,varargin)
%ANALYZEFOLDER Takes in a path to a folder which contains images to analyze
%and goes through each image one by one.
%
%   To run:
%       theta_mat = AnalyzeFolder("C:\users\nickp\pictures\",false,5)
%       AnalyzeFolder("Images/",true,2.8,'curvature')
%
%   'isRelative' - Optional Argument sets whether the passed in path is
%   relative. Default value is true.   
%   'TubeParameter' - Optional Argument determines how many notches should
%   be expected on each tube or the outer diameter of a constant curvature
%   tube. Default is 5 notches or 5 mm.  
%   'ImgType' - Name-Argument {'notches', 'curvature'} to select if analyzing curve or notches
%   'SaveLocation' - Optional Argument which determines where to save the
%   output. Abides by the 'isRelative' flag.
%   'SingleFile' - Optional Argument to determine if we want to analyze a
%   single file. Should be boolean.
%   'Axis' - Optional Argument which is the axis to display the image one
%   'WriteMode' - Name-Argument {'overwrite','append'} that determines how
%   to write to the output file
%   'Style' - Name-Argument {'line','points'} which denotes if you want to
%   analyze a notch using lines or points.
%   'StartFile' - Name-Argument par which denotes what file in the
%   directory we want to start analysis on
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
addOptional(p,'isRelative',isRelative, @islogical);
addOptional(p,'TubeParameter',tubeParameter,@isnumeric);
addOptional(p,'ImgType', imgType, @(x) any(validatestring(x,imgOptions)));
addOptional(p,'SaveLocation',saveLocation,@isstring);
addOptional(p,'SingleFile',singleFile, @islogical);
addOptional(p,'axis',0);
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
allowedFileTypes = {'.png','.jpg','.jpeg'};
%*********************************************
startAnalyzing = strcmp(startFile,""); % start analyzing if the input name
% is empty, otherwise don't start analyzing

if isRelative
    path = pwd + "\" + path;
    saveLocation = pwd + "\" + saveLocation;
end
if ~singleFile
    % Analyzing multiple files in the directory
    filesAndFolders = dir(path);
    filesInDir = filesAndFolders(~([filesAndFolders.isdir]));
    numOfFiles = length(filesInDir);
    results_array = cell(numOfFiles, 1);
    for i = 1:numOfFiles
         % For loop through the files in the directory and analyze each file
        if strcmp(startFile,filesInDir(i).name)
            % Check if we found the start file
            startAnalyzing = true;
        end
        [~,~,ext] = fileparts(filesInDir(i).name); 
        if ~ismember(lower(ext),allowedFileTypes)
            % If file is not an image file, skip it
            continue
        end
        if startAnalyzing % only analyze files once we found the starting file
            try
                % This is in case someone decides the are done analyzing images but
                % doesn't want to lose their progress.
                img = imread(path+filesInDir(i).name);
                img_results = AnalyzeImage(img,tubeParameter, 'ImgType', imgType, 'axis',ax,'Style',style);
                results_array{i} = img_results;
            catch e
                errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
                    e.stack(1).name, e.stack(1).line, e.message);
                fprintf(2, '%s\n', errorMessage);
                fprintf(2,'The identifier was:\n%s\n',e.identifier);
    %             break;
            end
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
