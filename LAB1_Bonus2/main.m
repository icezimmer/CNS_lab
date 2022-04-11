load laser_dataset.mat
data = cell2mat(laserTargets);

input = data(1:end-1);
target = data(2:end);

dim = 2000;
dv_dim = 1500;
tr_dim = int32(dv_dim * 0.7);
vl_dim = int32(dv_dim * 0.3);

all_index = 1:dim;
dv_index = 1:dv_dim;
tr_index = 1:tr_dim;
vl_index = tr_dim+1:tr_dim+vl_dim;
ts_index = dv_dim+1:dim;

all_input = input(all_index);
dv_input = input(dv_index);
tr_input = input(tr_index);
vl_input = input(vl_index);
ts_input = input(ts_index);

all_target = target(all_index);
dv_target = target(dv_index);
tr_target = target(tr_index);
vl_target = target(vl_index);
ts_target = target(ts_index);

% Activation functions
Identity = @(x, bias) x+bias; 
Binary = @(x, bias) x>0;
TanH = @(x, bias) tanh(x+bias);
ReLu = @(x, bias) (x+bias>0).*x;
act_funs = {Identity, Binary, TanH, ReLu};


% Number of configuration for the Random Search
num_config = 10;

% Random Search
for config = 1:num_config
    % Hyperparameters generation
    cx = -30; rx = 10; bias = cx + (rx+rx) * rand - rx;
    act_fun = act_funs{randi([1, length(act_funs)])};
    sx = 200; dx = 300; Ne = randi([sx, dx]);
    sx = 100; dx = 200; Ni = randi([sx, dx]);
    cx = 1; rx = 10; win_e = cx + (rx+rx) * rand - rx;
    cx = 8; rx = 10; win_i = cx + (rx+rx) * rand - rx;
    cx = 16; rx = 10; w_e = cx + (rx+rx) * rand - rx;
    cx = -23; rx = 10; w_i = cx + (rx+rx) * rand - rx;

    % States computation (LSM phase)
    [states, ~] = lsm(all_input, Ne, Ni, win_e, win_i, w_e, w_i, bias, act_fun);

    % Training Phase
    tr_states = states(:,tr_index);
    W_out = tr_target * pinv(tr_states); % Read Out Training (direct computation)
    tr_output = W_out * tr_states;
    tr_error = mean(abs(tr_output - tr_target));

    % Validation Phase
    vl_states = states(:,vl_index);
    vl_output = W_out * vl_states;
    vl_error = mean(abs(vl_output - vl_target));

    % Best configuration
    if config == 1
        tr_minimum = tr_error;
        vl_minimum = vl_error;
        states_best = states;
        bias_best = bias;
        Ne_best = Ne;
        Ni_best = Ni;        
        win_e_best = win_e;
        win_i_best = win_i;
        w_e_best = w_e;
        w_i_best = w_i;
    elseif vl_error < vl_minimum
        tr_minimum = tr_error;
        vl_minimum = vl_error;
        states_best = states;
        bias_best = bias;
        Ne_best = Ne;
        Ni_best = Ni;
        win_e_best = win_e;
        win_i_best = win_i;
        w_e_best = w_e;
        w_i_best = w_i;
    end
end

disp('Best Hyperparameters: ')
disp(['Best bias: ', num2str(bias_best)])
disp(['Best Ne: ', num2str(Ne_best)])
disp(['Best Ni: ', num2str(Ni_best)])
disp(['Best win_e: ', num2str(win_e_best)])
disp(['Best win_i: ', num2str(win_i_best)])
disp(['Best w_e: ', num2str(w_e_best)])
disp(['Best w_i: ', num2str(w_i_best)])

disp(['TR MAE (best config): ', num2str(tr_minimum)])

disp(['VL MAE (best config): ', num2str(vl_minimum)])

% Refit
dv_states_best = states_best(:,dv_index);
W_out = dv_target * pinv(dv_states_best);

% Test Phase
ts_states_best = states_best(:,ts_index);
ts_output = W_out * ts_states_best;

% Test Error
ts_error = mean(abs(ts_output - ts_target));
display(['TS MAE (best config): ', num2str(ts_error)])

gcf = figure('Name','Predicted signal');

tiledlayout(3,1)

liquid = nexttile;
imshow(ts_states_best, []);
colormap(liquid, "turbo")
colorbar(liquid)
title("Liquid state")
ylabel('neuron')
xlabel('time')

read_out = nexttile;
plot(ts_output, '-k')
title("Predicted signal")
xlabel('time')

target = nexttile;
plot(ts_target, '-r')
title("Target signal")
xlabel("time")

linkaxes([liquid, read_out, target],'x')

saveas(gcf, fullfile('results', 'test.png'))