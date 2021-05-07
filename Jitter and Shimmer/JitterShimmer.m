function [shimmer, jitter]=JitterShimmer(data,timeArray,Fs)
dt=1/Fs;

[maxs,~]=peakdet(data,dt,timeArray);
% plot(t,y);
% hold on;

%plot only maximums onto plot
%plot(maxs(:,1),maxs(:,2),'g*'); hold off;

%maximum peax values time in column 1
peaktime=maxs(:,1);
%peax maximum values in column 2
peakval=maxs(:,2);

%pitch period
pitchperiods=(diff(peaktime));

pchdiff=zeros(length(pitchperiods)-1,1);

%difference b/w successive pitch periods
for data=1:length(pitchperiods)-1
pchdiff(data)= abs(pitchperiods(data)-pitchperiods(data+1));
end

avgpchdiff=mean(pchdiff);
avgpch=mean(pitchperiods);

jitter=(avgpchdiff/avgpch);

pxdiff=(diff(peakval));
avgpxdiff=mean(pxdiff);
avgpxs=mean(peakval);

shimmer=avgpxdiff/avgpxs;
end