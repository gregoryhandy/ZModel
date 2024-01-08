%%
% Create an individual/"agent" for the model with five traits
%   ID: identification number
%   healthStatus: 
%       1 = healthy, 0 = infected, -1 = zombie, -10 = removed 
%%
function [ind] = createInd(ID,susThres)

% ID, healthStatus, hitPoints, infDays, susThres
ind = [ID 1 1 0 susThres];

end