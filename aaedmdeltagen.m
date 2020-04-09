function [EpidNet, DayIndx, u_star] = aaedmdeltagen(varargin)
% Generating the net (daily) increase of epidemic growth
%
% Usage:
%  [EpidNet, DayIndx, u_star] = aaedmdeltagen(EpidemicGrowth, EndDay, DispOpn)
%
% Output:
%   EpidNet : Difference between two epidemic growth -- Delta[i, i-1]
%   DayIndx : Days (1,...,n)
%   u_star : Last day of the cycle
%
% Input:
%   EpidemicGrowth: Epidemic data
%	EndDay: Cycle duration (u_star, 0 == total length)
%   DispOpn: Display Option [Off (0) or Delta (1) or Acculumate (2)]
%
% Note:
%   - N/A
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
dN = [];
D = [];

endday = len-1;

for i = 2:len

    dn1 = N(i)-N(i-1);
    d1 = i-1;
    
    dN = [dN dn1];
    D = [D d1];
    
end

EpidNet = dN(:);
DayIndx = D(:);
u_star = D(length(D));

%N_rev = N(2:len);
N_rev = N(DayIndx);


if DispOptn >= 1 %-----------------------------------

    figure
    hold on
    grid on
    title(['Daily net increase || u*=' num2str(u_star) ' [days]']);
    xlabel('Day sequence (n-th day)');
    
    ylabel('Net number of epidemic increase');
    ax = gca;
    ax.XLim = [0 u_star+1];

    if DispOptn == 2
        bar(D, N_rev,'c');
        plot(D, dN,'r');    
        legend('Accumulated','Daily Increase','Location','northwest');
    else
        ax.YLim = [0 max(dN)*1.12];
        %plot(D, dN,'r*');
        plot(D, dN,'r.','MarkerSize',18);
        plot(D, dN,'c');    
    end
    
    hold off
  

end %----------------------------------------------




end

