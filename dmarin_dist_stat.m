function [ Sample ] = dmarin_dist_stat( NTrials, Fun, varargin )
%DMARIN_DIST_STAT Summary of this function goes here
%   Detailed explanation goes here
Sample = ones(1, NTrials);
for i = 1:NTrials
    
    Y = simulate(varargin{:});
    Sample(i) = Fun(Y);

end

