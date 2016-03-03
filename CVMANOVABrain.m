%--------------------------------------------------------------------------------------------------------
%% Function implementing cross validated MANOVA
% Y: the data consist of N trials across P voxels
% C: the constrast matrix
%--------------------------------------------------------------------------------------------------------
function CVT_BLH = CVMANOVABrain(Y,C)
    [n,p] = size(Y);
    m = 6; %#runs
    ZL = eye(9);
    ZK = repmat(eye(9), m-1, 1);  
    Z = repmat(eye(9), m, 1);  %The design matrix includes 9 patterns for 6 runs
    fE = n - 9;
    DL = zeros(1,m);
    
    %Perform leave one run cross validation
    for L = 1:m
        YL = Y((9*L-8):(9*L),:);
        UhatL = (ZL'*ZL)\ZL'*YL;
        BdeltaL = C* ((C'*C)\C') *UhatL;
        
        YK = Y;
        YK((9*L-8):(9*L),:) = [];
        UhatK = (ZK'*ZK)\ZK'*YK;
        BdeltaK = C* ((C'*C)\C') *UhatK;
      
        ResidK = YK-ZK*UhatK; %Residual matrix
        EL = ResidK'*ResidK;
        HL = BdeltaK'*(ZL'*ZL)*BdeltaL;
 %       HL = BdeltaK'*(Z'*Z)*BdeltaL;
        DL(L) = trace(HL/EL);
    end
    
    CVT_BLH = ((m-1)*fE-p-1)/(m-1)/n*mean(DL);
end