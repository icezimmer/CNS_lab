data = load("NARMA10timeseries.mat");
input_data = data.NARMA10timeseries.input;
target_data = data.NARMA10timeseries.target;

dv_index = 1:5000;
tr_index = 1:4000;
vl_index = 4001:5000;
ts_index = 5001:length(input_data);

dv_in = cell2mat(input_data(dv_index));
tr_in = cell2mat(input_data(tr_index));
vl_in = cell2mat(input_data(vl_index));
ts_in = cell2mat(input_data(ts_index));

dv_tg = cell2mat(target_data(dv_index)); 
tr_tg = cell2mat(target_data(tr_index));
vl_tg = cell2mat(target_data(vl_index));
ts_tg = cell2mat(target_data(ts_index));

%{
omega_in = 0.5;
Nh = 200;
rho = 0.8;
Nw = 500;
seed = 1;

lambda_r = 0.01;

% Echo state
x = esn(tr_in, omega_in, Nh, rho, Nw, seed);
%y = readoutPinv(x, tr_tg, Nw);
y = readoutRidgeReg(x, tr_tg, Nw, lambda_r);

% MSE
d = tr_tg(:, Nw+1:end);
immse(y, d)
%}

seed = 1;
% Model Selection (Training with Random search)
num_config = 10;
for config = 1:num_config

    [omega_in, Nh, rho, Nw, lambda_r] = randomGen([1], [100, 500], [0.9], [200, 700], [0], seed);
    x_tr = esn(tr_in, omega_in, Nh, rho, Nw, seed);
    W_out = trainReadout(x_tr, tr_tg, Nw, lambda_r);
    y_tr = readout(x_tr, W_out);
    d_tr = tr_tg(:, Nw+1:end);
    tr_error = immse(y_tr, d_tr);

    x_vl = esn(vl_in, omega_in, Nh, rho, 0, seed);
    y_vl = readout(x_vl, W_out);
    vl_error = immse(y_vl, vl_tg);

    % Best configuration
    if config == 1
        tr_minimum = tr_error;
        vl_minimum = vl_error;
        seed_best = seed;
        omega_in_best = omega_in;
        Nh_best = Nh;
        rho_best = rho;
        Nw_best = Nw;
        lambda_r_best = lambda_r;
    elseif vl_error < vl_minimum
        tr_minimum = tr_error;
        vl_minimum = vl_error;
        seed_best = seed;
        omega_in_best = omega_in;
        Nh_best = Nh;
        rho_best = rho;
        Nw_best = Nw;
        lambda_r_best = lambda_r;
    end

    seed = seed + 1;

end

disp(['TR MSE (best config): ', num2str(tr_minimum)])
disp(['VL MSE (best config): ', num2str(vl_minimum)])


% Refit
x_dv = esn(dv_in, omega_in_best, Nh_best, rho_best, Nw_best, seed_best);
W_out_new = trainReadout(x_dv, dv_tg, Nw_best, lambda_r_best);

% Test the net
x_ts = esn(ts_in, omega_in_best, Nh_best, rho_best, 0, seed_best);
y_ts = readout(x_ts, W_out_new);
ts_error = immse(y_ts, ts_tg);

disp(['TS MSE (best config after refit): ', num2str(ts_error)])

disp('Best hyperparameters:')
disp(['Seed: ', num2str(seed_best)])
disp(['Omega in: ', num2str(omega_in_best)])
disp(['Number of hidden neurons: ', num2str(Nh_best)])
disp(['Spatial radius: ', num2str(rho)])
disp(['Transient: ', num2str(Nw_best)])
disp(['Regularization: ', num2str(lambda_r_best)])
