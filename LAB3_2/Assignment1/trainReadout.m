function W_out = trainReadout(x, d, Nw, lambda_r)
% Discard the washout
d = d(:, Nw+1:end);

[dim, len] = size(x);
X = [x; ones(1, len)];

if lambda_r == 0
    W_out = d * pinv(X);
elseif lambda_r > 0
    W_out = d * X' * inv(X*X' + lambda_r * eye(dim+1));
end

end