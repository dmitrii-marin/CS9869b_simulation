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
Markers = 'ov^s*';

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
                plot(x,y, ['-' Markers(C(W))]);
                Legend = [Legend sprintf('%d%d%d / Power=%g', (S), (T), (Int), Power(S,T,Int,W))];
            end
        end
    end
    hold off
    legend(Legend);
    
    drawnow;
    
    pr(sprintf('%s_distributions_%d', dataFile, W));
end

%%

for j=1:length(Hyp)

    figure(length(Hyp) + j);
    clf;
    Legend = {};
    Top = 0;
    C = {1,1,1,j};
    for i = 1:length(Levels)
        C{j} = i;
        [y,x] = ksdensity(Sample{C{:}});
        hold on
        plot(x, y);
        Top = max([Top; y(:)]);
        hold off
        Legend = [Legend sprintf('%.2f/%.2f', Levels(i), Power(C{:}))];
    end
    C{j} = 1;
    CV = Sample{C{:}}(ceil(0.95*length(Sample{C{:}})));
    line([CV CV], [0 Top], 'Color', 'r');
    legend([Legend 'critical value 5%']);
    title(sprintf('Power of Methods w.r.t. SNR [SNR/power]\nRegressor #%d', j));
    
end