%--------------------------------------------------------------------------------------------------------
%% Function implementing MANOVA for testing the full model: 
%% the Intercept, main effects and the interaction.
%% When (N-g) < p, use first 95% principal component as the response
%% Ref: Allefeld(2014)
% Y: the data consist of N trials across P voxels
% T_Wilks: Cross-validated Bartlett¨CLawley¨CHotelling trace statistics (standardized pattern distinctness)
%--------------------------------------------------------------------------------------------------------
function CVT_BLH = myCVMANOVABrain(Y)
    [N,p] = size(Y);
    g = 9; %the number of conditions
    m = 6; %the number of runs
    
%     if (N-2*g) < p
% %         disp('-------------------------------------------');
% %         disp('N<=p, 90% Pricipal components are used!');
% %         disp('-------------------------------------------');
%         [COEFF,SCORE,latent] = princomp(Y,'econ');
%         latentProp = cumsum(latent)./sum(latent);
%         ncomp = find(latentProp>0.90);
%         ncomp = ncomp(1);
% %        ncomp = min([ncomp(1),N-g]);
%        Y = SCORE(:,1:ncomp);
%         [N,p] = size(Y);
%     end
    
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
  
   %Perform mfold cross validation
   if (N-2*g) < p
        regularization = 0.01;
   else
        regularization = 0;
   end
  
   mfold = m;
   XL  = repmat(Cond,m/mfold,1);
   XK = repmat(Cond, m-m/mfold, 1);   
   DL = zeros(mfold,4);
   fE = N - g;
   for L = 1:mfold
        YL = Y((m/mfold*9*(L-1)+1):(m/mfold*9*L),:);
        BhatL = pinv(XL)*YL;
        
        %Compute EL
        YK = Y;
        YK((m/mfold*9*(L-1)+1):(m/mfold*9*L),:) = [];
        BhatK = pinv(XK)*YK;
        RK = YK-XK*BhatK; %Residual matrix
        EL = C'*(RK'*RK)*C;    
        %EL =EL +eye(p)*trace(EL)*regularization/p; %Regularization 2
        EL = diag(diag(EL)); %Regularization 2
        
        %Compute HL
        for i = 1:4  
            A = Afull{i};
            TL = A*BhatL*C-D;
            TK = A*BhatK*C-D;
            Z = A/(XL'*XL)*A';
            HL = TK'/Z*TL;
            DL(L,i) = trace(HL/EL);
        end    
        
   end


%    CVT_BLH = ((m-1)*fE-p-1)/(m-1)/N*mean(DL);
  CVT_BLH = ((m-1)*fE-p-1)/(m-1)/N*mean(DL)/sqrt(p);
end