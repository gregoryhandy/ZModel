%%
% Deterministic SIR
%%

clear; close all; clc;

betaV2 = 0.15; % infection rate
nuV2 = 0.1; % recovery rate

NTot = 1000; % total number of individuals
pInf = 0.001;

beta = betaV2;
nu = nuV2;

fprintf('The R_0 value is %.2f\n',beta/nu)
[IVec,SVec,tVec] = SIF_MeanField_Fn(NTot,pInf,beta,nu);

simStop = tVec(find(IVec<10e-5,1));
if isempty(simStop)
    simStop = 130;
end


figure(1); hold on;
colorScheme = [0 0.447 0.741; 0.85 0.325 0.098; 0.929 0.694 0.125];
plot(tVec, SVec,'-','linewidth',1.5,'color',colorScheme(1,:))
plot(tVec, IVec,'-','linewidth',1.5,'color',colorScheme(2,:))
plot(tVec, 1-(SVec+IVec),'-','linewidth',1.5,'color',colorScheme(3,:))
xlim([0 simStop])
legend('Susceptible','Infected','Recovered','AutoUpdate','off')
set(gca,'fontsize',16)
ylabel('Proportion of the Pop')
xlabel('Time')



