%% Break point of MANOVA
Nrep = 1000; 
Nvoxel = 60;
ListpMANOVA = zeros(Nrep,Nvoxel,4);

%Takes time, you can load breakpoint.mat and skip the following codes
parfor NV= 1:Nvoxel
    for i = 1:Nrep    
        [ Y, Z0, U0 ]  = simulate(0,0,0,0,'sigmaNoise', 1,'nVoxels', NV);
        [T_Wilks,FT_Wilks,df1,df2,pF_Wilks] = myMANOVABrain(Y); 
        ListpMANOVA(i,NV,:) = pF_Wilks;
    end
end

significance = mean(ListpMANOVA<0.05,1);

%% Plot the significance
%load('breakpoint.mat')

hold on
plot(1:Nvoxel,significance(1,:,1),'b-')
plot(1:Nvoxel,significance(1,:,2),'c-')
plot(1:Nvoxel,significance(1,:,3),'g-')
plot(1:Nvoxel,significance(1,:,4),'r-')
xlabel('Number of Voxels')
ylabel('False Positives')
legend('Intercept','Spatial','Temporal','Interaction')
hold off

%Seems there is not a break point...
