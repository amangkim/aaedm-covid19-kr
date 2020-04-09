function KappaZeta = findkappazeta(varargin)
% Finding the Kappa and the Zeta factors base on Epidemic Data
%
% Usage:
%   KappaZeta = findkappazeta(Covid_Infection,CurePeople,u_star)
%
% Output: AAEDM
%   KappaZeta.Kappa   : Kappa (mean)
%   KappaZeta.Zeta    : Zeta (mean);
%   KappaZeta.DaySq   : non-zero delta day sequences;
%   KappaZeta.KappaSq : Kappa sequences;
%   KappaZeta.dCure   : non-zero delta of cure data;
%
% Input:
%   Covid_Infection : Growth number of infected peeople
%   Cure            : Number of cured people
%   u_star          : Cycle period (days)
%
% Note:
%   - Required Matlab file(s): aaedmdeltagen, epidnetratiogen, findaaedmdelta
%   - Reference DB structure is designed by Amang Kim
%   
% Made by Amang Kim [v0.1 || 4/8/2020]

%-----------------------------
inputs={'CovidData', 'Cure', 'u_star','DispOptn'};
DispOptn = 0;
u_star =0;

for n=1:nargin
    if(~isempty(varargin{n}))
        eval([inputs{n} '=varargin{n};'])
    end
end

%-----------------------------

d = CovidData;
c = Cure;
day_end = length(d)-1;
day0 = [0:day_end];

[delta,day1,u_star] = aaedmdeltagen(d,u_star,DispOptn);
[rho,day2] = epidnetratiogen(d,u_star,DispOptn);
[cure_delta day_c] =  findaaedmdelta(c);

%day2 = day1(day2_idx);


%---- Calculating Kappa
Idx1 = find(delta ~=0);
[Idx2 val] = find(day2 == day1(Idx1).');
[Idx3 val] = find(day_c == day2(Idx2).');

Kappa = cure_delta(Idx3)./delta(day_c(Idx3));

%-----[day_c(Idx3) cure_delta(Idx3) Kappa]
% Kappa = c./d;
% Kappa_m = sum(Kappa)/u_star

Kappa_m = sum(Kappa)/u_star;
zeta_u = mean (rho);

%================================================

S.Kappa = Kappa_m;
S.Zeta = zeta_u;
S.DaySq = day_c(Idx3);
S.KappaSq = Kappa;
S.dCure = cure_delta(Idx3);


KappaZeta = S;


end

