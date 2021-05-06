function [rel] = splitWavFileIntoSegments(wavFileName,numSeg,outputPathName)
% This function split a wave file into several segments. All segments will
% be save as '.dat' file. If there is not a input 'outputPathName', the 
% default folder is the same to the wave file.
% All segments is used to calculate ROD by using Dr. Clint's
% software
% Input:
% wavFileName:      The file name of the .wav file. Path should be included.
% numSeg:           How many segments will the .wav file need to be split
% outputPathName:	fragment's putput path name. Last '\' should be delete
% Output:
% rel: 0-- done, 1-- input filename error, 
%      2-- input segment number error, 3-- too many input para
%      4-- other
%----------------------------------------------------------------------
% Edit by: Jonathan
% Date: 2015
if nargin > 3
    rel = 3;
    return;
end

if numSeg <=1 || numSeg>64
    rel = 2;
    return;
end

try
    [wavData,fsamp] = audioread(wavFileName);
catch e
    rel = 1;
    return;
end

[fileFolder,wavFileName,extFileName] = fileparts(wavFileName);
if nargin == 3
    fileFolder = outputPathName;
end

wholeDatFileName =  fullfile(fileFolder,wavFileName);
wholeDatFileName = [wholeDatFileName '.dat'];
save (wholeDatFileName,'wavData','-ascii');

nameOfFragments = [fileFolder '\Fragment_total', num2str(numSeg),'_'];

for n = 1 : numSeg 
    segFileName = nameOfFragments;
    if n<10
        segFileName = [segFileName, '0'];
    end
    segFileName = [segFileName, num2str(n),'.dat'];
    dataToSave = wavData(n:numSeg:end);
    save (segFileName,'dataToSave','-ascii');
end

rel = 0;
return;