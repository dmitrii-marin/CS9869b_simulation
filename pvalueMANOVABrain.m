%--------------------------------------------------------------------------------------------------------
%% Function implementing MANOVA in Allefeld(2014)
% Y: the data consist of N trials across P voxels
% C: the constrast matrix
%--------------------------------------------------------------------------------------------------------
function pFT_Wilks = pvalueMANOVABrain(FT_Wilks,Y,C)
    [N, p] = size(Y);
    g = size(C);
    g = g(1);

    v1 = p;
    v2 = N-g-p+1;
    pFT_Wilks = fcdf(FT_Wilks,v1,v2,'upper');
end