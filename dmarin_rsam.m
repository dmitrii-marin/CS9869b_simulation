function RSA = dmarin_rsam(Y)

G = Y*Y';
I = reshape(1:9*9, 9, 9);
Ind = repmat(I, 6) - blkdiag(I,I,I,I,I,I);
RSA = reshape(accumarray(Ind(Ind>0), G(Ind>0)), 9, 9) / 6;


