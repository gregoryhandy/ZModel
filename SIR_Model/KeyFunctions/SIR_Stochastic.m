%%
% Runs the stochastic SIR model using the Gillespie algorithm (not
% discussed during workshop, but it speeds up the simulations)
%%
function [INum,SNum,TVec] = SIR_Stochastic(NTot,pInf,beta,nu)

INum = []; SNum = []; TVec = [];

% Initial conditions
INum(1) = round(pInf*NTot);
SNum(1) = NTot-INum;
TVec(1) = 0;
tt = 1;

% Loop through time until no infected individuals remain
while INum(tt) >= 1
    
    % Calculate the current rates of the system
    I_rate = beta*SNum(tt)*INum(tt)/NTot;
    R_rate = nu*INum(tt);
    
    % flip coins
    anyEventCoin = rand(); 
    eventCoin = rand();
    
    % Calculate the time to the next event
    tJump = 1/(I_rate+R_rate)*log(1/anyEventCoin);
    TVec(tt+1) = TVec(tt) + tJump;
    
    % Choose which event occurred based on the relative rates
    if eventCoin<I_rate/(I_rate+R_rate)
        SNum(tt+1) = SNum(tt) - 1;
        INum(tt+1) = INum(tt) + 1;
    else
        SNum(tt+1) = SNum(tt);
        INum(tt+1) = INum(tt) - 1;
    end
    
    tt = tt + 1;
end

end