function [LinExponent] = getSCR(sdata, Fs, name, frmsize)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculates convergence ratio (labelled as LinExponent) of a given sample
% Note: this script assumes samples have already been trimmed
% appropriately, either for recorded voice data or booth data. Sample
% lengths are intended to be 0.75s in length, with 0.012 s STFT windows
% used.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wsize = floor(frmsize*Fs);
% window-size gave best results @ 0.012 seconds (.012 * 25000 = 300 points)

% The Short-Time-Fourier-Transform with phase

[S, Sphase, xlen ] = time_freq_analysis(sdata, wsize); 
% Produces equally sized spectrograms of the voice samples.
% S is the spectrogram, see function below

% Normalizing the values in S for the incoming Convergence graph.
S = abs(S);
maxPower = max(S(:));
S = S / maxPower;

%Calculating Convergence Ratio: -log(LinRatio)  ~labeled as LinExponent~
SMax = max(S');
% transpose used because we are graphing up the frequency axis of the 
% spectrogram, not down the time axis
SMin = min(S');
LinExponent = -log((sum(SMax-SMin)/sum(SMax)));
