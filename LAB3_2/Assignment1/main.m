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
disp('Random Search: 0%')
num_config = 3;
r_guesses = 3;
ME_vl = Inf;
ME_tr = Inf;
for config = 1:num_config
    meanError_vl = 0;
    meanError_tr = 0;
    [omega_in, Nh, rho, Nw, lambda_r] = randomGen([0.9,1.2], [100, 500], [0.8,1], [100, 700], [2, 5], seed);
    for seed=1:r_guesses        
        [~, x_tr_ws, pooler_tr] = esn(tr_in, omega_in, Nh, rho, Nw, seed);
        W_out = trainReadout(x_tr_ws, tr_tg, lambda_r);
        y_tr = readout(x_tr_ws, W_out);
        tr_error = immse(y_tr, tr_tg(:, Nw+1:end));
        meanError_tr = meanError_tr + (tr_error/r_guesses);
    
        x_vl = esn(vl_in, omega_in, Nh, rho, 0, seed, pooler_tr);
        y_vl = readout(x_vl, W_out);
        vl_error = immse(y_vl, vl_tg);
        meanError_vl = meanError_vl + (vl_error/r_guesses);
    end
    % Save the best configuration
    if meanError_vl < ME_vl
        ME_vl = meanError_vl;
        ME_tr = meanError_tr;
        omega_in_best = omega_in;
        Nh_best = Nh;
        rho_best = rho;
        Nw_best = Nw;
        lambda_r_best = lambda_r;
    end
    disp(['Random Search: ', num2str(100*(config/num_config)), '%'])
end

% Save the hyper-parameters
save(fullfile('results', strcat('ESNhyperparameters', '.mat')), 'omega_in_best', 'Nh_best', 'rho_best', 'Nw_best', 'lambda_r_best')

% Refit
disp('Refit')
[~, x_dv_ws, pooler_dv, W_in, W_hat] = esn(dv_in, omega_in_best, Nh_best, rho_best, Nw_best, seed);
W_out = trainReadout(x_dv_ws, dv_tg, lambda_r_best);
y_dv = readout(x_dv_ws, W_out);

% Save the weight matrices
save(fullfile('results', strcat('ESNstruct', '.mat')),'W_in', 'W_hat', 'W_out')

% Plot target and output signal (Training)
gcf1 = figure('Name', 'Training');
plt1 = plot(dv_tg(:, Nw_best+1:end), '-k');
hold on
plt2 = plot(y_dv, '-r');
hold off
legend([plt1, plt2], 'target', 'predict')
saveas(gcf1, fullfile('results', strcat('ESNtraining', '.png')))

% Test the net
disp('Assessment')
x_ts = esn(ts_in, omega_in_best, Nh_best, rho_best, 0, seed, pooler_dv);
y_ts = readout(x_ts, W_out);
ts_error = immse(y_ts, ts_tg);

% Save the MSE for the TR, VL and TS sets
tr_MSE = ME_tr;
vl_MSE = ME_vl;
ts_MSE = ts_error;
save(fullfile('results', 'ESNmse.mat'), 'tr_MSE', 'vl_MSE', 'ts_MSE')

disp(['TR MSE (best config): ', num2str(tr_MSE)])
disp(['VL MSE (best config): ', num2str(vl_MSE)])
disp(['TS MSE (best config after refit): ', num2str(ts_MSE)])

% Plot target and output signal (Test)
gcf2 = figure('Name', 'Test');
plt1 = plot(ts_tg, '-k');
hold on
plt2 = plot(y_ts, '-r');
hold off
legend([plt1, plt2], 'target', 'predict')
saveas(gcf2, fullfile('results', strcat('ESNtest', '.png')))
