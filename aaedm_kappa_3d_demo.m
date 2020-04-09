% aaedm_kappa_3d_demo
%
% AAEDM Kappa 3D demonstrations
% % Made by Amang Kim [v0.3 || 4/9/2020]

clear all
kr = load('aaedm_covid_dataset_kr_basic.mat');
dataset = kr.aaedm;

d = dataset.Covid19(40:60);
day = dataset.DaySq(40:60);


N_all = d;

u_star = 20;

N_train = d(1:u_star+1);
%day =[0:u_star]';


[net,d1] = aaedmdeltagen(N_train);
[rho,d2] = epidnetratiogen(N_train); %,0,1);

zeta_u = mean (rho);
%zeta_u = rho(length(rho));

n0_0 = N_train(1);
n0_1 = N_train(2);
dn0_1 = net(1);

day_r = day(d2+1);
%-----------------------------


%------------------ 3d-grphics
M3DMat = [];
dM3DMat = [];
Kappa = [0:0.01:1];
M0 = [];
dM0 = [];

for i =1:length(Kappa)
    kappa1 = Kappa(i);
    alpha = (1-kappa1)*zeta_u;
    Alpha = alpha.^d2;
    net1 = dn0_1*Alpha;
    alpha = (1-kappa1)*zeta_u;

    
    N1 = n0_0*ones(length(d2),1)+dn0_1/(alpha-1)*(Alpha-ones(length(d2),1));
    M0 = [N1];    
    dM0 = [net1];

    
    M3DMat = [M3DMat M0];
    dM3DMat = [dM3DMat dM0];
    
    
end

%--------------------------- 3D Graph
figure
hold on 
grid on
title(['Kappa factor effects for virus growth (zeta = ' num2str(zeta_u) ')']);
xlabel('Cure rate, Kappa~[0,1]');
ylabel('Day sequence [Day]');
zlabel('Number of growth');
surf(Kappa,day_r,M3DMat)
%size(M3DMat)

%--------------------------- 3D Graph

figure
hold on 
grid on
title(['Kappa factor effects for net increase (zeta = ' num2str(zeta_u) ')']);
xlabel('Cure rate, Kappa~[0,1]');
ylabel('Day sequence [Day]');
zlabel('Number of daily net growth');
%surf(Kappa,day_N(d2),dM3DMat);
surf(Kappa,day_r,dM3DMat);
%size(dM3DMat)

%---------------------------

kappa_half_idx = find(Kappa==0.5);

M3DMat_half = M3DMat(:,kappa_half_idx);

figure
hold on 
grid on
title('Kappa factor effects for virus growth (2D)');
xlabel('Day sequence [Day]');
ylabel('Number of growth');

plot(day_r,N_train(d2)','k','LineWidth',2);
plot(day_r,M3DMat_half','b','LineWidth',2);
plot(day_r,M3DMat);
legend('Real Data (Korea)','kappa = 0.5','Location','northwest');
hold off



















