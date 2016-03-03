%--------------------------------------------------------------------------------------------------------
%% Simulate activities from a 3^2 factorial design with R replications
%Y: N by P observation matrix, specifying the signal at N different time points in P voxels
%Z: N by K design matrix, specifying K conditions at N different time points
%U: K by P true activity patterns, specifying the activity patterns at different condition K in P voxels
%Default setting: R=6, N=R*3^2=54, P=160, K=3+3+9=15 
%The CVMANOVA used searchlight methods and he set the number of voxels
%small because MANOVA/CVMANOVA requires N>P
%--------------------------------------------------------------------------------------------------------

function [ Y, Z, U ] = simulate(varargin)

%Initial setting
p = inputParser;
p.addOptional('sigmaS', 0.05, @isnumeric);
p.addOptional('sigmaT', 0.05, @isnumeric); 
p.addOptional('sigmaInt', 0.05, @isnumeric);
p.addOptional('sigmaRun', 0, @isnumeric);
p.addParameter('sigmaNoise', 1, @isnumeric);
p.addParameter('nVoxels', 160, @isnumeric); %P
p.addParameter('nRuns', 6, @isnumeric);  %R
p.addParameter('Cauchy', 0.01, @(a) 0 <= a & a <= 1);
p.parse(varargin{:});
params = p.Results;

%Set the design matrix
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

[N, K] = size(Z);

scales = ...
    [ones(3,1) .* params.sigmaS
     ones(3,1) .* params.sigmaT
     ones(9,1) .* params.sigmaInt
     ones(params.nRuns,1) .* params.sigmaRun];

%SIMULATE 
U = randn(K, params.nVoxels);
U = bsxfun(@times, scales, U);

if params.Cauchy
    noise = randn(N, params.nVoxels) * (1 - params.Cauchy) + trnd(1, N, params.nVoxels) * params.Cauchy;
else
    noise = randn(N, params.nVoxels);
end

Y = Z * U + noise * params.sigmaNoise;


function B = to_vec(A)

B = A(:);



