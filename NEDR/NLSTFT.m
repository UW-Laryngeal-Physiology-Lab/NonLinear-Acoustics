function tfr = NLSTFT(x,c,fs,hlength)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Non-linear Short time Fourier transform.
%	x      : Signal.
%	c      : First order derivative of signal IF.
%	fs     : Sample Frequency .
%	hlength: Length of window function.

%	tfr    : Time-Frequency Representation.

%
%  This program is free software; you can redistribute it and/or modify
%  it according to your requirement.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
%   Written by Gang Yu in Shandong University at 2015.4.28.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[xrow,xcol] = size(x);
if (nargin < 3)
    error('At least 3 parameter is required');
end
Siglength=xrow;

if (nargin < 4)
    hlength=floor(Siglength/4);
end

hlength=hlength+1-rem(hlength,2);
h = tftb_window(hlength);


[hrow,~]=size(h); Lh=(hrow-1)/2;

h=h/norm(h);


if (xcol~=1)
    error('X must have one column');
end

N=xrow;
t=1:xrow;

[~,tcol] = size(t);


tt=(1:N)/fs;
tfr= zeros (N,tcol) ;


for icol=1:tcol
    ti= t(icol); tau=-min([round(N/2)-1,Lh,ti-1]):min([round(N/2)-1,Lh,xrow-ti]);
    indices= rem(N+tau,N)+1;
    
    
    rSig = x(ti+tau,1);
    
    tfr(indices,icol)=rSig.*conj(h(Lh+1+tau)).*exp(1i * 2.0 * pi * ...
        (c(icol)/2) * (tt(ti+tau)-tt(icol)).^2)';
    
end
tfr=fft(tfr);
