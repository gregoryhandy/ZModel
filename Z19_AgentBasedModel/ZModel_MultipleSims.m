%%
% Runs multiple simulations of the Z-19 agent-based model
%
% Written by Gregory Handy
%%
clear; close all; %clc;

restoredefaultpath;
folder = fileparts(which('ZModel_MultipleSims.m'));
addpath(genpath(folder));
rmpath(folder);

%% Key parameters for all trials
numIndividuals = 25; % number of individuals in the simulation
numHouses = 5; % total number of households
numTraits = 5; % total number of triats assigned to individuals
maxDays = 1000; % max length of simulation
susThres = 1;
totalTrials = 500;

% Prallocate memory
corrNum = zeros(totalTrials,1);
incNum = zeros(totalTrials,1);
numSurvivors=zeros(totalTrials,1);
outcome = zeros(totalTrials,1);

%% Outer loop across all trials
for trialLoop = 1:totalTrials

    % Preallocate array for the population
    popData = zeros(numIndividuals,numTraits);
    % Create the individuals
    for ii = 1:numIndividuals
        popData(ii,:) =  createInd(ii,susThres);
    end
    % Convert the array to a table
    popTable = array2table(popData,'VariableNames',{'ID','healthStatus',...
        'hitPoints','infDays','susThres'});
    popTable.susLevel=zeros(numIndividuals,numIndividuals);

    %% Initialize the neighborhood

    popTable = initializeNeighborhood(popTable,numHouses);

    %% Initialize counters and preallocate memory for arrays
    incorrectRemoval = 0;
    correctRemoval = 0;

    totalHealthy = zeros(maxDays,1);
    totalInf = zeros(maxDays,1);
    totalZombies = zeros(maxDays,1);
    totalCorrectRemoval = zeros(maxDays,1);
    totalIncorrectRemoval = zeros(maxDays,1);

    %% Simulate days of the Z-19 outbreak
    for dayLoop = 1:maxDays
        
        %% Start of turn; build suspicion based on coughs if no Zombies present
        [popTable] = startOfTurn(popTable,dayLoop,numHouses);

        %% Get current statistics at the start of the turn
        totalHealthy(dayLoop) = sum(popTable.healthStatus==1);
        totalInf(dayLoop) = sum(popTable.healthStatus==0);
        totalZombies(dayLoop) = sum(popTable.healthStatus==-1);
        totalCorrectRemoval(dayLoop) = correctRemoval;
        totalIncorrectRemoval(dayLoop) = incorrectRemoval;
        
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

    % Store the simulation results
    if totalHealthy>0
        outcome(trialLoop) = 1;
    end
    numSurvivors(trialLoop) = totalHealthy(end);
    corrNum(trialLoop) = totalCorrectRemoval(end);
    incNum(trialLoop) = totalIncorrectRemoval(end);
end

%% Plot the results
fontsize = 30;

figure(1); 
subplot(1,2,1);
histogram(numSurvivors(numSurvivors>0))
set(gca,'fontsize',fontsize)
xlabel('Number of Survivors')
ylabel('Number of Trials')
subplot(1,2,2);
histogram(incNum)
set(gca,'fontsize',fontsize)
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




