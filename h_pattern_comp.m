function [out, beta] = h_pattern_comp(dat)

nCond = size(dat,1);
nRun = size(dat,3);
runs = 1:nRun;

%dat = d_sim(0.2,0,0,.5,'sigmaNoise',1);

%get contrast matrices
% m1a = pdist([...
%     1 1 1  -1 -1 -1  0 0 0; ...
%     0 0 0  1 1 1  -1 -1 -1]')';
% 
% m2 = pdist([...
%     1 -1 0  1 -1 0  1 -1 0; ...
%     0 1 -1  0 1 -1  0 1 -1]')';
% 
% intr = pdist([ ...
%     1 -1 0  -1 1 0  0 0 0;...
%     0 1 -1  0 -1 1  0 0 0;...
%     0 0 0  1 -1 0  -1 1 0;...
%     0 0 0  0 1 -1  0 -1 1]')';

c1 = [...
    1 1 1  -1 -1 -1  0 0 0; ...
    0 0 0  1 1 1  -1 -1 -1];

m1 = pdist(c1'*pinv(c1'))';

c2 = [...
    1 -1 0  1 -1 0  1 -1 0; ...
    0 1 -1  0 1 -1  0 1 -1];

m2 = pdist(c2'*pinv(c2'))';

c3 = [ ...
    1 -1 0  -1 1 0  0 0 0;...
    0 1 -1  0 -1 1  0 0 0;...
    0 0 0  1 -1 0  -1 1 0;...
    0 0 0  0 1 -1  0 -1 1];

intr = pdist(c3'*pinv(c3'))';


%% LDC (Cross-validated mehalonobis distance)

pairs = nchoosek(1:nCond,2);

%pre-allocate
p_dist = zeros(length(pairs),nRun);
cv_dist = zeros(1,length(pairs));

for p = 1:length(pairs);
    
    for r = runs
        
        train = runs(runs ~= r);                
        p_dist(p,r) = squeeze(mean(dat(pairs(p,1),:,train),3) - mean(dat(pairs(p,2),:,train),3)) * (dat(pairs(p,1),:,r) - dat(pairs(p,2),:,r))';
        
    end
    
    cv_dist(p) = mean(p_dist(p,:));
    
end

[out.b,out.se,out.pval,out.inmodel,out.stats] =  stepwisefit([m1,m2,intr],cv_dist','display','off');
beta = pinv([m1,m2,intr, ones(length(pairs), 1)]) * cv_dist';

end






