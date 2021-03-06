function [NLEMaxima_Instaneous, NLE_Instaneous, LinExponent, tfr, time, freq] = iterateNLSS(sdata, Fs, frmsize)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% iterateNLSS.m
% 
% Not entirely sure what this actually does, Dr. Liu wasn't very good at
% commenting his code. This makes use of the NLSTFT (Non-linear Short time 
% Fourier transform) function to calculate NEDR. 
%
% Primary Author: Boquan Liu, PhD
%
% Last edited on 5/27/2021 by: Austin J. Scholp, MS 
%   Cleanup & commenting
%
%%%%%%%%%%%%%%%%%/%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SampFreq = Fs;
wsize = floor(frmsize*Fs);

%% The Short-Time-Fourier-Transform with phase
[~,n] = size(sdata');
C = zeros(1,n);
time = (1:n)/Fs; %creates time array
freq =(Fs/2)/(n/2):(Fs/2)/(n/2):(Fs/2); %creates frequency array
tfr = NLSTFT(sdata,C,Fs,wsize);

%% interation2
%IF estimated by peak data of TF representation.
[~, I] = max(abs(tfr(1:(n/2),:)),[],1);
[p, ~] = polylsqr(time,freq(I),4);

%Calculate the first order derivative of estimated IF.
C = diff(p)*SampFreq;
C(end+1 )= C(end);

%Calculate the NLSTFT using the updated parameter 'C'.
tfr = NLSTFT(sdata,C,Fs,wsize);

%% interation3
%IF estimated by peak data of TF representation.
[~, I] = max(abs(tfr(1:(n/2),:)),[],1);
[p, ~] = polylsqr(time,freq(I),4);

%Calculate the first order derivative of estimated IF.

C1 = diff(p)*SampFreq;
C1(end+1) = C1(end);

%Calculate the NLSTFT using the updated parameter 'C'.
tfr = NLSTFT(sdata,C1,Fs,wsize);

%% interation4
%IF estimated by peak data of TF representation.
[~, I] = max(abs(tfr(1:(n/2),:)),[],1);
[p, ~] = polylsqr(time,freq(I),4);

%Calculate the first order derivative of estimated IF.

C2 = diff(p)*SampFreq;
C2(end+1) = C2(end);

%Calculate the NLSTFT using the updated parameter 'C'.
tfr = NLSTFT(sdata,C2,Fs,wsize);


S = abs(tfr(1:fix(n/2)+1,:));
maxPower = max(S(:));
S = S / maxPower;

S = S';%transpose to remove warning

%Calculating Convergence Ratio: -log(LinRatio)  ~labeled as LinExponent~
SMax = max(S);
% transpose used because we are graphing up the frequency axis of the 
% spectrogram, not down the time axis
SMin = min(S);

LinExponent = sum(SMax-SMin)/n;
NLE_Instaneous = SMax-SMin;
NLEMaxima_Instaneous = NLE_Instaneous./SMax;

clear n S c