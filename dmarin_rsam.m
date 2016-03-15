function RSA = dmarin_rsam(Y)

%% CV Distances
Y = reshape(Y, [9, size(Y, 1)/9, size(Y, 2)]);
sz = size(Y);

Diff = bsxfun(@minus,  ...
    reshape(Y, [ 1 sz]), ...
    reshape(Y, [sz(1) 1 sz(2:3)]));

Prod = bsxfun(@times, ...
    reshape(Diff, [sz(1) sz(1:2) 1 sz(3)]), ...
    reshape(Diff, [sz(1) sz(1) 1 sz(2:3)]));

D = sum(Prod, 5);
D = reshape(D, [sz([1 1]), sz(2)^2]);
D = mean(D(:,:,ones(sz(2)) ~= eye(sz(2))), 3);

%% moment matrix

H = eye(size(D)) - ones(size(D)) / size(D, 1);
RSA = -H * D * H;




