function dmarin_power_est(dataFile)

addpath ../UWO/Research

load(dataFile);

%% Power estimation

Power = nan(length(Levels), length(Levels), length(Levels), length(Hyp));
for S=1:length(Levels)
    for T=1:length(Levels)
        for Int=1:length(Levels)
            H1 = {S,T,Int};
            for W=1:length(Hyp)
                H0 = H1;
                H0{W} = 1;
                Pos = ceil(0.95*length(Sample{H0{:},W}));
                Power(H1{:},W) = mean(Sample{H1{:},W} >= Sample{H0{:},W}(Pos));
            end
        end
    end
end

%% Plot
Markers = {'' 'o' 'v' '^' 's' '*'};

for W=1:length(Hyp)
    figure(W);
    clf
    title(sprintf('Estimated distributions for regressor #%d', W));
    Legend = {};
    hold on
    L = [1 length(Levels)];
    for S=L
        for T=L
            for Int=L
                [y,x] = ksdensity(Sample{S,T,Int,W});
                C = [S,T,Int];
                plot(x,y, ['-' Markers{C(W)}]);
                Legend = [Legend sprintf('%d%d%d / Power=%g', (S), (T), (Int), Power(S,T,Int,W))];
            end
        end
    end
    hold off
    legend(Legend);
    
    pr(sprintf('%s_distributions_%d', dataFile, W));
end

%%

figure;
for i = 1:length(Levels)
    [y,x] = ksdensity(Sample{i,1,1,1});
    hold on
    plot(x, y);
    hold off
end