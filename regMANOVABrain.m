%--------------------------------------------------------------------------------------------------------
%% Function implementing regularized MANOVA
% Y: the data consist of N trials across P voxels
% C: the constrast matrix
%--------------------------------------------------------------------------------------------------------
function T_BLH = regMANOVABrain(Y,C)
    %The design matrix includes 9 patterns for 6 runs
    [n,p] = size(Y);
    Z = repmat(eye(9), 6, 1); 
    regularization = 0.05;
    
    %Fit the model using OLS (Equivalent to fitting a model for each pixel)
    Uhat = (Z'*Z)\Z'*Y;
    
    %Compute the Bartlett-lawley-Hotelling trace
    Bdelta = C* ((C'*C)\C') *Uhat;
    H = Bdelta'*(Z'*Z)*Bdelta;
    Resid = Y-Z*Uhat; %Residual matrix
    E = Resid'*Resid;
    %E = diag(diag(E)); %Regularization 1
    E =E +eye(p)*trace(E)*regularization/p; %Regularization 2
    T_BLH = trace(H/E);
end