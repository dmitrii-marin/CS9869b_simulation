function [ Y, U ] = simulate(varargin)
%SIMULATE 

p = inputParser;
p.addOptional('sigmaS', 0.05, @isnumeric);
p.addOptional('sigmaT', 0.05, @isnumeric); 
p.addOptional('sigmaInt', 0.05, @isnumeric);
p.addOptional('sigmaRun', 0.2, @isnumeric);
p.addParameter('sigmaNoise', 1, @isnumeric);
p.addParameter('nVoxels', 160, @isinteger);
p.addParameter('nRuns', 6, @isinteger);
p.addParameter('Cauchy', 0.01, @(a) 0 <= a & a <= 1);
p.parse(varargin{:});
params = p.Results;

Cond = [1 0 0   1 0 0
        1 0 0   0 1 0
        1 0 0   0 0 1
        0 1 0   1 0 0
        0 1 0   0 1 0
        0 1 0   0 0 1
        0 0 1   1 0 0
        0 0 1   0 1 0
        0 0 1   0 0 1];

Inter = eye(9);

Runs = reshape(repmat(to_vec(eye(params.nRuns))', 9, 1), params.nRuns * 9, params.nRuns);
Z = [repmat([Cond Inter], params.nRuns, 1) Runs];

[N, Q] = size(Z);

scales = ...
    [ones(3,1) .* params.sigmaS
     ones(3,1) .* params.sigmaT
     ones(9,1) .* params.sigmaInt
     ones(params.nRuns,1) .* params.sigmaRun];

U = randn(Q, params.nVoxels);
U = bsxfun(@times, scales, U);

if params.Cauchy
    noise = randn(N, params.nVoxels) * (1 - params.Cauchy) + trnd(1, N, params.nVoxels) * params.Cauchy;
else
    noise = randn(N, params.nVoxels);
end

Y = Z * U + noise * params.sigmaNoise;


function B = to_vec(A)

B = A(:);



