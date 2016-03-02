%% Generate data
rng(193) %Set the random seed
%I choose nVoxels less than 54 because the MANOVA needs n>=p in order to estimate the covariance matrix
[ Y, Z0, U0 ]  = simulate(0.1,0,0,0,...
                           'sigmaNoise', 3,'nVoxels', 20); 


%% Use MANOVA to test contrasts
 CS = [ 1  1  1 -1 -1 -1  0  0  0;
        1  1  1  0  0  0 -1 -1 -1]'; %the contrast matrix for testing spatial patterns

 CT = [ 1 -1  0  1 -1  0  1 -1  0;
        1  0 -1  1  0 -1  1  0 -1]'; %the contrast matrix for testing temporal patterns

 CInt = [ 1 -1  0  -1  1  0  0  0  0
          0  1 -1   0 -1  1  0  0  0
          0  0  0   1 -1  0 -1  1  0
          0  0  0   0  1 -1  0 -1  1]'; %the contrast matrix for testing integrated patterns 
      
DistT_BLH1 = DistStats(1000,CS,@MANOVABrain,3,20); 
T_BLH1 = MANOVABrain(Y,CS);
mean(DistT_BLH1>T_BLH1) %p-value

DistT_BLH2 = DistStats(1000,CT,@MANOVABrain,3,20); 
T_BLH2 = MANOVABrain(Y,CT);      
mean(DistT_BLH2>T_BLH2) %p-value

DistT_BLH3 = DistStats(1000,CInt,@MANOVABrain,3,20); 
T_BLH3 = MANOVABrain(Y,CInt);      
mean(DistT_BLH3>T_BLH3) %p-value

figure
histogram(DistT_BLH1)
figure
histogram(DistT_BLH2)
figure
histogram(DistT_BLH3)

%% Estimate the G matrix (Second Moment Matrix)
G = Uhat*Uhat';
 
 
 %% Implement the cross-validated MANOVA