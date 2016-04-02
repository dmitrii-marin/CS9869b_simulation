%% Distribution of CVMANOVA for the full model (under NULL)
function EmpiricalDist=distMANOVA(Nsim,varargin)
    p = inputParser;
    p.addOptional('sigmaS', 0, @isnumeric);
    p.addOptional('sigmaT', 0, @isnumeric); 
    p.addOptional('sigmaInt', 0, @isnumeric);
    p.addOptional('sigmaRun', 0, @isnumeric);
    p.addParameter('sigmaNoise', 1, @isnumeric);
    p.addParameter('nVoxels', 160, @isnumeric); %P
    p.addParameter('nRuns', 6, @isnumeric);  %R
    p.parse(varargin{:});
    params = p.Results;
    
    EmpiricalDist = zeros(Nsim,4);
    
    for i = 1:Nsim
        Y = simulate(params); %Generate the data under the given distribution
        [U,S,V] = svd(Y,0);
        condenseY = U*S;
        condenseY = condenseY(:,1:28); %Use the first 28 components
        [~,F_Wilks,~,~,~]  =  myMANOVABrain(condenseY);
        EmpiricalDist(i,:) = F_Wilks;
    end
end


