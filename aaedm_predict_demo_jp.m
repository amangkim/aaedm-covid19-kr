% aaedm_predict_demo_jp
%
% AAEDM Prediction Demo
% Made by Amang Kim [v0.3 || 4/9/2020]


clear all

D = load('aaedm_covid_dataset_jp.mat');
D0 = D.aaedm;
%---------- 2/20~3/11/2020 (20 days)
d= D0.Covid19(33:53);
c= D0.Cure(33:53);
t = D0.Temp(33:53);
day0 = D0.DaySq(33:53);


A = aaedmpredict(d,c,0)
%   AAEDM.PredFcn   : N = Fcn (day, n0_0, dn0_1, kappa_u, zeta_u)
%   AAEDM.u_star    : Cycle period (days)
%   AAEDM.Kappa     : Kappa (i.e., cure rate)
%   AAEDM.Zeta      : Zeta (i.e., net ratio)
%   AAEDM.Accuracy  : Accuracy of AAEDM prediction 
%   AAEDM.N_predict : Predicted growth (Covid-19) 
%   AAEDM.Delta0    : Delta0 (2.10)
%   AADEM.Gap       : Intital Delta [Day_difference Growth_difference];

u_star = A.u_star;
kappa_u = A.Kappa;
zeta_u = A.Zeta;
PredFcn = A.PredFcn;

%------------------------Testing
dv= D0.Covid19(53:73);
dayv0 = D0.DaySq(53:73);

[deltv] = aaedmdeltagen(dv,0,0);
Idx1 = find(deltv ~=0);
%--------------------------

day_r = [1:u_star]';
alpha = (1-kappa_u)*zeta_u;

n0_0 = dv(1);
dn0_1 = sum(deltv)/u_star;

M1 = PredFcn (day_r, n0_0, dn0_1, kappa_u, zeta_u);
M0 = [n0_0; M1];

%---------------------------------------------
figure
hold on
grid on
title('Prediction period (3/11-3/31/2020) @JP');
%xlabel(['Prdiction sequence || [u* = ' num2str(u_star) ', 2u*] (days)']);
xlabel(['Prdiction sequence || [u*,2u*] u* = ' num2str(u_star) ' (days)']);
ylabel('Accumulated number of infected people');
plot(dayv0,dv,'.','MarkerSize',15);
plot(dayv0,M0,'.','MarkerSize',15);
%plot(dayv0,M0,'LineWidth',1);
legend('Real data','Prediction','Location','northwest');
hold off
%----------------------------------------------------------


