load sample 

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
    Legend = {};
    hold on
    L = [1 length(Levels)];
    for S=L
        for T=L
            for Int=L
                [y,x] = ksdensity(Sample{S,T,Int,W});
                plot(x,y, ['-' Markers(Int)]);
                Legend = [Legend sprintf('S=%g, T=%g, I=%g', Levels(S), Levels(T), Levels(Int))];
            end
        end
    end
    hold off
    legend(Legend);
end