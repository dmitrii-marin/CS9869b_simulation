%--------------------------------------------------------------------------------------------------------
%% Function implementing MANOVA for testing the full model: 
%% the Intercept, main effects and the interaction.
%% When (N-g) < p, use first 95% principal component as the response
%% Ref: Krzanowski, W. J. (1988) Principles of Multivariate Analysis. A User's Perspective. Oxford.
% Y: the data consist of N trials across P voxels
% T_Wilks: Wilk's Lambda statistics
% F_Wilks: F ratio converted by Wilk's Lambda statistics with df1,df2,and the pvalue pF_Wilks
%--------------------------------------------------------------------------------------------------------
function [T_Wilks,F_Wilks,df1,df2,pF_Wilks] = myMANOVABrain(Y)
    [N,p] = size(Y);
    g = 9; %the number of conditions
    if (N-g) < p
%         disp('-------------------------------------------');
%         disp('N<=p, 95% Pricipal components are used!');
%         disp('-------------------------------------------');
        [COEFF,SCORE,latent] = princomp(Y,'econ');
        latentProp = cumsum(latent)./sum(latent);
        ncomp = find(latentProp>0.95);
        ncomp = ncomp(1);
%        ncomp = min([ncomp(1),N-g]);
       Y = SCORE(:,1:ncomp);
        [N,p] = size(Y);
    end
    
    Afull = eye(g); %Hypothesis matrix within subjects
    Afull = {Afull(1,:); Afull(2:3,:) ;Afull(4:5,:) ;Afull(6:9,:)};
    C = eye(p); %%Hypothesis matrix between subjects
 %   C = (diag(ones(1,p-1),-1));
 %   C = [diag(ones(1,p-1));zeros(1,p-1)]-C(:,1:(p-1));
    D = 0;
    %Set the design matrix
    Cond = [1  1  0   1  0 
            1  1  0   0  1 
            1  1  0  -1 -1 
            1  0  1   1  0
            1  0  1   0  1
            1  0  1  -1 -1 
            1 -1 -1   1  0
            1 -1 -1   0  1
            1 -1 -1  -1 -1];
    %Add the interaction    
    Cond = [Cond Cond(:,2).*Cond(:,4) Cond(:,2).*Cond(:,5) Cond(:,3).*Cond(:,4) Cond(:,3).*Cond(:,5)];
             
    X  = repmat(Cond, 6, 1);

    %Fit the model using OLS (Equivalent to fitting a model for each pixel)
%    Bhat = (X'*X)\X'*Y;
    Bhat = pinv(X)*Y;
    R = Y-X*Bhat; %Residual matrix
    E = C'*(R'*R)*C;
    
    T_Wilks = zeros(1,3);
    F_Wilks = zeros(1,3);
    pF_Wilks = zeros(1,3);
    df1 = zeros(1,3);
    df2 = zeros(1,3);

    %Compute the Wilk's Lambda
    for i = 1:4
        A = Afull{i};
        T = A*Bhat*C-D;
        Z = A/(X'*X)*A';
        H = T'/Z*T;
        T_Wilks(i) = det(E)/det(H+E);
        
        q = rank(A);
        tmp1 = N-g-0.5*(p-q+1);
        tmp2 = (p*q-2)/4;
        tmp3 = p^2 + q^2 - 5;
        if tmp3 >0 
            tmp3 = sqrt(((p * q)^2 - 4)/tmp3);
        else
            tmp3 = 1;
        end
        
        df1(i) = p * q;
        df2(i) = tmp1 * tmp3 - 2 * tmp2;
        F_Wilks(i) = (T_Wilks(i)^(-1/tmp3) - 1) * df2 / df1;
        pF_Wilks(i) = fcdf(F_Wilks(i),df1(i),df2(i),'upper');
    end
    
end