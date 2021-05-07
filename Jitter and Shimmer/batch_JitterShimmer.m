%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% batch_JitterShimmer
%
% Use this script to calculate jitter and shimmer values on .wav files that
% have been trimmed to be 0.75 seconds long.
%
% Created by: Someone, maybe Dr. Boquan Liu
%
% Last edited by: Austin J. Scholp, MS on 5/7/2021
%
% DISCLAIMER: I'm not 100% sure this will give the same values as TF32.
%             You should test a few samples to make sure.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close

%% Load Files
%Prompts the user to choose a .wav files for anlysis
disp('Select .wav files for analysis. You MUST choose more than one.');
[filenames, path] = uigetfile('*.wav', 'MultiSelect', 'on');

if isa(filenames, 'double')==1 %check if filenames is a number
    if filenames==0 %if it is, check if it equals zero
        disp('File selection cancelled.');%If it does equal zero
        return
    end
end
if isa(filenames, 'char')==1 %check if filenames is single string
    disp('Please select more than one file.'); %If it is
    return
end

wavFiles = cell(1,length(filenames));
data = cell(1,length(filenames));
Fs = zeros(1,length(filenames));

for k = 1:length(filenames)
    wavFiles{k} = dir(strcat([path filenames{k}]));
end

%get data of selected files
for k = 1:length(filenames)
    [data{k}, Fs(k)]= audioread(strcat([path filenames{k}]));
end

%% Calculate Jitter and Shimmer

Results = {'Filename' 'Jitter' 'Shimmer'};
for j=1:length(data)
    t=0:1/Fs(j):(length(data{j})-1)/Fs(j);
    [shimmer, jitter]=JitterShimmer(data{j},t,Fs(1));
    Results{j+1,1} = filenames{j} ;
    Results{j+1,2} = strcat([' ' num2str(jitter)]);
    Results{j+1,3} = strcat([' ' num2str(shimmer)]);
end

%% Format and write output
%Convert data to table for easy printing
dataTable = cell2table(Results);

fileTime = datestr(datetime);
fileTime = strrep(fileTime, ':', '-');
fileTime = strrep(fileTime, ' ', '_');

%Make a directory for the results if one does not exist
[~,~] = mkdir('Results');

%Print table to results directory
writetable(dataTable, strcat(['Results\JitterShimmer_' fileTime]));
disp('Results listed in file: ');
disp(strcat(['JitterShimmer_' fileTime]));
clear status fileTime msg