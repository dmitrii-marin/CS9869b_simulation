%--------------------------------------------------------------------------------------------------------
%% Evaluating the power of the test
% Nsim: the number of simulations
% C: the constrast matrix
% f: the function computing the test statistic
%--------------------------------------------------------------------------------------------------------

function  tpower = TestPower(varargin)
    alpha = 0.05; %Set type I error
    
    %Initial setting
    p = inputParser;
    p.addOptional('sigmaS', 0.2, @isnumeric);
    p.addOptional('sigmaT', 0, @isnumeric); 
    p.addOptional('sigmaInt', 0, @isnumeric);
    p.addOptional('sigmaRun', 0, @isnumeric);
    p.addParameter('Nsim', 1000, @isnumeric);
    p.addParameter('C', [ 1  1  1 -1 -1 -1  0  0  0;1  1  1  0  0  0 -1 -1 -1]', @isnumeric);
    p.addParameter('f', @MANOVABrain);
    p.addParameter('sigmaNoise', 1, @isnumeric);
    p.addParameter('nVoxels', 20, @isnumeric); %P
    p.addParameter('nRuns', 6, @isnumeric);  %R
    p.parse(varargin{:});
    params = p.Results;
    
    tpower = zeros(1,params.Nsim);
    DistT_BLH = DistStats(1000,params.C,@params.f,params.sigmaNoise,params.nVoxels);
    
    for i = 1:params.Nsim
        Y = simulate(params.sigmaS,params.sigmaT,params.sigmaInt,params.sigmaRun,...
            'nVoxels', params.nVoxels,'sigmaNoise',params.sigmaNoise); %Generate the data under the alternative distribution
%       Y = simulate(0,0,0,0,...
%           'nVoxels', params.nVoxels,'sigmaNoise',1); %Generate the data under the null distribution
        T_BLH = params.f(Y,params.C);      
        tpower(i) = mean(DistT_BLH>T_BLH); %p-value       
    end
    
    tpower = mean(tpower<alpha);
end