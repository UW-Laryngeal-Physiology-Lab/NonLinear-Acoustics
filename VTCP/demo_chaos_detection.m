%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% demo_chaos_detection.m
%
% PURPOSE?
% REQUIREMENTS?
%
% Created by: Boquan Liu
%
% Last edited by: Austin J. Scholp, MS on 5/14/2021
%
% Edited for usability and to remove warnings
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
for h = 1:length(filenames)
    [data{h}, Fs(h)]= audioread(strcat([path filenames{h}]));
end

clear path h

disp('Computing VTCP, please wait.');
%% Calculate VTCP

Chaos_frame = cell(1,length(filenames)); %preallocate cell array

%run analysis for each wav file
for i = 1:length(filenames)
    data_temp = data{i};
    data_cc = data_temp(1:Fs(i)*0.5);
    num = 1000;
    data_resamp = resample(data_cc,2000,Fs(i));%resample the data
    [~, Chaos_frame{i}] = z1test(data_resamp,num);
end

percent = zeros(4,length(filenames));%preallocate array

for j=1:length(filenames)
    percent(1,j) = length(find(Chaos_frame{j}<=0.01));
    percent(2,j) = length(find(Chaos_frame{j}>0.01&Chaos_frame{j}<=0.1));
    percent(3,j) = length(find(Chaos_frame{j}>0.1&Chaos_frame{j}<=0.9));
    percent(4,j) = length(find(Chaos_frame{j}>0.9));
end



%% Format results into cell
results = {'Filename' 'Type 1' 'Type 2' 'Type 3' 'Type 4'};

for r=1:length(filenames)
    results{r+1,1} = filenames{r} ;
   for c=1:size(percent,1)
       results{r+1,c+1} = percent(c,r)./sum(percent(:,r));
   end
end

%clearvars -except results

%% Format cell data into table and save
dataTable = cell2table(results(2:end,:), 'VariableNames', {'File'...
    'Type 1' 'Type 2' 'Type 3' 'Type 4'});

fileTime = datestr(datetime);
fileTime = strrep(fileTime, ':', '-');
fileTime = strrep(fileTime, ' ', '_');

%Make a directory for the results if one does not exist
[~,~] = mkdir('Results');

%Print table to results directory
writetable(dataTable, strcat(['Results\VTCP_Results_' fileTime '.csv']));
disp('Results found in file: ');
disp(strcat(['VTCP_Results_' fileTime]));
clear status fileTime msg