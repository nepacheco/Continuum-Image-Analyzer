function force_vec = GetForceReadings(path,varargin)
%GETFORCEREADINGS Summary of this function goes here
%   Detailed explanation goes here


%****** INPUT PARSING *********************
% default values
isRelative = true;
saveLocation = "forceOutput.csv";
singleFile = false;
writeMode = 'overwrite';
writeOptions = {'overwrite','append'};
style = 'points';
startFile = "";

p = inputParser();
addRequired(p,'path',@isstring);
addOptional(p, 'isRelative', isRelative, @islogical);
addParameter(p,'SaveLocation',saveLocation,@isstring);
addParameter(p,'SingleFile',singleFile, @islogical);
addParameter(p,'WriteMode',writeMode,...
    @(x) any(validatestring(x,writeOptions)));
addParameter(p,'StartFile', startFile,@isstring);
parse(p,path,varargin{:});

isRelative = p.Results.isRelative;
saveLocation = p.Results.SaveLocation;
singleFile = p.Results.SingleFile;
writeMode = p.Results.WriteMode;
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
    force_vec = zeros(numOfFiles-startIndex + 1, 1);
    for i = startIndex:numOfFiles
        % For loop through the files in the directory and analyze each file
        file = readmatrix(path+filesInDir(i).name);
%         disp(path+filesInDir(i).name);
        try
            % This is in case someone decides the are done analyzing images but
            % doesn't want to lose their progress.
            force = mean(file(1:end,12));
            force_vec(i,:) = force;
        catch
            break;
        end
    end
else
    % We are only analyzing a single file
    file = readmatrix(path);
    force = 0;
    force_vec = force;
end
if (strcmp(writeMode,"append"))
    % Append to the current csv file
    mat = readmatrix(saveLocation);
    writematrix([mat;  force_vec],saveLocation);
else
    % Overwrite current csv file
    writematrix(force_vec,saveLocation);
end

end

