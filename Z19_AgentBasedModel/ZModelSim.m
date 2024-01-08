%%
%
%%
clear; close all; %clc;

restoredefaultpath;
folder = fileparts(which('ZModelPlots.m')); 
addpath(genpath(folder));
rmpath(folder);
%%

totalTrials = 500;
corrNum = zeros(totalTrials,1);
incNum = zeros(totalTrials,1);
numSurvivors=zeros(totalTrials,1);
outcome = zeros(totalTrials,1);

for trialLoop = 1:totalTrials

numIndividuals = 25;
% Preallocate array
numTraits = 5;
popData = zeros(numIndividuals,numTraits);
for ii = 1:numIndividuals
    popData(ii,:) =  createInd(ii);
end

popTable = array2table(popData,'VariableNames',{'ID','healthStatus',...
    'hitPoints','infDays','susThres'});
popTable.susLevel=zeros(numIndividuals,numIndividuals);

% Initialize the neighborhood
numHouses = 5;
popTable = initializeNeighborhood(popTable,numHouses);

%% Key parameters and counters

incorrectRemoval = 0;
correctRemoval = 0;
totalDays = 1000;

totalHealthy = zeros(totalDays,1);
totalInf = zeros(totalDays,1);
totalZombies = zeros(totalDays,1);
totalCorrectRemoval = zeros(totalDays,1);
totalIncorrectRemoval = zeros(totalDays,1);
%%
for dayLoop = 1:totalDays
    
    %% Get current statistics
    totalHealthy(dayLoop) = sum(popTable.healthStatus==1);
    totalInf(dayLoop) = sum(popTable.healthStatus==0);
    totalZombies(dayLoop) = sum(popTable.healthStatus==-1);
    totalCorrectRemoval(dayLoop) = correctRemoval;
    totalIncorrectRemoval(dayLoop) = incorrectRemoval;


    if totalZombies(dayLoop)+totalInf(dayLoop)==0 || totalHealthy(dayLoop)+totalInf(dayLoop)==0
        totalHealthy(dayLoop:end) = totalHealthy(dayLoop);
        totalZombies(dayLoop:end) = totalZombies(dayLoop);
        totalCorrectRemoval(dayLoop:end) = totalCorrectRemoval(dayLoop);
        totalIncorrectRemoval(dayLoop:end) = totalIncorrectRemoval(dayLoop);
        break;
    end

    %% Start of turn; build suspicion based on coughs if no Zombies present
    [popTable] = startOfTurn(popTable,dayLoop,numHouses);

    %% During turn actions
    [popTable,correctRemoval,incorrectRemoval] =...
        duringTurnActions(popTable,correctRemoval,incorrectRemoval,dayLoop,numHouses);

    %% End of turn updates
    [popTable] = endOfTurn(popTable,numHouses);
end


if totalHealthy>0
    outcome(trialLoop) = 1;
end
numSurvivors(trialLoop) = totalHealthy(end);
corrNum(trialLoop) = totalCorrectRemoval(end);
incNum(trialLoop) = totalIncorrectRemoval(end);
end

%%

% numSuccess/totalTrials



figure(1); clf;
% subplot(1,3,1)
piechart([mean(outcome),1-mean(outcome)],{'Success','Fail'})
set(gca,'fontsize',16)

figure(2); 
subplot(1,2,1);
histogram(numSurvivors(numSurvivors>0))
set(gca,'fontsize',16)
xlabel('Number of Survivors')
ylabel('Number of Trials')
subplot(1,2,2);
histogram(incNum)
set(gca,'fontsize',16)
xlabel('Innocent Bystanders')
ylabel('Number of Trials')

fprintf('-------------\n')
fprintf('Suspicion threshold %d\n',popTable.susThres(1))
fprintf('Trial success rate %.0f%% \n',mean(outcome)*100)
fprintf('Average number of survivors: %.2f\n',...
    mean(numSurvivors))
fprintf('Average number of survivors during successful simulations: %.2f\n',...
    mean(numSurvivors(numSurvivors>0)))
fprintf('Average number of mistakes during successful simulations: %.2f\n',...
    mean(incNum(numSurvivors>0)))
fprintf('-------------\n')




%%




