%% 
% Stardard SIR model
%
%%
clear; close all; clc;

%% First run the stochastic simulation

rng(101);
% rng(102);
NTot = 1000; % total number of individuals
pInf = 0.001;
betaV2 = 0.2; % infection rate
nuV2 = 0.1; % recovery rate
[INum,SNum,TVec] = SIR_Stochastic_Fn(NTot,pInf,betaV2,nuV2);
    
fprintf('Total recovered: %d\n',(NTot - (SNum(end)+INum(end))))

linewidth = 3;
figure(1); clf; hold on;
plot(TVec,SNum/NTot,'linewidth',linewidth)
plot(TVec,INum/NTot,'linewidth',linewidth)
plot(TVec,(NTot - (SNum+INum))/NTot,'linewidth',linewidth)
legend('Susceptible','Infected','Recovered','AutoUpdate','off')
set(gca,'fontsize',16)
ylabel('Proportion of the Pop')
xlabel('Time')
xlim([0 130])

%% Now run the mean-field simulation
beta = betaV2;
nu = nuV2;

fprintf('The R_0 value is %.2f\n',beta/nu)
[IVec,SVec,tVec] = SIF_MeanField_Fn(NTot,pInf,beta,nu);

figure(1); hold on;
colorScheme = [0 0.447 0.741; 0.85 0.325 0.098; 0.929 0.694 0.125];
plot(tVec, SVec,'--','linewidth',1.5,'color',colorScheme(1,:))
plot(tVec, IVec,'--','linewidth',1.5,'color',colorScheme(2,:))
plot(tVec, 1-(SVec+IVec),'--','linewidth',1.5,'color',colorScheme(3,:))
xlim([0 200])
xlim([0 130])