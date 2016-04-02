Nsim = 1000;
Levels = [0 0.05 0.1 0.15];
Hyp = { @myCVMANOVABrain, @myCVMANOVABrain, @myCVMANOVABrain };

[Ss,Ts,Ints] = ndgrid(1:length(Levels), 1:length(Levels), 1:length(Levels));
SampleMANOVA = cell(length(Levels), length(Levels), length(Levels), length(Hyp));
SampleCVMANOVA = cell(length(Levels), length(Levels), length(Levels), length(Hyp));

B = tic;

for i=1:numel(Ss)
    S = Ss(i);
    T = Ts(i);
    Int = Ints(i);
    %fprintf('Simulating (S=%g, T=%g, I=%g)\n', Levels([S, T, Int]));
    
    %MANOVA
    SampleW = distMANOVA(Nsim,Levels(S), Levels(T), Levels(Int),0,...
        'sigmaNoise', 1,'nVoxels', 160);
    SampleMANOVA(S,T,Int,1) = {sort(SampleW(:,2))}; %Spatial
    SampleMANOVA(S,T,Int,2) = {sort(SampleW(:,3))}; %Temporal
    SampleMANOVA(S,T,Int,3) = {sort(SampleW(:,4))}; %Interaction
    
    %CVMANOVA
    SampleW = distCVMANOVA(Nsim,Levels(S), Levels(T), Levels(Int),0,...
        'sigmaNoise', 1,'nVoxels', 160);
    SampleCVMANOVA(S,T,Int,1) = {sort(SampleW(:,2))}; %Spatial
    SampleCVMANOVA(S,T,Int,2) = {sort(SampleW(:,3))}; %Temporal
    SampleCVMANOVA(S,T,Int,3) = {sort(SampleW(:,4))}; %Interaction
end
fprintf('Total simulation time is %g s\n', toc(B)); %1537.64 s

Sample = SampleMANOVA;
save exampleMANOVA Sample Levels Hyp
Sample = SampleCVMANOVA;
save exampleCVMANOVA Sample Levels Hyp

dmarin_power_est exampleMANOVA
dmarin_power_est exampleCVMANOVA

close all
