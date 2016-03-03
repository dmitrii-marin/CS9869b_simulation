%--------------------------------------------------------------------------------------------------------
%% Function for finding the distribution with randomization techniques
% Nsim: the number of simulations
% C: the constrast matrix
% f: the function computing the test statistic
% sigmanoise: In fact, this parameter does not influence the distribution
% of the test statistic
% nVoxel: number of voxels
%--------------------------------------------------------------------------------------------------------

function EmpiricalDist = DistStats(Nsim,C,f,...
                                   sigmaNoise, nVoxels)
    EmpiricalDist = zeros(1,Nsim);
    
    for k = 1:Nsim
        Y= simulate(0,0,0,0,'nVoxels', nVoxels,'sigmaNoise',sigmaNoise); %Generate the data under the null distribution
        EmpiricalDist(k) = f(Y,C);
    end
    
end