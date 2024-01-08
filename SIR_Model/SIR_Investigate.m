%%
% This script runs 500 trials of the stochastic SIR model and compares it
% against the mean field result
%%
clear; close all; clc;

rng(101);
NTot = 1000; % total number of individuals
pInf = 0.001;
beta = 0.2; % infection rate
nu = 0.1; % recovery rate

fprintf('The R_0 value is %.2f\n',beta/nu)

numTrials = 500;
maxT=0;
for ii = 1:numTrials
    [INum,SNum,TVec] = SIR_Stochastic_Fn(NTot,pInf,beta,nu);

    IAllTemp{ii} = INum;
    TAllTemp{ii} = TVec;
    if max(TVec) > maxT
        maxT = max(TVec);
    end
end

%% Post-processing (so that all trials have the same time vector)
TVec = [0:0.01:maxT];
IAll = zeros(length(TVec),numTrials);
outbreakIndices = [];
for ii = 1:numTrials
    TAllTemp{ii}(end+1) = maxT+1;
    IAllTemp{ii}(end+1) = 0;
    IAll(:,ii) = interp1(TAllTemp{ii},IAllTemp{ii},TVec);

    if max(IAllTemp{ii}) >10
        outbreakIndices = [outbreakIndices,ii];
    end
end

%% Plot the first 100 simulation trials

figure(1); clf; 
plot(TVec,IAll(:,[1:100]))
set(gca,'fontsize',16)
xlabel('Time')
ylabel('Number Infected')

%% Plot the average over the different trials

colorScheme = [0 0.447 0.741; 0.85 0.325 0.098; 0.929 0.694 0.125];
figure(2); clf; hold on;
SEM = std(IAll,[],2)/sqrt(numTrials);
CI95 = SEM * tinv(0.975, numTrials-1);  
patch([TVec fliplr(TVec)], [(mean(IAll,2)+CI95)' fliplr((mean(IAll,2)-CI95)')]/NTot, [0.75 0.75 0.75])
stochAve = plot(TVec,mean(IAll,2)/NTot,'Color',colorScheme(2,:),'linewidth',2);
xlim([0 150])
set(gca,'fontsize',16)
xlabel('Time')
ylabel('Fraction of Population Infected')

%%

fprintf('Percent of Trials with Outbreaks: %d%%\n',round(sum(outbreakIndices>0)/numTrials*100))

%% Plot the mean field results
[IVec,SVec,tVec] = SIF_MeanField_Fn(NTot,pInf,beta,nu);
detAve = plot(tVec, IVec,'--','linewidth',1.5,'color',colorScheme(2,:));
xlim([0 130])
legend([stochAve, detAve],{'Sim Ave','Mean Field Model'})

%% Now lets just average over the trials where an outbreak occurred

figure(3); clf; hold on;
SEM = std(IAll(:,outbreakIndices),[],2)/sqrt(size(outbreakIndices,2));
CI95 = SEM * tinv(0.975, size(outbreakIndices,2)-1);  
patch([TVec fliplr(TVec)], [(mean(IAll(:,outbreakIndices),2)+CI95)' fliplr((mean(IAll(:,outbreakIndices),2)-CI95)')]/NTot, [0.75 0.75 0.75])
stochAve=plot(TVec,mean(IAll(:,outbreakIndices),2)/NTot,'color',colorScheme(2,:),'linewidth',2);
detAve=plot(tVec, IVec,'--','linewidth',1.5,'color',colorScheme(2,:));
xlim([0 150])
set(gca,'fontsize',16)
xlabel('Time')
ylabel('Fraction of Population Infected')
legend([stochAve, detAve],{'Sim Ave','Mean Field Model'})

%%

