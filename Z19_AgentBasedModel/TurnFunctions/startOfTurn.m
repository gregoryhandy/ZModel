function [popTable] = startOfTurn(popTable,dayNum,numHouses)

%% Loop through all houses
if dayNum<=2
    for h = 1:numHouses
        houseMembers = find(popTable.houseNum==h);

        % Build suspicion based on coughs (if no Zombies present)
        if isempty(find(popTable.healthStatus(houseMembers)==-1,1))
            for ii = 1:length(houseMembers)
                dieRoll = ceil(6*rand());
                if popTable.healthStatus(houseMembers(ii))==1 && dieRoll == 1
                    popTable.susLevel(houseMembers,houseMembers(ii)) = ...
                        popTable.susLevel(houseMembers,houseMembers(ii))+1;
                elseif popTable.healthStatus(houseMembers(ii))==0 && dieRoll <= 3
                    popTable.susLevel(houseMembers,houseMembers(ii)) = ...
                        popTable.susLevel(houseMembers,houseMembers(ii))+1;
                end
            end
        end
    end
elseif dayNum == 3
    numIndividuals = max(popTable.ID);
    popTable.susLevel = zeros(numIndividuals,numIndividuals);
end


end