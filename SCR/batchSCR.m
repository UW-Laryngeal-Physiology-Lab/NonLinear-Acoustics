%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% batchSCR.m
%
% Use this script to calculate SCR values on cleaned .wav files that have
% been trimmed to be 0.75 seconds long.
%
% Created by: Andrew Vamos - 9/15/16
% Original SCR script by Dr. Liyu Lin - 2015
%
% Output files will be saved in this directory's "Results" folder.
%
% Window size for STFT = 0.012 seconds
% 0.75 second voice segments were used in paper also here in this script
%
% Last edited by: Austin J. Scholp, MS on 5/7/2021
%
% Edited for usability and removed unnecessary scripts
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

data = cell(1,length(filenames));
Fs = zeros(1,length(filenames));

%get data of selected files
for k = 1:length(filenames)
    [data{k}, Fs(k)]= audioread(strcat([path filenames{k}]));
end

disp('Please wait.');
%% Calculate SCR

scrResults = {'Filename' 'SCR Value'}; % preallocate, lazy/easy/quick
windowLength = 0.012; % Don't change this unless you know what you're doing

%run SCR script for each wav file
for  h = 1:k
    data_temp = data{h};
    data_cc = data_temp(1000:fix(1000+Fs(h)*0.7-1));
    scrVal = getSCR(data_cc, Fs(h), filenames{h}, windowLength);
    scrResults{h+1,1} = filenames{h} ;
    scrResults{h+1,2} = strcat([' ' num2str(scrVal)]);
end

clearvars -except scrResults %deletes unused/temp variables
%% Format and write output
%Convert data to table for easy printing
dataTable = cell2table(scrResults(2:end,:), 'VariableNames',...
    {'File' 'SCR'});

fileTime = datestr(datetime);
fileTime = strrep(fileTime, ':', '-');
fileTime = strrep(fileTime, ' ', '_');

%Make a directory for the results if one does not exist
[~,~] = mkdir('Results');

%Print table to results directory
writetable(dataTable, strcat(['Results\SCR_Results_' fileTime '.csv']));
disp('SCR results listed in file: ');
disp(strcat(['SCR_Results_' fileTime]));
clear status fileTime msg 