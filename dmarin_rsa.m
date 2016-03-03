function [ Score ] = dmarin_rsa( Y, H )

A = dmarin_rsam(Y);
Score = A(:)' * H(:);

end

