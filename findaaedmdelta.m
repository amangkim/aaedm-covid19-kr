function [NetDelta, DaySq] = findaaedmdelta( data0 )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

d = data0;
l = length(d);
day0 = [0:l-1];
delt = [];
days = [];

for i = 2:l
	delta = d(i)-d(i-1);
    
    if delta ~=0
        delt = [delt delta];
        days = [days day0(i)];
    else
        %day0(i)
        %pause;
    end
    
end


NetDelta = delt(:);
DaySq = days(:);
end

