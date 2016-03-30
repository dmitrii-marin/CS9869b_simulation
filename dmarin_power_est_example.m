
Levels = [1 2 3];
Hyp = { @std, @mean };

[Ss,Ts,Ints] = ndgrid(1:length(Levels), 1:length(Levels), 1:length(Levels));
Sample = {};

B = tic;

for i=1:numel(Ss)
    S = Ss(i);
    T = Ts(i);
    Int = Ints(i);
    SampleW = {};
    for W = 1:length(Hyp)
        fprintf('Simulating (S=%g, T=%g, I=%g, W=%g)\n', Levels([S, T, Int]), W);
        Fun = Hyp{W};
        SampleW{W} = nan(1000, 1);
        for j=1:1000
            SampleW{W}(j) = Fun(randn(5, 1) * Levels(S) + Levels(T) + S*T);
        end
        SampleW{W} = sort(SampleW{W});
    end
    Sample = [Sample; SampleW];
end
fprintf('Total simulation time is %g s\n', toc(B));

Sample = reshape(Sample, [length(Levels), length(Levels), length(Levels), length(Hyp)]);
save example Sample Levels Hyp
dmarin_power_est example