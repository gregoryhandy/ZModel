%%
% This code runs the deterministic (i.e., mean field) version of the 
% S(usceptible)-I(nfected)-R(ecovered) model
%
% Written by Gregory Handy
%%
clear; close all;

% Add all of the folders to the path to easily call functions
restoredefaultpath;
folder = fileparts(which('SIR_MeanFieldSims.m')); 
addpath(genpath(folder));
rmpath(folder);

%% Key parameters

beta = 0.04; % infection rate
nu = 0.2; % recovery rate
pInf = 0.001; % proportion of population initially infected
tMax = 2000; % ending time point for the simulations

fprintf('The R_0 value is %.2f\n',beta/nu)

%% Run the simulation
[IVec,SVec,tVec] = SIR_MeanField(pInf,beta,nu,tMax);

%% Plot the results

% Determine when to cut off the plot
simStop = tVec(find(IVec<10e-5,1));
if isempty(simStop)
    simStop = 130;
end

linewidth = 5;
fontsize = 30;
figure(1); hold on;
% used to determine the line of the plots
colorScheme = [0 0.447 0.741; 
               0.85 0.325 0.098; 
               0.929 0.694 0.125];
plot(tVec, SVec,'-','linewidth',linewidth,'color',colorScheme(1,:))
plot(tVec, IVec,'-','linewidth',linewidth,'color',colorScheme(2,:))
plot(tVec, 1-(SVec+IVec),'-','linewidth',linewidth,'color',colorScheme(3,:))
xlim([0 simStop])
legend('Susceptible','Infected','Recovered','AutoUpdate','off')
set(gca,'fontsize',fontsize)
ylabel('Proportion of the Pop')
xlabel('Time')

%% Print out relevant statistics

[maxVal,maxIndex] = max(IVec);
endIndex = find(IVec<10e-5,1);

fprintf('----------------\n')
fprintf('Maximum fraction infected: %.2f\n',maxVal)
fprintf('Time of maximum: %.2f\n',tVec(maxIndex))
fprintf('Time of outbreak maximum: %.2f\n',tVec(maxIndex))
fprintf('Time of outbreak conclusion: %.2f\n',tVec(endIndex))
fprintf('----------------\n')

