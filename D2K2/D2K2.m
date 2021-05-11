%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% D2K2.com
% DISCLAIMER: 
% This script has not undergone thorough testing as of this writing.
% Results may not be 100% accurate.
%
% Use this script to calculate correlation dimension (D2) and second-order
% entropy (K2) values on .wav files that have been trimmed to be 0.75
% seconds long.
%
% REQUIREMENTS:
%   Signal Processing Toolbox
%   Statistics and Machine Learning Toolbox
%   System Identification Toolbox
%   Predictive Maintenance Toolbox
%
% 0.75 second voice segments should be used with this script
%
% Recreated by: Austin J. Scholp, MS on 5/7/2021
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close

%% Load Files
%Prompts the user to choose a .wav files for anlysis
disp('Select .wav files for analysis. You MUST choose more than one.');
[filename, path] = uigetfile('*.wav');

if isa(filename, 'double')==1 %check if filenames is a number
    if filename==0 %if it is, check if it equals zero
        disp('File selection cancelled.');%If it does equal zero
        return
    end
end

[data, ~]= audioread(strcat([path filename]));

clearvars -except data
disp('Please wait.');

%% Correlation dimension (D2)
% This section uses new functions provided by one of the toolboxes (I don't
% Remember which).

yData = data(:,1);
dim = 2;
Np = 100;
[~,lag] = phaseSpaceReconstruction(yData,[],dim);

correlationDimension(yData,lag,dim,'NumPoints',Np);
disp('Move the left & right dotted lines to encompass the linear region');
MinR = input('Enter the X value of the left dotted line: ');
MaxR = input('Enter the X vlaue of the right dotted line: ');
disp('Calculating D2, please wait.');
D2 = correlationDimension(yData,[],dim,'MinRadius',MinR,'MaxRadius',...
    MaxR,'NumPoints',Np);
clearvars -except D2 yData
disp('D2 = ');
disp(D2);

%% Second-order entropy (K2)
% This section was copied from the original script (DqKqScrip.m)

nPlots = 4;

X = cell(1,nPlots);
Y = cell(1,nPlots);

% K2
disp('Plotting, please wait.');
for n=1 : nPlots
    [c, d] = genKq(yData, '2', n*5);
    X{n} = log(d);    Y{n} = log(c);
end
computeSlope(X,Y,{'K_2 n=5:5:20'; 'ln r'; 'ln C_r'});


% Kinf
disp('Plotting, please wait.');
for n=1 : nPlots
    [c, d] = genKq(yData,  'inf', n*5);
    X{n} = log(d);    Y{n} = log(c);
end
computeSlope(X,Y, {'K_{\infty} n=5:5:20'; 'ln r'; 'ln C_r'});

% K-inf
disp('Plotting, please wait.');
for n = 1 : nPlots
    [c, d] = genKq(yData, '-inf', n*5);
    X{n} = log(d);    Y{n} = log(c);
end
computeSlope(X,Y, {'K_{-\infty} n=5:5:20'; 'ln r'; 'ln C_r'});
