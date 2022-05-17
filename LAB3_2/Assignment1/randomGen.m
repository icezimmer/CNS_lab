function [omega_in, Nh, rho, Nw, lambda_r] = randomGen(o, hs, r, ws, lr, seed)

rng(seed)

% Random generation of the hyperparameters
omega_in = o*rand; % input scaling
Nh = randi([hs(1), hs(2)]); % number of hidden neurons
rho = r*rand; % spatial radius
Nw = randi([ws(1), ws(2)]);% transient
lambda_r = lr*rand; % weight decay regularization

end

