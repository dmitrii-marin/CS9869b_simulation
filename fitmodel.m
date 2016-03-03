%% Generate data
rng(193) %Set the random seed
%I choose nVoxels less than 54 because the MANOVA needs n>=p in order to estimate the covariance matrix
[ Y, Z0, U0 ]  = simulate(0.1,0,0,0,...
                           'sigmaNoise', 4,'nVoxels', 20); 


%% Use MANOVA to test contrasts
 CS = [ 1  1  1 -1 -1 -1  0  0  0;
        1  1  1  0  0  0 -1 -1 -1]'; %the contrast matrix for testing spatial patterns

 CT = [ 1 -1  0  1 -1  0  1 -1  0;
        1  0 -1  1  0 -1  1  0 -1]'; %the contrast matrix for testing temporal patterns

 CInt = [ 1 -1  0  -1  1  0  0  0  0
          0  1 -1   0 -1  1  0  0  0
          0  0  0   1 -1  0 -1  1  0
          0  0  0   0  1 -1  0 -1  1]'; %the contrast matrix for testing integrated patterns 

%Use randomization methods to obtain the p-values
DistT_BLH1 = DistStats(1000,CS,@MANOVABrain,1,20); 
T_BLH1 = MANOVABrain(Y,CS);
mean(DistT_BLH1>T_BLH1) %p-value

DistT_BLH2 = DistStats(1000,CT,@MANOVABrain,1,20); 
T_BLH2 = MANOVABrain(Y,CT);      
mean(DistT_BLH2>T_BLH2) %p-value

DistT_BLH3 = DistStats(1000,CInt,@MANOVABrain,1,20); 
T_BLH3 = MANOVABrain(Y,CInt);      
mean(DistT_BLH3>T_BLH3) %p-value

figure
histogram(DistT_BLH1)
figure
histogram(DistT_BLH2)
figure
histogram(DistT_BLH3)

%% Implement the cross-validated MANOVA

%Use randomization methods to obtain the p-values
DistCVT_BLH1 = DistStats(1000,CS,@CVMANOVABrain,1,20); 
% median(DistCVT_BLH1)
% 1.4826*mad(DistCVT_BLH1,1)
CVT_BLH1 = CVMANOVABrain(Y,CS);
mean(DistCVT_BLH1>CVT_BLH1) %p-value

DistCVT_BLH2 = DistStats(1000,CT,@CVMANOVABrain,1,20); 
CVT_BLH2 = CVMANOVABrain(Y,CT);      
mean(DistCVT_BLH2>CVT_BLH2) %p-value

DistCVT_BLH3 = DistStats(1000,CInt,@CVMANOVABrain,1,20); 
CVT_BLH3 = CVMANOVABrain(Y,CInt);      
mean(DistCVT_BLH3>CVT_BLH3) %p-value

figure
histogram(DistCVT_BLH1)
figure
histogram(DistCVT_BLH2)
figure
histogram(DistCVT_BLH3)


%Test power given type I error alpha=0.05
%Testing H0:random noise v.s. H1:Spatial patterns
P1 = TestPower(1,0,0,0,...
               'Nsim',1000,'C',CS,'f',@MANOVABrain,'sigmaNoise', 4,'nVoxels', 20); 

P2 = TestPower(1,0,0,0,...
               'Nsim',1000,'C',CS,'f',@CVMANOVABrain,'sigmaNoise', 4,'nVoxels', 20); 
