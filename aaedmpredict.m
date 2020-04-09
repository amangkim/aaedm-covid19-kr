function AAEDM = aaedmpredict(varargin)
% Package for the AAEDM for Covid-19 Epidemic
%
% Usage:
%   [AAEDM] = aaedmpredict(Covid_Infection,CurePeople,DispOptn)
%
% Output: AAEDM
%   AAEDM.PredFcn   : N = Fcn (day, n0_0, dn0_1, kappa_u, zeta_u)
%   AAEDM.u_star    : Cycle period (days)
%   AAEDM.Kappa     : Kappa (i.e., cure rate)
%   AAEDM.Zeta      : Zeta (i.e., net ratio)
%   AAEDM.Accuracy  : Accuracy of AAEDM prediction 
%   AAEDM.N_predict : Predicted growth (Covid-19) 
%   AAEDM.Delta0    : Delta0 (2.10)
%   AADEM.Gap       : Intital Delta [Day_difference Growth_difference];
%
% Input:
%   Covid_Infection : Growth number of infected peeople
%   Cure            : Number of cured people
%   DispOptn        : Display option for AAEDM [1:ON, 0:OFF]
%
% Note:
%   - Required Matlab file(s): aaedmdeltagen, epidnetratiogen,
%           findaaedmdelta, findkappazeta
%   - Reference DB structure is designed by Amang Kim
%   
% Made by Amang Kim [v0.3 || 4/8/2020]


%-----------------------------
inputs={'CovidData', 'Cure', 'DispOptn'};
DispOptn = 0;

for n=1:nargin
    if(~isempty(varargin{n}))
        eval([inputs{n} '=varargin{n};'])
    end
end

%-----------------------------

d = CovidData;
c = Cure;
day_end = length(d)-1;
day0 = [0:day_end]';
[delta,day1,u_star] = aaedmdeltagen(d,0,0);
%[rho,day2] = epidnetratiogen(d,0,0);
%[cure_delta day_c] =  findaaedmdelta(c);

%day2 = day1(day2_idx);


%-------- Calculating Kappa
Idx1 = find(delta ~=0);
KZ = findkappazeta(d,c,0,DispOptn);

Kappa_m = KZ.Kappa;
zeta_u = KZ.Zeta;
%--------------------------

n0_0 = d(1);
n0_1 = d(day1(Idx1(1))+1);



kappa_u = Kappa_m;
alpha = (1-kappa_u)*zeta_u;
dn0_1 = sum(delta)/u_star*alpha;
%dn0_1 = (n0_1-n0_0)/day1(Idx1(1));

%------------------------------

Alpha = alpha.^day1;
net1 = dn0_1*Alpha;

N1 = n0_0*ones(length(day1),1)+dn0_1/(alpha-1)*(Alpha-ones(length(day1),1));
M0 = [n0_0; N1];

er = finderrrate(d, M0);
acc = 1-er;


Fcn = @(d, d0, delt0, kappa, zeta) d0+delt0*(((1-kappa)*zeta).^d-1)/((1-kappa)*zeta-1);
%a = Fcn (day1, n0_0, dn0_1, kappa_u, zeta_u)
%a0 = [n0_0; a];

%acc;
%N_Predict = M0;
d0_dDay_dN = [day1(Idx1(1)) (n0_1-n0_0)];
Delta0 = dn0_1; 
%u_star
%kappa_u
%zeta_u

S.PredFcn = Fcn;
S.u_star = u_star;
S.Kappa = kappa_u;
S.Zeta = zeta_u;
S.Accuracy = acc;

S.N_predict = M0;
S.Delta0 = Delta0;
S.GapInfo_dDay_dN = d0_dDay_dN;

AAEDM = S;


if DispOptn == 1 %---------------------------------------------

    figure
    hold on
    grid on
    title('Epidemic growth (validation period)');
    xlabel(['Prdiction sequence || u* = ' num2str(u_star) ' [day]']);
    ylabel('Accumulated number of infected people');
    plot(day0,d,'.','MarkerSize',15);
    plot(day0,M0,'LineWidth',1);
	legend('Real data','Prediction','Location','northwest');
    hold off

end %----------------------------------------------------------


end

