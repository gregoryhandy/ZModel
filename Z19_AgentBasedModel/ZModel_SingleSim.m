%%
% Runs a single simulation of the Z-19 agent-based model
%
% Written by Gregory Handy
%%
clear; close all; clc;

restoredefaultpath;
folder = fileparts(which('ZModel_SingleSim.m')); 
addpath(genpath(folder));
rmpath(folder);

%% Key parameters for all trials
numIndividuals = 25;
numTraits = 5;
numHouses = 5;
susThres = 2;

%% Create the population of individuals

% Preallocate array for the population
popData = zeros(numIndividuals,numTraits);
% Create the individuals
for ii = 1:numIndividuals
    popData(ii,:) =  createInd(ii,susThres);
end
popTable = array2table(popData,'VariableNames',{'ID','healthStatus',...
    'hitPoints','infDays','susThres'});
popTable.susLevel=zeros(numIndividuals,numIndividuals);


%% Initialize the neighborhood

popTable = initializeNeighborhood(popTable,numHouses);

%% Plot the initial neighborhood

plotNeighborhood(popTable,1,numHouses)

%% Initialize counters and preallocate memory for arrays

incorrectRemoval = 0;
correctRemoval = 0;
maxDays = 50;

totalHealthy = zeros(maxDays,1);
totalInf = zeros(maxDays,1);
totalZombies = zeros(maxDays,1);
totalCorrectRemoval = zeros(maxDays,1);
totalIncorrectRemoval = zeros(maxDays,1);

%% Simulate days of the Z-19 outbreak
for dayLoop = 1:maxDays

    %% Start of turn; build suspicion based on coughs if no zombies present
    [popTable] = startOfTurn(popTable,dayLoop,numHouses);

    %% Plot the neighborhood; get current statistics at the start of the turn
    plotNeighborhood(popTable,1,numHouses)
    title(sprintf('Day %d',dayLoop),FontSize=16)

    totalHealthy(dayLoop) = sum(popTable.healthStatus==1);
    totalInf(dayLoop) = sum(popTable.healthStatus==0);
    totalZombies(dayLoop) = sum(popTable.healthStatus==-1);
    totalCorrectRemoval(dayLoop) = correctRemoval;
    totalIncorrectRemoval(dayLoop) = incorrectRemoval;
    pause(0.5);

    % End the simulation when no 1) zombie/infected or 2) health individuals
    % remain
    if totalZombies(dayLoop)+totalInf(dayLoop)==0 || totalHealthy(dayLoop)+totalInf(dayLoop)==0
        totalHealthy(dayLoop:end) = totalHealthy(dayLoop);
        totalZombies(dayLoop:end) = totalZombies(dayLoop);
        totalCorrectRemoval(dayLoop:end) = totalCorrectRemoval(dayLoop);
        totalIncorrectRemoval(dayLoop:end) = totalIncorrectRemoval(dayLoop);
        break;
    end

    %% During turn actions
    [popTable,correctRemoval,incorrectRemoval] =...
        duringTurnActions(popTable,correctRemoval,incorrectRemoval,dayLoop,numHouses);

    %% End of turn updates
    [popTable] = endOfTurn(popTable,numHouses);
end

%% Plot the final neighborhood and statistics

linewidth = 5;
fontsize = 16;

figure(); 
subplot(1,2,1); hold on;
plot(totalHealthy,'linewidth',linewidth)
plot(totalInf,'linewidth',linewidth)
plot(totalZombies,'linewidth',linewidth)
legend('Healthy','Infected','Zombie')
set(gca,'fontsize',fontsize)
xlabel('Days')
ylabel('Total Number')

subplot(1,2,2); hold on;
plot(totalCorrectRemoval,'linewidth',linewidth)
plot(totalIncorrectRemoval,'linewidth',linewidth)
legend('Correct Removal','Incorrect Removal')
set(gca,'fontsize',fontsize)
xlabel('Days')
ylabel('Total Number')


