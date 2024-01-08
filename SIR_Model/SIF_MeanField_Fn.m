function [IVec,SVec,tVec] = SIF_MeanField_Fn(NTot,pInf,beta,nu)

% Set up the time vector
dt = 0.01;
tVec = [0:dt:2000];

% Preallocate memory
SVec = zeros(length(tVec),1);
IVec = zeros(length(tVec),1);
RVec = zeros(length(tVec),1);


% Initial conditions 
IVec(1) = pInf;
SVec(1) = (1-IVec(1));

% Loop over time
for tt = 1:length(tVec)-1
    SVec(tt+1) = SVec(tt) + dt*(-beta*SVec(tt)*IVec(tt));
    IVec(tt+1) = IVec(tt) + dt*(beta*SVec(tt)*IVec(tt)-nu*IVec(tt));
end

end