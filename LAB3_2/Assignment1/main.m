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

% Model Selection (Random search)
seed = 1;
num_config = 5;
for config = 1:num_config

    [omega_in, Nh, rho, Nw, lambda_r] = randomGen(1.2, [100, 500], 1, [200, 700], [4, 7], seed);
    
    [~, x_tr_ws, pooler_tr] = esn(tr_in, omega_in, Nh, rho, Nw, seed);
    W_out = trainReadout(x_tr_ws, tr_tg, lambda_r);
    y_tr = readout(x_tr_ws, W_out);
    tr_error = immse(y_tr, tr_tg(:, Nw+1:end));

    x_vl = esn(vl_in, omega_in, Nh, rho, 0, seed, pooler_tr);
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

% Save the hyper-parameters
save(fullfile('results', strcat('hyperparameters', '.mat')), 'seed_best', 'omega_in_best', 'Nh_best', 'rho_best', 'Nw_best', 'Nw_best', 'lambda_r_best')

% Refit
[~, x_dv_ws, pooler_dv, W_in, W_hat] = esn(dv_in, omega_in_best, Nh_best, rho_best, Nw_best, seed_best);
W_out_new = trainReadout(x_dv_ws, dv_tg, lambda_r_best);
y_dv = readout(x_dv_ws, W_out_new);

% Save the weight matrices
save(fullfile('results', strcat('esn_struct', '.mat')),'W_in', 'W_hat', 'W_out_new')

% Plot target and output signal (Training)
gcf1 = figure('Name', 'Training');
plt1 = plot(dv_tg(:, Nw_best+1:end), '-k');
hold on
plt2 = plot(y_dv, '-r');
hold off
legend([plt1, plt2], 'target', 'predict')
saveas(gcf1, fullfile('results', strcat('training', '.png')))

% Test the net
x_ts = esn(ts_in, omega_in_best, Nh_best, rho_best, 0, seed_best, pooler_dv);
y_ts = readout(x_ts, W_out_new);
ts_error = immse(y_ts, ts_tg);

% Save the MSE for the TR, VL and TS sets
save(fullfile('results', strcat('mse', '.mat')),'tr_minimum', 'vl_minimum', 'ts_error')


disp(['TR MSE (best config): ', num2str(tr_minimum)])
disp(['VL MSE (best config): ', num2str(vl_minimum)])
disp(['TS MSE (best config after refit): ', num2str(ts_error)])

% Plot target and output signal (Test)
gcf2 = figure('Name', 'Test');
plt1 = plot(ts_tg, '-k');
hold on
plt2 = plot(y_ts, '-r');
hold off
legend([plt1, plt2], 'target', 'predict')
saveas(gcf2, fullfile('results', strcat('test', '.png')))