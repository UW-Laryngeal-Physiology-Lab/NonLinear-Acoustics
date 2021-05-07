function [pStart, pEnd] = computeSlope(X,Y,txy )
%computeSlope locate the linear section of a plot and determine its slope 
%   Input Arguments
%       X & Y: cell arrays containing data to be plotted
%       txy: array of string containing Title, xLabel, yLabel

colors = 'brgkmcy';    % rgb ymc kw
figure; hold on; datacursormode on;
for n=1:length(X)
    R=X{n}; C=Y{n};
    plot(R, C, colors(n));
end

title(txy{1});   xlabel(txy{2});    ylabel(txy{3});
a = input('Linear region starts at: ');
b = input('Linear region ends at: ');
region = find(R>a & R<b);
[x, ~, ~] = lscov([R(region),ones(length(region),1)],C(region));

plot(R(region), R(region)*x(1)+x(2), 'm');

text((R(region(1))+R(region(end)))/2, (C(1)+C(end))/2, ['Dimension = ' num2str(x(1))] );
fprintf(2,['Dimension = ' num2str(x(1))   '\n']);
if(length(X) > 1)
    text((R(region(1))+R(region(end)))/2, (C(1)+C(end))/2-2, ['Entropy = ' num2str(x(2))] );
    fprintf(2,['Entropy = '  num2str(x(2))   '\n']);
end

end

