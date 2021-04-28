function [X, XPhase, xlen ] = time_freq_analysis(x, wsize)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used for the calculate short-time Fourier transform of one-dimensional signal
% Input: x - signal in time domain (row vector)
%        wsize - length of window function(number of samples per frame) 
% Return: X signal in STFT domain (nFrame*L)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R = 4; % set decimation rate to be 4, i.e. 75% overlapping between windows
shift = floor(wsize/R);     % hamming window moving forward step length

% % our experiment shows that Kaiser window with Asl = -91dB genereates the smallest
% % reconstruction error in overlap add.
% Asl = 91; % the sidelobe is -91dB smaller than the mainlobe. 
% beta = 0.12438*(Asl+6.3); % from Discrete-Time Signal Processing, Oppenheim
% w = kaiser(wsize,beta); 

w = hamming(wsize);
w = w/sum(w);   % normalization
w = w(:);       % make it a column vector

nframes = floor(length(x)/shift)-(R-1);

% divide the input signal x into small segments
idx = (repmat(1:wsize,nframes,1)+repmat((0:(nframes-1))'*shift,1,wsize))';
ws = repmat(w,1,nframes);
xs = x(idx).*ws;  

s = zeros(512, nframes);  % pad zeros
s(1:wsize, :) = xs;

S = fft(s);

XPhase = angle(S(1:fix(end/2)+1,:)); %Noisy Speech Phase
X = abs(S(1:fix(end/2)+1,:));%Specrogram

xlen = length(x); % the last row contains the length of the original signal

