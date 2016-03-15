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
H1 = 1;
fprintf('Simulating H0...');
A = tic;
Sample0 = dmarin_dist_stat(Trials, @(Y) dmarin_rsa(Y, Hyp{H1}), 0, 0, 0, 'Cauchy', 0);
fprintf(' took %g s.\n', toc(A));

%% Estimate 5% critival value

figure(2);
[f0,xi0] = ksdensity(Sample0);
h = plot(xi0, f0);
set(h, 'LineWidth', 2);
[v,i] = max(f0);
% text(xi0(i), v, 'H0', 'Color', get(h, 'Color'), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
title('Estimated distributions [noise/power]');

Sample0 = sort(Sample0);
CValue5 = Sample0(ceil(0.95 * length(Sample0)));
line([CValue5 CValue5],get(gca,'YLim'),'Color', 'r')
% text(CValue5, get(gca,'YLim')*[0.1; 0.9], sprintf(' Critical\n value'));


Leg = { 'H0', 'Critical value' };
legend(Leg);

drawnow;
%% Estimate H1

for noise=[0.05 0.1 0.15]

fprintf('Simulating H1...');
A = tic;
Params = {0, 0, 0};
Params{H1} = noise;
Sample1 = dmarin_dist_stat(Trials, @(Y) dmarin_rsa(Y, Hyp{H1}), Params{:}, 'Cauchy', 0);
fprintf(' took %g s.\n', toc(A));

%% Estimate power

[f1,xi1] = ksdensity(Sample1);
hold on
h = plot(xi1, f1);
hold off

Power = nnz(Sample1 >= CValue5) / numel(Sample1);
% [v,i] = max(f1);
% text(xi1(i), v, sprintf('%g/%.2f', noise, Power), 'Color', get(h, 'Color'), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');


%%
Leg = [Leg sprintf('%g/%.2f', noise, Power)];
legend(Leg);
drawnow;
end
