%%
% Initial the neightborhood for the simulation
%   Assign house numbers for everyone
%   Choose one person to start out infected
%%
function [popTable] = initializeNeighborhood(popTable,numHouses)

numIndividuals = max(popTable.ID);

%% Assign initial house number randomly

individualsPerHouse = ceil(numIndividuals/numHouses);
houseTemp = repmat([1:numHouses],1,individualsPerHouse);
houseTemp = houseTemp(1:numIndividuals);
houseAssignment = houseTemp(randperm(numIndividuals));
popTable.houseNum = houseAssignment';
popTable.newHouseNum = popTable.houseNum;

%% Choose one person in each household to be infected and place them in the house

popTable.houseCoords = zeros(numIndividuals,2);

for h = 1:numHouses
    houseMembers = find(popTable.houseNum==h);
    selectedMem = houseMembers(randperm(length(houseMembers),1));
    popTable.healthStatus(selectedMem) = 0;

    [popTable.houseCoords(houseMembers,1),popTable.houseCoords(houseMembers,2)]...
        = getCoordinates(h, numHouses,5);
end

end

