%% 
% Runs a single trials of the stochastic SIR model and compares it against
% the mean field model
%
% Written by Gregory Handy
%%
clear; close all; clc;

% Add all of the folders to the path to easily call functions
restoredefaultpath;
folder = fileparts(which('SIR_SingleTrial.m')); 
addpath(genpath(folder));
rmpath(folder);


%% Key parameters

rng(101); % seed the random number generator for consistency
% rng(102);
NTot = 1000; % total number of individuals
pInf = 0.001; % proportion of population initially infected
beta = 0.2; % infection rate
nu = 0.1; % recovery rate

fprintf('The R_0 value is %.2f\n',beta/nu)

%% First run the stochastic simulation and plot the results

[INum,SNum,TVec] = SIR_Stochastic(NTot,pInf,beta,nu);
    
fprintf('Total recovered: %d\n',(NTot - (SNum(end)+INum(end))))

linewidth = 5;
fontsize = 30;
figure(1); clf; hold on;
plot(TVec,SNum/NTot,'linewidth',linewidth)
plot(TVec,INum/NTot,'linewidth',linewidth)
plot(TVec,(NTot - (SNum+INum))/NTot,'linewidth',linewidth)
legend('Susceptible','Infected','Recovered','AutoUpdate','off')
set(gca,'fontsize',fontsize)
ylabel('Proportion of the Pop')
xlabel('Time')
xlim([0 130])

%% Now run the mean-field simulation and add these results

[IVec,SVec,tVec] = SIR_MeanField(pInf,beta,nu,2000);

figure(1); hold on;
colorScheme = [0 0.447 0.741; 0.85 0.325 0.098; 0.929 0.694 0.125];
plot(tVec, SVec,'--','linewidth',linewidth,'color',colorScheme(1,:))
plot(tVec, IVec,'--','linewidth',linewidth,'color',colorScheme(2,:))
plot(tVec, 1-(SVec+IVec),'--','linewidth',linewidth,'color',colorScheme(3,:))
xlim([0 130])

