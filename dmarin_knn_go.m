clear all; close all

addpath ../UWO/Research/

%% show examples

figure(1); clf;
p = { 'S', 'T', 'Int' };

Cont = { repmat(1:3, 3, 1) repmat((1:3)', 1, 3) 1:9 };
for i = 1:length(p)+1
    subplot(4,5,i+1);
    Signal = { 0, 0, 0 };
    if i<4, Signal{i} = 1; end
    [Y,X]=simulate(Signal{:},'Cauchy',0); 
    Data{i} = Y;
    imagesc(Y); 
%     colorbar
    if i<4
        title(['\sigma_{' p{i} '} = 1']);
    else
        title('Null');
    end
%     axis square
    axis off
    Color(i,:) = caxis;
end
impixelinfo;

for i = 1:length(p)
   
    subplot(4,5,i*5+1);
    imagesc(reshape(Cont{i}, 3,3));
%     colorbar;
    title(p{i});
    axis square
    axis off
end
impixelinfo;

cscale = [min(Color(:, 1)) max(Color(:, 2))];

for i=1:3
    subplot(4,5,i+1);
    caxis(cscale);
end

Z = repmat(1:9, 1, 6)';

for i=1:4
    for j=1:3
        subplot(4,5, 1 + i + j*5);
        text(0,0,sprintf('%g', dmarin_knn(Data{i}, Cont{j}(Z))), 'HorizontalAlignment','center');
        xlim([-1 1]);
        ylim([-1 1]);
        axis off
    end
end

drawnow;

pr knn_examples

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
    for W = 1:length(Cont)
        fprintf('Simulating (S=%g, T=%g, I=%g, W=%g)', Levels([S, T, Int]), W);
        A = tic;
        SampleW{W} = dmarin_dist_stat(Trials, @(Y) dmarin_knn(Y, Cont{W}(Z)), Levels(S), Levels(T), Levels(Int), 'Cauchy', 0);
        fprintf(' took %g s.\n', toc(A));
        SampleW{W} = sort(SampleW{W});
    end
    Sample = [Sample; SampleW];
end
fprintf('Total simulation time is %g s\n', toc(B));

Sample = reshape(Sample, [length(Levels), length(Levels), length(Levels), length(Cont)]);

Hyp = Cont;
save sample_knn Sample Levels Z Hyp

%% H0
Trials = 1000;

Levels = [0 0.05 0.1 0.15];
[Ss,Ts,Ints] = ndgrid(1:length(Levels), 1:length(Levels), 1:length(Levels));
Sample = {};
B = tic;

Cont = { @(Y) dmarin_knn2(Y, false), @(Y) dmarin_knn2(Y, true), @dmarin_knn3 };

parfor i=1:numel(Ss)
    S = Ss(i);
    T = Ts(i);
    Int = Ints(i);
    SampleW = {};
    for W = 1:length(Cont)
        fprintf('Simulating (S=%g, T=%g, I=%g, W=%g)', Levels([S, T, Int]), W);
        A = tic;
        Fun = Cont{W};
        SampleW{W} = dmarin_dist_stat(Trials, Fun, Levels(S), Levels(T), Levels(Int), 'Cauchy', 0);
        fprintf(' took %g s.\n', toc(A));
        SampleW{W} = sort(SampleW{W});
    end
    Sample = [Sample; SampleW];
end
fprintf('Total simulation time is %g s\n', toc(B));

Sample = reshape(Sample, [length(Levels), length(Levels), length(Levels), length(Cont)]);

Hyp = Cont;
save sample_knn2 Sample Levels Z Hyp
