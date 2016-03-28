function out = h_test_pattern(pattern, nRep)
%% Simulate pattern component model
% sim: signal for each factor [main1 main2 interaction]
% nRep: number of simulations

rng('default');

%% data param
nCond = 9;
nRun = 6;
nVx = 160;

%% set contrast matrix
c1 = [... %main effect 1
    1 1 1  -1 -1 -1  0 0 0; ...
    0 0 0  1 1 1  -1 -1 -1];
m1 = c1'*pinv(c1');

c2 = [... %main effect 2
    1 -1 0  1 -1 0  1 -1 0; ...
    0 1 -1  0 1 -1  0 1 -1];
m2 = c2'*pinv(c2');

intr = eye(9);%interaction

conMx = [m1(:), m2(:), intr(:), ones(nCond^2,1)]; %combine into contrast matrix

%% pre-allocate
[beta, beta_noise, beta_perm] = deal(zeros(nRep, size(conMx,2)));


%% Get noise-only null
disp('calculating noise-only null')
tic;

parfor i = 1:nRep

    dat = simulate(0,0,0,'sigmaNoise',1,'Cauchy', 0,'nVoxels', nVx);
    dat = permute(reshape(dat, [nCond,nRun,nVx]), [1, 3, 2]); %make into [nCond, nVx, nRun]

    beta_noise(i,:) = h_pattern_comp(dat,conMx);

end

out.beta_noise = beta_noise;
toc

%% Get permutation null
disp('calculating permutation null & pattern component fit')
tic;

parfor i = 1:nRep
    
    dat_perm = zeros(nCond,nVx,nRun);

    dat = simulate(pattern(1),pattern(2),pattern(3),'sigmaNoise',1,'Cauchy', 0,'nVoxels', nVx);
    dat = permute(reshape(dat, [nCond,nRun,nVx]), [1, 3, 2]); %make into [nCond, nVx, nRun]

    for r = 1:nRun
        dat_perm(:,:,r) = dat(randperm(nCond),:,r);
    end

    beta_perm(i,:) = h_pattern_comp(dat_perm,conMx);
    beta(i,:) = h_pattern_comp(dat,conMx);

end

out.beta_perm = beta_perm;
out.beta = beta;
toc

%H0 rejection using noise [out.power(1,:)] and perm
%[out.power(2,:)] null. one-way test.

for b = 1:size(beta,2)
    out.h1(1,b) = mean(beta(:,b) > prctile(beta_noise(:,b),95));
    out.h1(2,b) = mean(beta(:,b) > prctile(beta_perm(:,b),95));
end

%% Run classification simulations
disp('calculating classification fit')
tic;

nMain = 3; %levels of each main effect
pair = nchoosek(1:nMain,2);
nPair = length(pair);

totPair = nchoosek(1:nCond,2); %total pairwise comparisons
ntPair = length(totPair);

for i = 1:nRep
    
    dat = simulate(pattern(1),pattern(2),pattern(3),'sigmaNoise',1,'Cauchy', 0);
    dat = permute(reshape(dat, [nMain,nMain,nRun,nVx]), [2, 1, 4, 3]); %make into [main1, main2, nVx, nRun]
    
    
    %% main 1  test
    
    for p = 1:nPair; %which levels of main 1 to classify
        
        for c = 1:nMain; %which levels of main 2 to collapse over during training

            trainDat = squeeze(mean(dat(pair(p,:), [1:nMain] ~= c, :, :),2));
            testDat = squeeze(dat(pair(p,:), c, :, :));
            
            acc(p,c) = h_classify(trainDat, testDat); %should be able to replace with k-nn 
            
        end
    end
    
    m1Class(i) = mean(acc(:));
    
    
    %% main 2 test
    
    for p = 1:nPair; %which levels of main 2 to classify
        
        for c = 1:nMain; %which levels of main 1 to collapse over during training
                   
            trainDat = squeeze(mean(dat([1:nMain] ~= c, pair(p,:), :, :),1));
            testDat = squeeze(dat(c,pair(p,:), :, :));
            
            acc(p,c) = h_classify(trainDat, testDat); %should be able to replace with k-nn 
            
        end
    end
    
    m2Class(i) = mean(acc(:));
    
    
    %% Interaction test
        
    tempDat = dat;
    for r = 1:nMain %remove row patterns
        tempDat(r,:,:,:) = bsxfun(@minus,tempDat(r,:,:,:),mean(dat(r,:,:,:),2));
    end
    
    for a = 1:nMain %remove column patterns
        tempDat(:,a,:,:) = bsxfun(@minus,tempDat(:,a,:,:),mean(dat(:,a,:,:),1));
    end    
    
    iDat = reshape(tempDat,[nCond,nVx,nRun]);
    
    for p = 1:ntPair
        iAcc(p) = h_classify(iDat(totPair(p,:),:,:),iDat(totPair(p,:),:,:));
    end
    
    iClass(i) = mean(iAcc);
    
end

out.m1Class = m1Class;
out.m2Class = m2Class;
out.iClass = iClass;


toc



end
