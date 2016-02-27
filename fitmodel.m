%% How you estimate U
[ Y, Z, U ]  = simulate(10,0,0,0,'sigmaNoise', 2);

%% the design matrix include the intercept term and the first level of each
%% factor as the baseline
%1 2 3 | 1 2 3 | 11 12 13 21 22 23 31 32 33
%1 2 3 | 4 5 6 | 7  8  9  10 11 12 13 14 15
%0| 2 3 | 5-4 6-4 | 11 12 14 15
Z = Z(:,[2 3 5 6 11 12 14 15]);
Z = [ones(54,1), Z]; 

%% Fit the model using OLS (Equivalent to fitting a model for each pixel)
Beta = (Z'*Z)\Z'*Y;
SSE = sum((Y-Z*Beta).^2);
SSR =  sum(Y.^2);
Rsquare = 1- SSE./SSR;
