%% How you run simulate

%% How to set sigmaS, sigmaT, sigmaInt and sigmaRun
figure(1);
subplot(2, 2, 1);
Y = simulate(1000,0,0,0);
imagesc(Y); 
axis image
title('sigmaS');

subplot(2, 2, 2);
Y = simulate(0,1000,0,0);
imagesc(Y);
axis image
title('sigmaT');

subplot(2, 2, 3);
Y = simulate(0,0,1000,0);
imagesc(Y);
axis image
title('sigmaInt');

subplot(2, 2, 4);
Y = simulate(0,0,0,1000);
imagesc(Y);
axis image
title('sigmaRun');

%% How to ser parameters, e.g. sigmaNoise
figure(2);
Y = simulate('sigmaNoise', 1000, 'Cauchy', 0); % use large normal noise (do not include heavy tailed noise)
imagesc(Y);
colorbar
