function Score = dmarin_knn3(Y)
% Destroys main effects and tests for interaction
%%
Y = reshape(Y, [3, 3, size(Y, 1)/9, size(Y, 2)]);

Y = bsxfun(@minus, Y, mean(Y, 1));
Y = bsxfun(@minus, Y, mean(Y, 2));

Z = repmat(1:9, 1, size(Y, 3))';

Score  = dmarin_knn(reshape(Y, 9*size(Y, 3), size(Y, 4)), Z);


