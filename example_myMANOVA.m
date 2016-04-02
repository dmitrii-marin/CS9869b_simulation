%% Example of the simple MANOVA
%Only the interaction
[ Y, Z0, U0 ]  = simulate(0,0.3,0,0,...
                           'sigmaNoise', 1,'nVoxels', 46); 


[T_Wilks,FT_Wilks,df1,df2,pF_Wilks] = myMANOVABrain(Y)

%% False positive rate or Power
Nrep = 1000;
ListpF_Wilks = zeros(Nrep,4);
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
%                            'sigmaNoise', 1,'nVoxels', 30); 

    [T_Wilks,FT_Wilks,df1,df2,pF_Wilks] = myMANOVABrain(Y);
    ListpF_Wilks(i,:) = pF_Wilks;
end

% figure
% histogram(ListpF_Wilks(:,1))
% title('Intercept')

figure
histogram(ListpF_Wilks(:,2))
title('Spatial')

figure
histogram(ListpF_Wilks(:,3))
title('Temporal')

figure
histogram(ListpF_Wilks(:,4))
title('Interaction')

mean(ListpF_Wilks(:,2:4)<0.05)

close all



