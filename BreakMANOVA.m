%% Break point of the simple MANOVA
Nrep = 1000; 
Nvoxel = 45;
ListpMANOVA = zeros(Nrep,Nvoxel,4);

%Takes time, you can load breakpoint.mat and skip the following codes
parfor NV= 1:Nvoxel
    for i = 1:Nrep    
        [ Y, Z0, U0 ]  = simulate(0,0,0,0,'sigmaNoise', 1,'nVoxels', NV);
        %[ Y, Z0, U0 ]  = simulate(0.15,0.15,0.15,0,'sigmaNoise', 1,'nVoxels', NV);
        [T_Wilks,FT_Wilks,df1,df2,pF_Wilks] = myMANOVABrain(Y); 
        ListpMANOVA(i,NV,:) = pF_Wilks;
    end
end

significance = mean(ListpMANOVA<0.05,1);

%% Plot the significance
Nvoxel = 45;
load('breakpoint.mat')
figure
hold on
plot(1:Nvoxel,significance(1,:,2),'c-')
plot(1:Nvoxel,significance(1,:,3),'g-')
plot(1:Nvoxel,significance(1,:,4),'r-')
xlabel('The Number of Used Voxels')
ylabel('False Positive Rates')
legend({'Spatial','Temporal','Interaction'},...
    'Location','northeast','Orientation','horizontal','FontSize',10)
% annotation('textbox',[0.2 0.5 0.3 0.3],'String','No PCA','FitBoxToText','on');
% annotation('textbox',[0.55 0.5 0.3 0.3],'String','With PCA','FitBoxToText','on');
%Add reference lines
xRef=get(gca,'xlim');
plot(xRef,[0.05 0.05], 'k--')
title('False Positive Rate under random noises, sigmaNoise=1')
hold off

%Seems there is not a break point...

%% Plot the Power
Nvoxel = 45;
load('power.mat')
figure
hold on
plot(1:Nvoxel,significance(1,:,2),'c-')
plot(1:Nvoxel,significance(1,:,3),'g-')
plot(1:Nvoxel,significance(1,:,4),'r-')
xlabel('The Number of Used Voxels')
ylabel('Power')
legend({'Spatial','Temporal','Interaction'},...
    'Location','northeast','Orientation','horizontal','FontSize',10)
% annotation('textbox',[0.2 0.5 0.3 0.3],'String','No PCA','FitBoxToText','on');
% annotation('textbox',[0.55 0.5 0.3 0.3],'String','With PCA','FitBoxToText','on');
%Add reference lines
xRef=get(gca,'xlim');
plot(xRef,[0.05 0.05], 'k--')
title('Power under the signal(0.15,0.15,0.15), sigmaNoise=1')
hold off


%% PCA reinforces the power of the test
Nrep = 1000; 
Nvoxel = 45;
ListpMANOVA = zeros(Nrep,Nvoxel,4);
Nvariation = zeros(Nrep,Nvoxel);

%Takes time, you can load breakpoint2.mat and skip the following codes
for i = 1:Nrep
    %[ Y, Z0, U0 ]  = simulate(0,0,0,0,'sigmaNoise', 1,'nVoxels', 160);
    [ Y, Z0, U0 ]  = simulate(0.15,0.15,0.15,0,'sigmaNoise', 1,'nVoxels', 160);
    [U,S,V] = svd(Y,0);
    condenseY = U*S;
    Variation = diag(S);
    totalVariation = sum(Variation);
    for j = 1:Nvoxel
        condenseYj = condenseY(:,1:j);
        Nvariation(i,j) = sum(Variation(1:j))/totalVariation;
        [T_Wilks,FT_Wilks,df1,df2,pF_Wilks] = myMANOVABrain(condenseYj);
        ListpMANOVA(i,j,:) = pF_Wilks;
    end
end

significance = mean(ListpMANOVA<0.05,1);
Meanvariation = mean(Nvariation);

%% Plot the explained variation as a function of the number of components
Nvoxel = 45;
figure
hold on
load('variation.mat')
plot(1:Nvoxel,Meanvariation,'c-')
load('variation2.mat')
plot(1:Nvoxel,Meanvariation,'r-')
legend({'Random Noise','All Signals'},...
    'Location','northwest','Orientation','horizontal','FontSize',9)
xlabel('Number of principal components')
ylabel('Explained Variation')
title('The Explained Variation Overlap')
hold off

%% Plot the significance
Nvoxel = 45;
load('breakpoint2.mat')
figure
hold on
plot(1:Nvoxel,significance(1,:,2),'c-')
plot(1:Nvoxel,significance(1,:,3),'g-')
plot(1:Nvoxel,significance(1,:,4),'r-')
xlabel('Number of principal components')
ylabel('False Positives')
legend({'Spatial','Temporal','Interaction'},...
    'Location','northeast','Orientation','horizontal','FontSize',10)
% annotation('textbox',[0.2 0.5 0.3 0.3],'String','No PCA','FitBoxToText','on');
% annotation('textbox',[0.55 0.5 0.3 0.3],'String','With PCA','FitBoxToText','on');
%Add reference lines
xRef=get(gca,'xlim');
plot(xRef,[0.05 0.05], 'k--')
title('False Positive Rate under random noises, sigmaNoise=1')
hold off

%Seems there is not a break point...

%% Plot the Power
Nvoxel = 45;
load('power2.mat')
figure
hold on
plot(1:Nvoxel,significance(1,:,2),'c-')
plot(1:Nvoxel,significance(1,:,3),'g-')
plot(1:Nvoxel,significance(1,:,4),'r-')
xlabel('Number of principal components')
ylabel('Power')
legend({'Spatial','Temporal','Interaction'},...
    'Location','northeast','Orientation','horizontal','FontSize',10)
% annotation('textbox',[0.2 0.5 0.3 0.3],'String','No PCA','FitBoxToText','on');
% annotation('textbox',[0.55 0.5 0.3 0.3],'String','With PCA','FitBoxToText','on');
%Add reference lines
xRef=get(gca,'xlim');
plot(xRef,[0.05 0.05], 'k--')
title('Power under the signal(0.15,0.15,0.15), sigmaNoise=1')
hold off
