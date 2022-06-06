data = load("NARMA10timeseries.mat");
input_data = data.NARMA10timeseries.input;
target_data = data.NARMA10timeseries.target;

dv_index = 1:5000;
tr_index = 1:4000;
vl_index = 4001:5000;
ts_index = 5001:length(input_data);

dv_in = input_data(dv_index);
tr_in = input_data(tr_index);
vl_in = input_data(vl_index);
ts_in = input_data(ts_index);

dv_tg = target_data(dv_index); 
tr_tg = target_data(tr_index);
vl_tg = target_data(vl_index);
ts_tg = target_data(ts_index);

% Model Selection (Training with Random search)
disp('Random Search: 0%')
num_config = 10;
for config = 1:num_config
    [net, delayedInput, initialInput, ~, delayedTarget] = randomRNNgen(tr_in, tr_tg, [1, 3], [10, 20], 0.01, 0.1, [100,1000], [4, 7]);
    net = train(net, delayedInput, delayedTarget, initialInput);
    tr_out = net(tr_in);
    vl_out = net(vl_in);
    tr_error = immse(cell2mat(tr_out), cell2mat(tr_tg));
    vl_error = immse(cell2mat(vl_out), cell2mat(vl_tg));
    % Best configuration
    if config == 1
        tr_minimum = tr_error;
        vl_minimum = vl_error;
        hiddenSize_best = net.layers{1}.size;
        lr_best = net.trainParam.lr;
        mc_best = net.trainParam.mc;
        epochs_best = net.trainParam.epochs;        
        regularization_best = net.performParam.regularization;
    elseif vl_error < vl_minimum
        tr_minimum = tr_error;
        vl_minimum = vl_error;
        hiddenSize_best = net.layers{1}.size;
        lr_best = net.trainParam.lr;
        mc_best = net.trainParam.mc;
        epochs_best = net.trainParam.epochs;        
        regularization_best = net.performParam.regularization;
    end
    disp(['Random Search: ', num2str(100*(config/num_config)), '%'])
end

% Refit
disp('Refit')
net_best = layrecnet(1);
[delayedInput, initialInput, initialStates, delayedTarget] = preparets(net_best, dv_in, dv_tg);
net_best.divideFcn = 'dividetrain';
net_best.trainParam.showWindow = 0;
net_best.layers{1}.size = hiddenSize_best;
net_best.trainParam.lr = lr_best;
net_best.trainParam.mc = mc_best;
net_best.trainParam.epochs = epochs_best;        
net_best.performParam.regularization = regularization_best;
[net_best,tr_best] = train(net_best, delayedInput, delayedTarget, initialInput);

% Plot target and output signal (Training)
gcf1 = figure('Name', 'Training');
plt1 = plot(cell2mat(dv_tg), '-k');
hold on
plt2 = plot(cell2mat(net_best(dv_in)), '-r');
hold off
legend([plt1, plt2], 'target', 'predict')
saveas(gcf1, fullfile('results', strcat('RNNtraining', '.png')))

% Learning curve
gcf1 = figure('Name', 'Learning curve');
plt = plot(tr_best.perf);
title('Learning curve')
xlabel('epochs')
ylabel('MSE')
legend(plt, 'Training')
saveas(gcf1, fullfile('results', 'RNNlearning_curve.png'))

% Test the net
disp('Assessment')
ts_out = net_best(ts_in);
ts_error = immse(cell2mat(ts_out), cell2mat(ts_tg));

disp(['TR MSE (best config): ', num2str(tr_minimum)])
disp(['VL MSE (best config): ', num2str(vl_minimum)])
disp(['TS MSE (best config after refit): ', num2str(ts_error)]);

% Save the data structures
RNN_net = net_best;
RNN_trainingRecord = tr_best;
tr_MSE = tr_minimum;
vl_MSE = vl_minimum;
ts_MSE = ts_error;
save(fullfile('results', strcat('RNN', 'data_struct', '.mat')), 'RNN_net', 'RNN_trainingRecord', 'tr_MSE', 'vl_MSE', 'ts_MSE')

% Plot target and output signal (Test)
gcf3 = figure('Name', 'Test');
plt1 = plot(cell2mat(ts_tg), '-k');
hold on
plt2 = plot(cell2mat(ts_out), '-r');
hold off
legend([plt1, plt2], 'target', 'predict')
saveas(gcf3, fullfile('results', strcat('RNNtest', '.png')))
