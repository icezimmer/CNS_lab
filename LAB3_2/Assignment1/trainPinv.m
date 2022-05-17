function W_out = trainPinv(x, d, Nw)

d = d(:, Nw+1:end);

[~, len] = size(x);
W_out = d * pinv([x; ones(1, len)]);
end

