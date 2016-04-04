function Score = dmarin_knn(Y, Z)
%%
Y = reshape(Y, [9, size(Y, 1)/9, size(Y, 2)]);
Sz = size(Y);
Z = reshape(Z, Sz(1:2));

Score = 0;
for runid=1:size(Y, 2)
        Train = Y(:,(1:size(Y,2)) ~= runid,:);
        Group = Z(:,(1:size(Y,2)) ~= runid);



    %     Machine = fitcknn(reshape(Train, [Sz(1)*(Sz(2)-1) Sz(3)]), Group(:), 'NumNeighbors', 5);
    %     [~, Scores] = predict(Machine, reshape(Y(:,runid,:), [Sz(1) Sz(3)]));
    %     Score = Score + sum(Scores(sub2ind(size(Scores), 1:9, Z(:,runid)')));



        Tr = reshape(Train, [Sz(1)*(Sz(2)-1) Sz(3)]);
        Test = reshape(Y(:,runid,:), [Sz(1) Sz(3)]);
        Idx = knnsearch(Tr, Test, 'K', 10);
        Classes = Group(Idx);
        Correct = bsxfun(@eq, Classes, Z(:, runid));
        Score = Score + sum(mean(Correct, 2));
    
end

Score = Score / Sz(1) / Sz(2);
