function [beta] = h_pattern_comp(dat, conMx)
%% take data and contrast matrix, retun betas


%% Set Params
%dat = d_sim(0.2,0,0,.5,'sigmaNoise',1);
nCond = size(dat,1);
nRun = size(dat,3);
runs = 1:nRun;
pairs = nchoosek(1:size(dat,1),2);
nPair = size(pairs,1);

%% pre-allocate
p_dist = ones(nPair, nRun);

%% LDC (Cross-validated mehalonobis distance)
for p = 1:nPair;
    
    for r = runs
        
        train = runs(runs ~= r);
        p_dist(p,r) = diff([mean(dat(pairs(p,1),:,train),3); mean(dat(pairs(p,2),:,train),3)]) * diff(dat(pairs(p,:),:,r))';
        
    end
    
end

%% Calc 2nd moment matrix
h = eye(nCond)-ones(nCond)/nCond; %centering matrix
G = -.5 * h * squareform(mean(p_dist,2)) * h'; %get second moment matrix

%% Calc betas
beta = pinv(conMx) * G(:); %Calc betas for contrast matrix

end
