%%
%
%%
clear; close all; clc;

restoredefaultpath;
folder = fileparts(which('ZModelPlots.m')); 
addpath(genpath(folder));
rmpath(folder);

%%

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

%%
plotNeighborhood(popTable,1,numHouses)

%% Key parameters and counters

incorrectRemoval = 0;
correctRemoval = 0;
totalDays = 50;

totalHealthy = zeros(totalDays,1);
totalInf = zeros(totalDays,1);
totalZombies = zeros(totalDays,1);
totalCorrectRemoval = zeros(totalDays,1);
totalIncorrectRemoval = zeros(totalDays,1);
%%
for dayLoop = 1:totalDays
    
    %% Plot the neighborhood; get current statistics
    plotNeighborhood(popTable,1,numHouses)
    title(sprintf('Day %d',dayLoop),FontSize=16)


    totalHealthy(dayLoop) = sum(popTable.healthStatus==1);
    totalInf(dayLoop) = sum(popTable.healthStatus==0);
    totalZombies(dayLoop) = sum(popTable.healthStatus==-1);
    totalCorrectRemoval(dayLoop) = correctRemoval;
    totalIncorrectRemoval(dayLoop) = incorrectRemoval;
    pause(0.5);

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

%%
figure(); 
subplot(1,2,1); hold on;
plot(totalHealthy,'linewidth',1.5)
plot(totalInf,'linewidth',1.5)
plot(totalZombies,'linewidth',1.5)
legend('Healthy','Infected','Zombie')
set(gca,'fontsize',16)
xlabel('Days')
ylabel('Total Number')

subplot(1,2,2); hold on;
plot(totalCorrectRemoval,'linewidth',1.5)
plot(totalIncorrectRemoval,'linewidth',1.5)
legend('Correct Removal','Incorrect Removal')
set(gca,'fontsize',16)
xlabel('Days')
ylabel('Total Number')

%% Plot the final neighborhood and statistics



%%




