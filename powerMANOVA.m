%% Power of different tests
Nvoxel = 160;
Nrep = 1000;
ListpMANOVA = zeros(Nrep,4);
% ListpCVMANOVA = zeros(Nrep,4);
%ListBootpMANOVA = zeros(Nrep,4);

parfor i = 1:Nrep    
    Y  = simulate(0,0,0,0,'sigmaNoise', 1,'nVoxels', Nvoxel);

    [T_Wilks,FT_Wilks,df1,df2,pF_Wilks] = myMANOVABrain(Y); %MANOVA   
    
%     CVT_BLH = myCVMANOVABrain(Y);	%CVMANOVA simulated from NULL
%     pCVT_BLH = mean(bsxfun(@ge,NullDist,CVT_BLH));  
%     
%     BootNullDist = BootdistCVMANOVA(Y,100);    %CVMANOVA using randomization
%     BootpCVT_BLH = mean(bsxfun(@ge,BootNullDist,CVT_BLH));  
    
    ListpMANOVA(i,:) = pF_Wilks;
%     ListpCVMANOVA(i,:) = pCVT_BLH;
%     ListBootpMANOVA(i,:) = BootpCVT_BLH;
end

mean(ListpMANOVA(:,2:4)<0.05)
% mean(ListpCVMANOVA(:,2:4)<0.05)
% mean(ListBootpMANOVA(:,2:4)<0.05)

%% Run this section to obtain the Null distribution first from the simulations from NULL
Nsim = 1000;
NullDist = distCVMANOVA(Nsim,0,0,0,0,...
                           'sigmaNoise', 1,'nVoxels', Nvoxel);


%% Power comparison
S = [0 0.15];
T = [0 0.15];
Int = [0 0.15];
Nvoxel = 160;
Nrep = 1000;
sample = zeros(Nrep,4,8);

for i = 1:Nrep    
    for s = 1:2
        for t = 1:2
            for int = 1:2
                Y  = simulate(S(s),T(t),Int(int),0,'sigmaNoise', 1,'nVoxels', Nvoxel);

                [~,FT_Wilks,~,~,~] = myMANOVABrain(Y); %MANOVA   
    
                sample(i,:,s*4+t*2+int-4-2) = FT_Wilks;
            end
        end
    end
end

hold on
[yi,xi] = ksdensity(sample(:,2,1));
plot(xi,yi);
[yi,xi] = ksdensity(sample(:,2,7));
plot(xi,yi);
hold off
            
            
figure
hold on 
    Legend = {};
for s = 1:2
    for t = 1:2
        for int = 1:2
            [yi,xi] = ksdensity(sample(:,3,s*4+t*2+int-4-2));
            plot(xi,yi);  
        %    Legend = [Legend sprintf('%d%d%d / Power=%g', (s-1), (t-1), (int-1), Power(S,T,Int,W))];
        end
    end
end
hold off

figure

hold on 
plot(xi,yi);
title('')

hold off

Markers = 'ov^s*';
 ['-' Markers(1)]
 Legend = [Legend sprintf('%d%d%d / Power=%g', (S), (T), (Int), Power(S,T,Int,W))];

