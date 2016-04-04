function Score = dmarin_knn2(Y, Transpose)
% Uses double cross validation
%%
Y = reshape(Y, [3, 3, size(Y, 1)/9, size(Y, 2)]);
Sz = size(Y);
Z = repmat([1 2 3], [3 1 Sz(3)]);
if Transpose
    Y = permute(Y, [2 1 3 4]);
%     Z = permute(Z, [2 1 3]);
end

Score = [];
for runid=1:size(Y, 2)
    for XVal = 1:3
        DoubleXVal = (1:3) ~= XVal;
        Train = Y(DoubleXVal, :, (1:Sz(3)) ~= runid,:);
        Group = Z(DoubleXVal, :, (1:Sz(3)) ~= runid);
        

        Tr = reshape(Train, [2*3*(Sz(3)-1) Sz(4)]);
        Test = reshape(Y(XVal,:,runid,:), [3 Sz(4)]);
        Idx = knnsearch(Tr, Test, 'K', 5);
        Classes = Group(Idx);
        Correct = bsxfun(@eq, Classes, Z(XVal, :, runid)');
        Score = [Score; mean(Correct, 2)];
    end
end

Score = mean(Score);
