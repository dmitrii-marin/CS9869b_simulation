clear all; close all

%% show examples

figure(1); clf;
p = { 'S', 'T', 'Int' };

B0 = [0 0 0];
B1 = [1 1 1];
B2 = [1 -1 0];

Cont3 = [];
for i=[1 1 2; 2 3 3]
    for j=[1 1 2; 2 3 3]
        tmp = zeros(1, 9);
        tmp([i(1) + j(2)*3 - 3, i(2) + j(1)*3 - 3]) = 1;
        tmp([i(1) + j(1)*3 - 3, i(2) + j(2)*3 - 3]) = 1;
        Cont3 = [Cont3; tmp];
    end
end

Cont = { [B1 -B1 B0; B0 B1 -B1], [B2 B2 B2; 0 B2 B2 1 -1], Cont3 };
for i = 1:length(p)
    subplot(4,4,i+1);
    [Y,X]=simulate('Cauchy',0,['sigma' p{i}],1); 
    RSA{i} = dmarin_rsam(Y);
    imagesc(RSA{i}); 
%     colorbar
    title(['\sigma_{' p{i} '} = 1']);
    axis square
    axis off
    Color(i,:) = caxis;
    
    
    C = Cont{i};
    Hyp{i} = C'*pinv(C');
end
impixelinfo;

X = cell2mat(cellfun(@(A) A(:), Hyp, 'UniformOutput', false));
X = [X ones(size(X, 1), 1)];
Z = inv(X'*X)*X';

for i = 1:length(p)
   
    subplot(4,4,i*4+1);
    imagesc(reshape(Z(i,:), 9,9));
%     colorbar;
    title(p{i});
    axis square
    axis off
end
impixelinfo;

cscale = [min(Color(:, 1)) max(Color(:, 2))];

for i=1:3
    subplot(4,4,i+1);
    caxis(cscale);
end

for i=1:3
    for j=1:3
        subplot(4,4, 1 + i + j*4);
        text(0,0,sprintf('%g', Z(i,:)*RSA{j}(:)), 'HorizontalAlignment','center');
        xlim([-1 1]);
        ylim([-1 1]);
        axis off
    end
end

drawnow;

%% H0
Trials = 1000;

Levels = [0 0.05 0.1 0.15];
[Ss,Ts,Ints] = ndgrid(1:length(Levels), 1:length(Levels), 1:length(Levels));
Sample = {};
B = tic;
parfor i=1:numel(Ss)
    S = Ss(i);
    T = Ts(i);
    Int = Ints(i);
    SampleW = {};
    for W = 1:length(Hyp)
        fprintf('Simulating (S=%g, T=%g, I=%g, W=%g)', Levels([S, T, Int]), W);
        A = tic;
        SampleW{W} = dmarin_dist_stat(Trials, @(Y) dmarin_rsa(Y, Z(W,:)), Levels(S), Levels(T), Levels(Int), 'Cauchy', 0);
        fprintf(' took %g s.\n', toc(A));
        SampleW{W} = sort(SampleW{W});
    end
    Sample = [Sample; SampleW];
end
fprintf('Total simulation time is %g s\n', toc(B));

Sample = reshape(Sample, [length(Levels), length(Levels), length(Levels), length(Hyp)]);

save sample Sample Levels Hyp Z
