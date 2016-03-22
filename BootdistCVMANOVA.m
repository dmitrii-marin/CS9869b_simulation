%% Use permutation to find the distribution of CVMANOVA for the full model (under NULL)
function EmpiricalDist=BootdistCVMANOVA(Y,Nsim)
    EmpiricalDist = zeros(Nsim,4);
    N = size(Y,1);    

    for i = 1:Nsim
        Yi = datasample(Y,N,'Replace',false); %Resample from the original data
        EmpiricalDist(i,:) = myCVMANOVABrain(Yi);
    end
end


