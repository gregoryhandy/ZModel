%%
% Simulates the start of turn events
%   Updates health status
%   Build suspicion
%%
function [popTable] = startOfTurn(popTable,dayNum,numHouses)

%% Update health status

% Update infection length
popTable.infDays(popTable.healthStatus == 0) = ...
    popTable.infDays(popTable.healthStatus == 0) + 1;

% Update zombie status depending on infection length
popTable.healthStatus(popTable.infDays == 3) = -1;
popTable.hitPoints(popTable.infDays == 3) = 2;
popTable.infDays(popTable.infDays == 3) = inf;

%% Loop through all houses

% After day 2, chaos reigns, preventing one from building suspicion
if dayNum<=2
    for h = 1:numHouses+1
        houseMembers = find(popTable.houseNum==h);

        % Build suspicion based on coughs (if no zombies present)
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