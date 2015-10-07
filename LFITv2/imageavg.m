function [ calImagePath ] = imageavg(calFolderPath,saveName)
%IMAGEAVG Takes multiple images and averages them together.
%
%   Function will write a new image 'avgcal.tif' in the same directory as the
%   input directory. Input the full path of the folder containing
%   all of the calibration files which should be labeled 0000 to 0099.


if exist(fullfile(calFolderPath,'avgcal.tif'),'file') == 2 % if averaged calibration image already exists, just give the string back.
    calImagePath=fullfile(calFolderPath,'avgcal.tif');
    disp('Averaged calibration image found.');
    
else % averaged image does not exist, so compute it.
    disp('Averaging calibration images...');
    
    num=0; %timer logic
    fprintf('   Time remaining:           ');
    
    imageName = dir(fullfile(calFolderPath,'*.tif')); %generate structure array of all TIFF files in directory
    
    if size(imageName,1) == 0 % Make sure there are actually files to average.
        error('No calibration images with extension *.tif found. Check calibration path. Program execution ended prematurely.');
    else
        I = im2double(imread(fullfile(calFolderPath,imageName(1).name))); % initialize I with the first image
        for imageIndex = 2:size(imageName,1)
            time=tic;
            i=im2double(imread(fullfile(calFolderPath,imageName(imageIndex).name)));
            I=I+i;
            time=toc(time);
            timerVar=time/60*((size(imageName,1)-imageIndex));
            if timerVar>=1
                timerVar=round(timerVar);
                for count=1:num+2
                    fprintf('\b')
                end
                num=numel(num2str(timerVar));
                fprintf('%g m',timerVar)
            else
                timerVar=round(time*((size(imageName,1)-imageIndex)));
                for count=1:num+2
                    fprintf('\b')
                end
                num=numel(num2str(timerVar));
                fprintf('%g s',timerVar)
            end
        end
        I=I/size(imageName,1);
        imwrite(uint16(I*65536),fullfile(calFolderPath,saveName)) %16bit output
        calImagePath=fullfile(calFolderPath,saveName);
        fprintf('\n   Complete.\n');
    end
end