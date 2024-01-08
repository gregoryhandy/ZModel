function [xLoc,yLoc] = getCoordinates(locNum, numHouses,numPeople)

if locNum <= numHouses
    theta = 2*pi/numHouses*(locNum-1)+2*pi/numHouses*rand(numPeople,1);
    r = 0.5+0.5*sqrt(rand(numPeople,1));

elseif locNum > numHouses
    theta = 2*pi*rand(numPeople,1);
    r = 0.5*sqrt(rand(numPeople,1));
end

xLoc = r.*cos(theta);
yLoc = r.*sin(theta);

end