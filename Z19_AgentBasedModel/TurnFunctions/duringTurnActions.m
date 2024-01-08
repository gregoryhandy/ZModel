function [popTable,correctRemoval,incorrectRemoval] =...
    duringTurnActions(popTable,correctRemoval,incorrectRemoval,dayNum,numHouses)

% Loop through all houses and the outside
for h = 1:numHouses+1

    % Find Zombie house members
    houseZombies = find(popTable.houseNum==h & popTable.healthStatus==-1);

    % Find non-Zombie house members
    houseMembers = find(popTable.houseNum==h & popTable.healthStatus>=0);

    % Zombies attack first
    if ~isempty(houseZombies) && ~isempty(houseMembers)
        for zz = 1:length(houseZombies)
            dieRoll = ceil(6*rand());
            if dieRoll == 6 % successful attack
                zTarget = houseMembers(randperm(length(houseMembers),1));
                popTable.healthStatus(zTarget) = 0;
            end
        end
    elseif isempty(houseMembers)
        for zz = 1:length(houseZombies)
            if h <=numHouses % must go outside
                popTable.newHouseNum(houseZombies(zz)) = numHouses+ 1;
            else % might stay outside
                popTable.newHouseNum(houseZombies(zz)) = randperm(numHouses+1,1);
            end
        end
    end

    % Loop through all non-Zombie members in the current household
    for ii = 1:length(houseMembers)
        currID = houseMembers(ii);

        if popTable.healthStatus(currID) ~= -10 % Check to make sure house member is still around
            houseSus = houseMembers(houseMembers~=currID);
            
            % Remove no longer viable house members
            houseSus = houseSus(popTable.healthStatus(houseSus)~=-10 & ...
                popTable.newHouseNum(houseSus)-popTable.houseNum(houseSus)== 0);
            % Remove recently eliminated Zombies
            houseZombies = houseZombies(popTable.healthStatus(houseZombies)~=-10 & ...
                popTable.newHouseNum(houseZombies)-popTable.houseNum(houseZombies)== 0);

            if isempty(houseZombies) & dayNum >=3 % move location
                
                if h <=numHouses % must go outside
                    popTable.newHouseNum(currID) = numHouses+ 1;
                else
                    popTable.newHouseNum(currID) = randperm(numHouses,1);
                end

            elseif sum(popTable.healthStatus(houseZombies)==-1)>=1 % attack zombie

                dieRoll = ceil(6*rand());
                if dieRoll>=4 % successful attack
                    zombieTarget = houseZombies(randperm(length(houseZombies),1));
                    popTable.hitPoints(zombieTarget) = popTable.hitPoints(zombieTarget)-1;
                    
                    if popTable.hitPoints(zombieTarget) == 0
                        correctRemoval = correctRemoval + 1;
                        popTable.healthStatus(zombieTarget) = -10;
                    end

                    dieRoll2 = ceil(6*rand());
                    if dieRoll2 == 1 % infected
                        popTable.healthStatus(currID) = 0;
                    end
                else
                    dieRoll2 = ceil(6*rand());
                    if dieRoll2 <= 2 % infected
                        popTable.healthStatus(currID) = 0;
                    end
                end

            elseif max(popTable.susLevel(currID,houseSus))>=popTable.susThres(currID) % attack one suspect
                
                currSuspects = houseSus(popTable.susLevel(currID,houseSus)>=popTable.susThres(currID));
                target = currSuspects(randperm(length(currSuspects),1));

                dieRoll = ceil(6*rand());
                if dieRoll>=2 % successful attack
                    popTable.hitPoints(target) = popTable.hitPoints(target) - 1;
                    if popTable.hitPoints(target) == 0
                        if popTable.healthStatus(target) <= 0
                            correctRemoval = correctRemoval + 1;
                        else
                            incorrectRemoval = incorrectRemoval + 1;
                        end
                        popTable.healthStatus(target) = -10;
                    end
                end
            end
        end
    end
end


end