%% Power of different tests
Nvoxel = 160;
Nrep = 100;
ListpMANOVA = zeros(Nrep,4);
ListpCVMANOVA = zeros(Nrep,4);
ListBootpMANOVA = zeros(Nrep,4);
for i = 1:Nrep    
    [ Y, Z0, U0 ]  = simulate(0,0,0.3,0,'sigmaNoise', 1,'nVoxels', Nvoxel);

    CVT_BLH = myCVMANOVABrain(Y);	%MANOVA    
    [T_Wilks,FT_Wilks,df1,df2,pF_Wilks] = myMANOVABrain(Y); 
    
    pCVT_BLH = mean(bsxfun(@ge,NullDist,CVT_BLH));  %CVMANOVA simulated from NULL
    
    BootNullDist = BootdistCVMANOVA(Y,100);    %CVMANOVA using randomization
    BootpCVT_BLH = mean(bsxfun(@ge,BootNullDist,CVT_BLH));  
    
    ListpMANOVA(i,:) = pF_Wilks;
    ListpCVMANOVA(i,:) = pCVT_BLH;
    ListBootpMANOVA(i,:) = BootpCVT_BLH;
end

mean(ListpMANOVA(:,2:4)<0.05)
mean(ListpCVMANOVA(:,2:4)<0.05)
mean(ListBootpMANOVA(:,2:4)<0.05)

%% Run this section to obtain the Null distribution first from the simulations from NULL
Nsim = 1000;
NullDist = distCVMANOVA(Nsim,0,0,0,0,...
                           'sigmaNoise', 1,'nVoxels', Nvoxel);


