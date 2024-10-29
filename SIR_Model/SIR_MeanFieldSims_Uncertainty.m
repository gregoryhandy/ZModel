%%
% This code runs the deterministic (i.e., mean field) version of the 
% S(usceptible)-I(nfected)-R(ecovered) model for a range of infection rates
% to show how uncertainty in this parameter may lead to very different
% predictions
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

% beta = 0.04; % infection rate
beta = 0.1 + 0.2*rand(100,1); % infection rate
% beta = 0.5 + 0.2*rand(100,1); % infection rate
nu = 0.2; % recovery rate
pInf = 0.001; % proportion of population initially infected
tMax = 2000; % ending time point for the simulations

IVec = zeros(200001,length(beta));

%% Run the simulation
for ii = 1:length(beta)

    [IVec(:,ii),~,tVec] = SIR_MeanField(pInf,beta(ii),nu,tMax);

    % Determine when to cut off the plot
    simStop(ii) = tVec(find(IVec(:,ii)<10e-5,1));
    if isempty(simStop)
        simStop = 130;
    end

end

%%

%%

linewidth = 2;
fontsize = 30;
f = figure(1); f.Position = [408 393 736 522]; clf; hold on;
% used to determine the line of the plots
colorScheme = [0 0.447 0.741; 
               0.85 0.325 0.098; 
               0.929 0.694 0.125];
% plot(tVec, SVec,'-','linewidth',linewidth,'color',colorScheme(1,:))
plot(tVec, IVec,'-','linewidth',linewidth,'color',[0.85 0.325 0.098 0.2])
plot(tVec, mean(IVec,2),'-','linewidth',5,'color','k')
% plot(tVec, 1-(SVec+IVec),'-','linewidth',linewidth,'color',colorScheme(3,:))
xlim([0 max(simStop)])
% legend('Susceptible','Infected','Recovered','AutoUpdate','off')
set(gca,'fontsize',fontsize)
ylabel('Proportion of the Pop')
xlabel('Time')
% title(sprintf('R_0=%.2f',beta/nu))

%% Print out relevant statistics

[maxVal,maxIndex] = max(IVec);

% endIndex = find(IVec<10e-4,1);
figure(2)
subplot(1,2,1)
boxplot(maxVal)
set(gca,'fontsize',fontsize)
xticklabels([])
ylabel('Max value of I(t)')

subplot(1,2,2)
boxplot(tVec(maxIndex))
set(gca,'fontsize',fontsize)
ylabel('Time of maximum')
xticklabels([])

%%
fprintf('----------------\n')
fprintf('Maximum fraction infected: %.2f\n',maxVal)
fprintf('Time of maximum: %.2f\n',tVec(maxIndex))
fprintf('Time of outbreak maximum: %.2f\n',tVec(maxIndex))
fprintf('Time of outbreak conclusion: %.2f\n',tVec(endIndex))
fprintf('----------------\n')


plot(tVec(maxIndex)+[0 0],[0 1],'k--','LineWidth',1.5)
plot(tVec(endIndex)+[0 0],[0 1],'k--','LineWidth',1.5)
