function W_out = trainRidgeReg(x, d, Nw, lambda_r)
% Discard the washout
d = d(:, Nw+1:end);

[dim, len] = size(x);
X = [x; ones(1, len)];

W_out = d * X' * inv(X*X' + lambda_r * eye(dim+1));
end

