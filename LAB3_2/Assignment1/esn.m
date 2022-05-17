function x = esn(u, omega_in, Nh, rho, Nw, seed)
[Nu, steps] = size(u);
x = zeros(Nh,1);

W_in = initInputMatrix(Nu, omega_in, Nh, seed);
W_hat = initStateMatrix(Nh, rho, seed);

for t=1:steps
    x = cat(2, x, tanh(W_in * [u(:,t); ones(Nu,1)] + W_hat * x(:,end)));
end

% Discard the washout (plus the initial state)
x = x(:, Nw+1+1:end);

end

