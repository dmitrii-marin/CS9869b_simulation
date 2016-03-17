function [p, stats, beta] = h_test_pattern(sim,nBoot)
%% Simulate pattern component model


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

conMx = [m1(:), m2(:), intr(:)]; %combine into contrast matrix

%% pre-allocate
beta = zeros(nBoot, size(conMx,2));

%% Run simulations
for i = 1:nBoot
    
    dat = simulate(sim(1),sim(2),sim(3),'sigmaNoise',1,'Cauchy', 0);
    dat = permute(reshape(dat, [nCond,nRun,nVx]), [1, 3, 2]);
    
    beta(i,:) = h_pattern_comp(dat,conMx);   
    
end

%% return p and stats
[~,p,~,stats] = ttest(beta,0);

end
