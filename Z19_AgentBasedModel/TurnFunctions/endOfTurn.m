function [popTable] = endOfTurn(popTable,numHouses)

    % remove individuals
    removedIndividuals = find(popTable.healthStatus == -10);
    popTable.houseNum(removedIndividuals) = -10;
    popTable.newHouseNum(removedIndividuals) = -10;

    % update location
    moved = find(popTable.houseNum-popTable.newHouseNum);
    popTable.houseNum(moved) = popTable.newHouseNum(moved);
    for ii = 1:length(moved)
        [popTable.houseCoords(moved(ii),1),popTable.houseCoords(moved(ii),2)]...
            = getCoordinates(popTable.houseNum(moved(ii)),numHouses,1);
    end

    % Update infection status
    popTable.infDays(popTable.healthStatus == 0) = ...
        popTable.infDays(popTable.healthStatus == 0) + 1;
    popTable.healthStatus(popTable.infDays == 3) = -1;
    popTable.hitPoints(popTable.infDays == 3) = 2;
    popTable.infDays(popTable.infDays == 3) = inf;

    

end