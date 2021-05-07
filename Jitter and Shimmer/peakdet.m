%peak finding algorithm --->peakdet.m
% obtained from http://www.billauer.co.il/peakdet.html
function [maxtab, mintab]=peakdet(v, delta, x)
%PEAKDET Detect peaks in a vector
% [MAXTAB, MINTAB] = PEAKDET(V, DELTA) finds the local
% maxima and minima ("peaks") in the vector V.
% MAXTAB and MINTAB consists of two columns. Column 1
% contains indices in V, and column 2 the found values.
%
% With [MAXTAB, MINTAB] = PEAKDET(V, DELTA, X) the indices
% in MAXTAB and MINTAB are replaced with the corresponding
% X-values.
%
% A point is considered a maximum peak if it has the maximal
% value, and was preceded (to the left) by a value lower by
% DELTA.

% Eli Billauer, 3.4.05 (Explicitly not copyrighted).
% This function is released to the public domain; Any use is allowed.

maxtab = [];
mintab = [];

v = v(:); % Just in case this wasn't a proper vector

%conditions to check/report error
if nargin < 3
x = (1:length(v))';
else
x = x(:);
if (length(v)~= length(x))
error('Input vectors v and x must have same length');
end
end

if (length(delta(:)))>1
error('Input argument DELTA must be a scalar');
end

if delta <= 0
error('Input argument DELTA must be positive');
end

%program
mn = Inf;
mx = -Inf;
mnpos = NaN;
mxpos = NaN;

lookformax = 1;

for i=1:length(v)
this = v(i);
if this > mx
mx = this;
mxpos = x(i);
end

if this < mn
mn = this;
mnpos = x(i);
end

if lookformax
if this < mx-delta
maxtab = [maxtab ; mxpos mx];
mn = this; mnpos = x(i);
lookformax = 0;
end
else
if this > mn+delta
mintab = [mintab ; mnpos mn];
mx = this; mxpos = x(i);
lookformax = 1;
end
end
end

% actual code -->JitterShimmer.m
% clear all
% close all
% 
% fs00;
% dt=1/fs;
% t=[0:dt:1];
% y=sin(2*pi*100*t);
% %find peaks in signal
% [maxs,mins]=peakdet(y,0.6,t);
% 
% plot(t,y);
% hold on;
% 
% %plot only maximums onto plot
% plot(maxs(:,1),maxs(:,2),'g*'); hold off;
% 
% %maximum peak values time in column 1
% peaktime=maxs(:,1);
% %peak maximum values in column 2
% peakval=maxs(:,2);
% 
% %pitch period
% pitchperiodss(diff(peaktime));
% 
% pchdiff=zeros(length(pitchperiods)-1,1);
% 
% %difference b/w successive pitch periods
% for k=1:length(pitchperiods)-1
% pchdiff(k)=(pitchperiods(k)-pitchperiods(k+1));
% end
% 
% avgpchdiff=mean(pchdiff);
% avgpch=mean(pitchperiods);
% 
% jitt=(avgpchdiff/avgpch)
% 
% pkdiffs(diff(peakval));
% avgpkdiff=mean(pkdiff);
% avgpks=mean(peakval);
% 
% shim=avgpkdiff/avgpks