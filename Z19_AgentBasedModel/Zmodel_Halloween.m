%%
% Simulates the agent-based model with four populations (healthy, infected,
% Zombie, and restrained)
%
% Shows the result at each time point
%
% Written by Gregory Handy
%%
clear; close all; clc;

% rng(102); % no spread;
rng(108); 
% rng(106);

Ntot = 1000;
xLoc = rand(Ntot,1);
yLoc = rand(Ntot,1);

infectedStatus = zeros(Ntot,1);
infectedStatus(1) = 1; 
totDist = zeros(Ntot,Ntot);

defaultMarkerSize = 30;
infMarkerSize = 20;
lineWidth = 3;

f = figure(1); f.Position = [390   185   969   770]; clf; hold on; 
plot(xLoc,yLoc,'.','MarkerSize',defaultMarkerSize)
plot(xLoc(infectedStatus==1),yLoc(infectedStatus==1),'*',...
    'linewidth',lineWidth,'MarkerSize',infMarkerSize,'color',[0.85 0.325 0.098]);
plot(1+[0 0],[0 1],'k-','LineWidth',1.5)
plot([0 0],[0 1],'k-','LineWidth',1.5)
plot([0 1],1+[0 0],'k-','LineWidth',1.5)
plot([0 1],[0 0],'k-','LineWidth',1.5)
axis square
axis off

%%

totalTime = 200;
probI = cumsum([0.05 0]); % these should be cumulative probabilities 
probZVec = cumsum([0.2 0.1]);
for tt = 1:totalTime
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

    figure(1); f.Position = [390   185   969   770];
    clf; hold on;
    plot(xLoc(infectedStatus==0),yLoc(infectedStatus==0),'.','MarkerSize',defaultMarkerSize)
    plot(xLoc(infectedStatus==1),yLoc(infectedStatus==1),'*',...
        'linewidth',lineWidth,'MarkerSize',infMarkerSize,'color',[0.85 0.325 0.098])
    plot(xLoc(infectedStatus==2),yLoc(infectedStatus==2),'*',...
        'linewidth',lineWidth,'MarkerSize',infMarkerSize,'color',[0.929 0.694 0.125]);
    plot(xLoc(infectedStatus==3),yLoc(infectedStatus==3),'x',...
        'linewidth',lineWidth+1,'MarkerSize',infMarkerSize,'color','k')
    axis([0 1 0 1])
    plot(1+[0 0],[0 1],'k-','LineWidth',1.5)
    plot([0 0],[0 1],'k-','LineWidth',1.5)
    plot([0 1],1+[0 0],'k-','LineWidth',1.5)
    plot([0 1],[0 0],'k-','LineWidth',1.5)
    axis square
    axis off
    pause(0.1)

    if isempty(ZIndices) & isempty(IIndices)
        break;
    else
        infectedStatus(IIndices(rand(length(IIndices),1) < 0.05)) = 2;
    end
end