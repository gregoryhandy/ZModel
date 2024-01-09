%%
% This script runs 500 trials of the stochastic SIR model and compares it
% against the mean field result
%
% Written by Gregory Handy
%%
clear; close all; clc;

% Add all of the folders to the path to easily call functions
restoredefaultpath;
folder = fileparts(which('SIR_MultipleTrials.m')); 
addpath(genpath(folder));
rmpath(folder);

%% Key parameters

rng(101); % seed the random number generator for consistency
NTot = 1000; % total number of individuals
pInf = 0.001;
beta = 0.2; % infection rate
nu = 0.1; % recovery rate

numTrials = 500; % number of trials to run

fprintf('The R_0 value is %.2f\n',beta/nu)

%% Run the stochastic simulations
% Note: the trials end when the number of infected drops to 0, so the
% length of time for each trial varies; post-processing fixes this

maxT=0;
for ii = 1:numTrials
    [INum,SNum,TVec] = SIR_Stochastic(NTot,pInf,beta,nu);
    
    % Store the results here until the post-processing step
    IAllTemp{ii} = INum;
    SAllTemp{ii} = SNum;
    TAllTemp{ii} = TVec;

    % find and store the max length of time across all simulations
    if max(TVec) > maxT
        maxT = max(TVec);
    end
end

% Post-processing (so that all trials have the same time vector)
[TVec,IAll,SAll] = ...
    Stochastic_PostProcessing(TAllTemp,maxT,IAllTemp,SAllTemp);

%% Plot the first 100 simulation trials

linewidth = 5;
fontsize = 30;
figure(1); clf;
plot(TVec,IAll(:,1:100),'linewidth',linewidth)
set(gca,'fontsize',fontsize)
xlabel('Time')
ylabel('Number Infected')

%% Plot statistics 
figure(2);
[maxVal,maxIndex] = max(IAll,[],1);
endIndex = zeros(numTrials,1);
for ii = 1:numTrials
    temp = find(IAll(:,ii)<10e-5,1);
    if ~isempty(temp)
        endIndex(ii) = temp;
    else
        endIndex(ii) =  size(IAll,1);
    end
end

subplot(1,2,1)
histogram(maxVal,10)
set(gca,'fontsize',fontsize)
xlabel('Max Number Infected')
ylabel('Number of trials')

subplot(1,2,2)
histogram(TVec(endIndex),10)
xlabel('Time of outbreak ending')
set(gca,'fontsize',fontsize)
ylabel('Number of trials')

fprintf('Percent of Trials with Outbreaks: %d%%\n',round(sum(max(IAll,[],1)>10)/numTrials*100))

%% Plot the average over the different trials

colorScheme = [0 0.447 0.741; 0.85 0.325 0.098; 0.929 0.694 0.125];
figure(3); clf; hold on;
SEM = std(IAll,[],2)/sqrt(numTrials);
CI95 = SEM * tinv(0.975, numTrials-1);  
patch([TVec fliplr(TVec)], [(mean(IAll,2)+CI95)' fliplr((mean(IAll,2)-CI95)')]/NTot, [0.75 0.75 0.75])
stochAve = plot(TVec,mean(IAll,2)/NTot,'Color',colorScheme(2,:),'linewidth',linewidth);
xlim([0 150])
set(gca,'fontsize',fontsize)
xlabel('Time')
ylabel('Fraction of Population Infected')

%% Plot the mean field results
[IVec,SVec,tVec] = SIR_MeanField(pInf,beta,nu,2000);
figure(3);
detAve = plot(tVec, IVec,'--','linewidth',linewidth,'color',colorScheme(2,:));
xlim([0 130])
legend([stochAve, detAve],{'Sim Ave','Mean Field Model'})

%% Now lets just average over the trials where an outbreak occurred

outbreakIndices =find(max(IAll,[],1)>10);

figure(4); clf; hold on;
SEM = std(IAll(:,outbreakIndices),[],2)/sqrt(size(outbreakIndices,2));
CI95 = SEM * tinv(0.975, size(outbreakIndices,2)-1);  
patch([TVec fliplr(TVec)], [(mean(IAll(:,outbreakIndices),2)+CI95)' fliplr((mean(IAll(:,outbreakIndices),2)-CI95)')]/NTot, [0.75 0.75 0.75])
stochAve=plot(TVec,mean(IAll(:,outbreakIndices),2)/NTot,'color',colorScheme(2,:),'linewidth',linewidth);
detAve=plot(tVec, IVec,'--','linewidth',linewidth,'color',colorScheme(2,:));
xlim([0 150])
set(gca,'fontsize',fontsize)
xlabel('Time')
ylabel('Fraction of Population Infected')
legend([stochAve, detAve],{'Sim Ave','Mean Field Model'})
