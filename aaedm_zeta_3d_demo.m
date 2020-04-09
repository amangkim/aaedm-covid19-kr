% aaedm_zeta_3d_demo
%
% AAEDM Zeta 3D demonstrations
% Made by Amang Kim [v0.3 || 4/9/2020]



clear all
kr = load('aaedm_covid_dataset_kr_basic.mat');
dataset = kr.aaedm;

%----- 2020/2/29 -- 3/20
d = dataset.Covid19(40:60);
day = dataset.DaySq(40:60);



N_all = d;

u_star = 20;

N_train = d(1:u_star+1);
day_N =[0:u_star]';


[net,d1] = aaedmdeltagen(N_train);
[rho,d2] = epidnetratiogen(N_train);



%--------------------------
kappa_0 =  1/48;
kappa_10 = 3/600;
kappa_20 = 45/118;
%--------------------------

kappa_u = kappa_20;


n0_0 = N_train(1);
n0_1 = N_train(2);
dn0_1 = net(1);

day_r = day(d2+1);
%-----------------------------



%------------------ 3d-grphics
M3DMat = [];
dM3DMat = [];
Zeta = [0:0.01:1];
M0 = [];
dM0 = [];

for i =1:length(Zeta)    
    zeta1 = Zeta(i);
    alpha = (1-kappa_u)*zeta1;
    Alpha = alpha.^d2;
    net1 = dn0_1*Alpha;
    alpha = (1-kappa_u)*zeta1;
    
    %alpha = (1-kappa1)*1.2;
    
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
title(['Zeta factor effects for virus growth (Kappa = ' num2str(kappa_u) ')']);
xlabel('Mean increase rate, Zeta~[0,1]');
ylabel('Day sequence [Day]');
zlabel('Number of growth');
surf(Zeta,day_r,M3DMat)

%--------------------------- 3D Graph

figure
hold on 
grid on
title(['Zeta factor effects for net increase (Kappa = ' num2str(kappa_u) ')']);
xlabel('Mean increase rate, Zeta~[0,1]');
ylabel('Day sequence [Day]');
zlabel('Number of growth');
surf(Zeta,day_r,dM3DMat);

%---------------------------


figure
hold on 
grid on
title('Zeta factor effects for virus growth (2D)');
xlabel('Day sequence [Day]');
ylabel('Number of growth');
plot(day_r,N_train(d2),'b','LineWidth',1.5);
plot(day_r,M3DMat);
legend('Real Data','Location','northwest');
%plot(d1,[net' dM3DMat])