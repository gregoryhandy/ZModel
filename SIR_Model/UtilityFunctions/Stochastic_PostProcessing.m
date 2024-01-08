%%
% Cleans up the data from the stochastic simulations so that they all have
% the same time vector
%%
function [TVec,IAll,SAll] = Stochastic_PostProcessing(TAllTemp,maxT,IAllTemp,SAllTemp)

numTrials = size(IAllTemp,2);

% Preallocate memory
TVec = [0:0.01:maxT];
IAll = zeros(length(TVec),numTrials);
SAll = zeros(length(TVec),numTrials);

% Loop through all trials
for ii = 1:numTrials
    TAllTemp{ii}(end+1) = maxT+1;

    IAllTemp{ii}(end+1) = 0;
    IAll(:,ii) = interp1(TAllTemp{ii},IAllTemp{ii},TVec);

    SAllTemp{ii}(end+1) = SAllTemp{ii}(end);
    SAll(:,ii) = interp1(TAllTemp{ii},SAllTemp{ii},TVec);
end

end