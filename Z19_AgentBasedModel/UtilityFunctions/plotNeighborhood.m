function plotNeighborhood(popTable,figNum,numHouses)

% Plot the neighborhood
thetaVec = [0:0.01:2*pi];
figure(figNum); clf; hold on;
plot(popTable.houseCoords(popTable.healthStatus==1,1),popTable.houseCoords(popTable.healthStatus==1,2),...
    'k*','markersize',16,'linewidth',2)
plot(popTable.houseCoords(popTable.healthStatus==0,1),popTable.houseCoords(popTable.healthStatus==0,2),...
    'g*','markersize',16,'linewidth',2)

plot(popTable.houseCoords(popTable.healthStatus==-1,1),popTable.houseCoords(popTable.healthStatus==-1,2),...
    'r*','markersize',16,'linewidth',2)

% house boundaries
thetaVec = [0:0.01:2*pi]; 
plot(cos(thetaVec),sin(thetaVec),'k','linewidth',1.5)
plot(0.5*cos(thetaVec),0.5*sin(thetaVec),'k','linewidth',1.5)

rVec = [0.5:0.01:1];
for ii = 1:numHouses
    thetaVec = [0+2*pi/numHouses*(ii-1):0.01:2*pi/numHouses*ii];  
    plot(rVec*cos(thetaVec(1)),rVec*sin(thetaVec(1)),'k','linewidth',1.5)
end
axis off
axis square

end