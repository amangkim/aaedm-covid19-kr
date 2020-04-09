function [EpidNetRatio, DayIndx, u_star ] = epidnetratiogen(varargin)
% Generating the ratio between the present and the past net (daily) increases
%
% Usage:
%  [EpidNetRatio, DayIndx, u_star ] = epidnetratiogen(EpidemicGrowth, EndDay, DispOpn)
%
% Output:
%   EpidNetRatio : Ratio between two epidemic net increase -- Delta[i, i-1]
%   DayIndx : Days (2,...,n)
%   u_star : Last day of the cycle
%
% Input:
%   EpidemicGrowth : Epidemic data
%	EndDay : Cycle duration (u_star, 0 == total length)
%   DispOpn : Display Option [Off (0) or On (1)]
%
% Note:
%   - Required function: aaedmdeltagen
%	
% Made by Amang Kim [v0.2 || 4/7/2020]


%---------------({'epiddata', 'DispOptn'}
inputs={'epiddata','endday','DispOptn'};
DispOptn = 0;
endday = 0;

for n=1:nargin
    if(~isempty(varargin{n}))
        eval([inputs{n} '=varargin{n};'])
    end
end
%-----------------------------

if endday == 0
    len = length(epiddata);
else
    len = endday+1;
end
    
N = epiddata(1:len);
dN = aaedmdeltagen(N);

len_dn = length(dN);

rho = [];
D = [];
j=1;

for i = 2:len_dn
    
    d1 = i;
    
    if dN(i-1) ~= 0
        D = [D d1];        
        rho1 = dN(i)/dN(i-1);
        rho = [rho rho1];

    end
    
end

EpidNetRatio = rho(:);
DayIndx = D(:);
u_star = D(length(D));


dN_rev = dN(2:len_dn);



b_idx = [0:u_star+1];
baseline = ones(1,length(b_idx));

if DispOptn >= 1 %-----------------------------------

    figure
    hold on
    grid on
    title(['Daily net increase ratio (rho), u*=' num2str(u_star) ' [days]']);
    xlabel('Day sequence (n-th day)');
    ylabel('Ratio of epidemic increase');
	ax = gca;
    ax.XLim = [0 u_star+1];
    %ax.YLim = [0 max(dN)*1.12];
    %plot(D, rho,'r*');
    plot(D, rho,'r.','MarkerSize',18);
    plot(D, rho,'g');    
    plot(b_idx, baseline,'k');
    hold off
  

end %----------------------------------------------


end

