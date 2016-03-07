function [pred, beta, out] = h_test_pattern(nBoot)

nCond = 9;
nRun = 6;
nVx = 160;

out = cell(1,nBoot);
model = zeros(nBoot,3);
beta = zeros(nBoot,3);

for i = 1:nBoot
    
    dat = d_sim(.05,0,0,0,'sigmaNoise',1,'Cauchy', 0);
    dat = permute(reshape(dat, [nCond,nRun,nVx]), [1, 3, 2]);
    
    [out{i},bet] = h_pattern_comp(dat);
    model(i,:) = out{i}.inmodel;    
    beta(i,:) = bet(1:3,:);
    
end

pred = mean(model);



end