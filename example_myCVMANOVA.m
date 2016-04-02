%% Example of the simple CVMANOVA
%Only the interaction
[ Y, Z0, U0 ]  = simulate(0,0.3,0,0,...
                           'sigmaNoise', 1,'nVoxels', 150); 
CVT_BLH = myCVMANOVABrain(Y)

[T_Wilks,FT_Wilks,df1,df2,pF_Wilks] = myMANOVABrain(Y);
pF_Wilks
CVT_BLH = myCVMANOVABrain(Y);
pCVT_BLH = mean(bsxfun(@ge,NullDist,CVT_BLH)) %Run the section below first
BootpCVT_BLH = mean(bsxfun(@ge,BootNullDist,CVT_BLH)) %Run the section below first

%% False positive rate or Power
Nrep = 1000;
ListpCVT_BLH = zeros(Nrep,4);
for i = 1:Nrep
    %False positive rate
%     [ Y, Z0, U0 ]  = simulate(0,0,0,0,...
%                            'sigmaNoise', 1,'nVoxels', 40); 
%     [ Y, Z0, U0 ]  = simulate(0,0,0,0,...
%                            'sigmaNoise', 1,'nVoxels', 160); 
    %Power
    [ Y, Z0, U0 ]  = simulate(0,0,0.4,0,...
                           'sigmaNoise', 1,'nVoxels', 160);
%     [ Y, Z0, U0 ]  = simulate(0,0,0.5,0,...
%                            'sigmaNoise', 1,'nVoxels', 40); 

    CVT_BLH = myCVMANOVABrain(Y);
    pCVT_BLH = mean(bsxfun(@ge,NullDist,CVT_BLH)); %Run the section below first
    ListpCVT_BLH(i,:) = pCVT_BLH;
end

mean(ListpCVT_BLH(:,2:4)<0.05)

%% Run this section to obtain the Null distribution first from the simulations from NULL
Nsim = 1000;
NullDist = distCVMANOVA(Nsim,0,0,0,0,...
                           'sigmaNoise', 1,'nVoxels', 30);
   
%  median(NullDist(:,3))
%  1.4826*mad(NullDist(:,3))     

%% Visualize the distribution
figure
histogram(NullDist(:,1))
title('Intercept')

figure
histogram(NullDist(:,2))
title('Spatial')

figure
histogram(NullDist(:,3))
title('Temporal')

figure
histogram(NullDist(:,4))
title('Interaction')

close all

%% Run this section to obtain the Null distribution first from using Permutation
Nsim = 1000;
BootNullDist = BootdistCVMANOVA(Y,Nsim);
   
%  median(NullDist(:,3))
%  1.4826*mad(NullDist(:,3))     

