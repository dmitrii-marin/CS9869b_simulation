function acc = h_classify(trainDat, testDat)

nRun = size(trainDat,3); % Runs (trainDat == testDat)
nCond = size (trainDat,1); % Conditions (trainDat == testDat)
runs = 1:nRun;
conds = 1:nCond;

for n = runs %for each run
    
    Mu_hat = mean(trainDat(:,:,runs ~= n),3); % training means
    
    for c = conds %for each condition
        
        x = testDat(c,:,runs == n); % test pattern
        dist = x*x'-2*Mu_hat*x' + sum(Mu_hat.^2,2);
        [~, k(c,n)] = min(dist); % Record the classification
        
    end
end

% Caluclate the % correct
correct=bsxfun(@eq, k, conds');
acc = sum(correct(:))/numel(correct(:));