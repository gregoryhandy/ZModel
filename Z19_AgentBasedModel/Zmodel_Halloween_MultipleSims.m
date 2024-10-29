%%
% Simulates the agent-based model with four populations (healthy, infected,
% Zombie, and restrained)
% 
% Runs ten trials of the simulation and then shows the results, 
% averaged over space, at each time point for the different trials
%
% Written by Gregory Handy
%%

clear; close all; clc;

rng(102); % no spread
% rng(106); % spread

Ntot = 1000;
numTrials = 10;
infectedStatusVec = zeros(Ntot,400,numTrials);

%%
probI = cumsum([0.05 0]); % these are cumulative probabilities 
% probZVec = [0.1 0.15];
probZVec = cumsum([0.2 0.1]);

for trialCount = 1:numTrials

    loopCount = 1;

    xLoc = rand(Ntot,1);
    yLoc = rand(Ntot,1);

    infectedStatus = zeros(Ntot,1);
    infectedStatus(1) = 1;
    totDist = zeros(Ntot,Ntot);

    while loopCount <= 400
        % Calculate the distance between all individuals
        for ii = 1:Ntot
            totDist(ii,:) = sqrt((xLoc(ii)-xLoc).^2 + (yLoc(ii)-yLoc).^2);
        end

        IIndices = find(infectedStatus==1);
        for ii = 1:length(IIndices)
            ITargets = find(totDist(IIndices(ii),:)>0 & totDist(IIndices(ii),:)<0.05 & ...
                infectedStatus' == 0);
            if ~isempty(ITargets)
                coinFlip = rand;
                if coinFlip<probI(1)
                    infectedStatus(ITargets(1)) = 1;
                elseif coinFlip<probI(2)
                    infectedStatus(IIndices(ii)) = 3;
                end
            end
        end

        ZIndices = find(infectedStatus==2);
        % See if a Z based on the infection
        for zz = 1:length(ZIndices)
            ZTargets = find(totDist(ZIndices(zz),:)>0 & totDist(ZIndices(zz),:)<0.05 & ...
                infectedStatus' == 0);
            if ~isempty(ZTargets)
                coinFlip = rand;

                if coinFlip<probZVec(1)
                    infectedStatus(ZTargets(1)) = 1;
                elseif coinFlip<probZVec(2)
                    infectedStatus(ZIndices(zz)) = 3;
                end
            end
        end

        for ii = 1:Ntot
            if infectedStatus(ii) ~= 3
                xLoc(ii) = xLoc(ii) + 0.01*randn();
                yLoc(ii) = yLoc(ii) + 0.01*randn();
                if xLoc(ii) < 0
                    xLoc(ii) = -xLoc(ii);
                elseif xLoc(ii) > 1
                    xLoc(ii) = 2-xLoc(ii);
                end

                if yLoc(ii) < 0
                    yLoc(ii) = -yLoc(ii);
                elseif yLoc(ii) > 1
                    yLoc(ii) = 2-yLoc(ii);
                end
            end
        end

        infectedStatusVec(:,loopCount,trialCount) = infectedStatus;
        loopCount = loopCount + 1;
        if isempty(ZIndices) & isempty(IIndices)
            break;
        else
            infectedStatus(IIndices(rand(length(IIndices),1) < 0.05)) = 2;
        end
    end
end

%%
healthy = zeros(400,trialCount);
infected = zeros(400,trialCount);
z = zeros(400,trialCount);
removed = zeros(400,trialCount);
for trialCount = 1:numTrials
    for tt = 1:size(infectedStatusVec,2)
        healthy(tt,trialCount) = sum(infectedStatusVec(:,tt,trialCount) == 0);
        infected(tt,trialCount) = sum(infectedStatusVec(:,tt,trialCount) == 1);
        z(tt,trialCount) = sum(infectedStatusVec(:,tt,trialCount) == 2);
        removed(tt,trialCount) = sum(infectedStatusVec(:,tt,trialCount) == 3);
    end
end
%%
colorScheme = get(gca,'colororder');

figure(1); clf; hold on;
for trialCount = 1:numTrials
    subplot(1,4,1); hold on;
    plot(healthy(:,trialCount),'linewidth',1.5,'Color',colorScheme(1,:))
    set(gca,'fontsize',16)
    ylabel('Number of Individuals')
    title('Susceptible')
    subplot(1,4,2); hold on;
    plot(infected(:,trialCount),'LineWidth',1.5,'Color',colorScheme(2,:))
    set(gca,'fontsize',16)
    title('Infected')
    subplot(1,4,3); hold on;
    plot(z(:,trialCount),'LineWidth',1.5,'Color',colorScheme(3,:))
    set(gca,'fontsize',16)
    title('Zombie')
    subplot(1,4,4); hold on;
    plot(removed(:,trialCount),'LineWidth',1.5,'Color','k')
    set(gca,'fontsize',16)
    title('Removed')
end


