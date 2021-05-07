function [c, d] = genKq( edata, order, nlim )
%genKq Compute the generalized entropy Kq
%   usage:
%
% input:
% edata  -  the embedded data, a N * dim matrix.
% order  -  q. For example '3' for q=3; 'inf' for q=inf; '-inf' for q=-inf;
% nlim   -  an variable in generalized entropy equation. n -> inf to get Kq
%
% output:
% c  -  the generalized correlation sum;
% d  -  search range log(r);
%
% the usage for the genDimension:
% [c,d] = genDimension(embedData, refIndices, searchRange, exclude, bins, flag, order);
% [c,d] = genDimension(x, randref(1,20000, 1000), 1, 40, 128, 2, 5);
%
% set default values:
rate = 0.1;
searchRange = 1;    % 1: r, relative range; 2: [rmin, rmax], rmin~rmax absolute range
exclude = 40;
bins = 128;
flag = 2;
% flag:
% 0: euclidian.norm, upper triangle matrix,
% 1: max.norm, upper triangle matrix
% 2: euclidian.norm, full matrix
% 3: max.norm, full matrix
% 567: not known, related to the verbose mode

% check the input variables
if ~isa(edata, 'double')
    fprintf(2, 'Input is not a double matrix of data set');
    return;
end

% construt new embed data set with input variable n
N = size(edata,1);
if N <= nlim
    fprintf(2, 'data set is too short');
    return;
else
    % reconstruct the data set with nlim. To calculate the generalized 
    % entropy lose the data in the tail of point set, totally (dim -1) * delay data points.
    edata_reconstruct = zeros(N-nlim+1, nlim);
    for i = 1:nlim
        edata_reconstruct(:,i) = edata(i: end-nlim+i, 1);
    end
end

edata2 = edata_reconstruct;
N = size(edata2, 1);

q = str2double(order);
if isnan(q) % input unrecognized string
    fprintf(2,'Input a number such as ''2.5'' or ''inf'', or ''-inf''.');
    return;
elseif q == Inf % input 'inf'
    [c,d] = maxPCorr(edata2, randref(1,N, N*rate), searchRange, ...
        exclude, bins, flag, 2);
elseif q == -Inf % input '-inf'
    [c,d] = minPCorr(edata2, randref(1,N, N*rate), searchRange, ...
        exclude, bins, flag, 2);
elseif q==1 % input '1'
    fprintf(2, 'q cannot be 1');
    return;
else % input a double other than 1
    [c,d] = genDimension(edata2, randref(1,N, N*rate), searchRange,...
        exclude, bins, flag, q);
end

end

