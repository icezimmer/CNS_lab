data = load("NARMA10timeseries.mat");
input_data = data.NARMA10timeseries.input;
target_data = data.NARMA10timeseries.target;

dv_index = 1:5000;
tr_index = 1:4000;
vl_index = 4001:5000;
ts_index = 5001:length(input_data);

%servono le cell e non array
dv_in = input_data(dv_index);
tr_in = input_data(tr_index);
vl_in = input_data(vl_index);
ts_in = input_data(ts_index);

dv_tg = target_data(dv_index); 
tr_tg = target_data(tr_index);
vl_tg = target_data(vl_index);
ts_tg = target_data(ts_index);

% Model Selection (Training with Random search)
num_config = 20;
for config = 1:num_config
    [net, delayedInput, initialInput, ~, delayedTarget] = randomIDNNgen(tr_in, tr_tg, [5, 15], [10, 100], 0.01, 0.1, [500,1500], [4,7]);
    net = train(net, delayedInput, delayedTarget, initialInput);
    tr_out = net(tr_in);
    vl_out = net(vl_in);
    tr_error = immse(cell2mat(tr_out), cell2mat(tr_tg));
    vl_error = immse(cell2mat(vl_out), cell2mat(vl_tg));
    % Best configuration
    if config == 1
        %net_best = net;
        tr_minimum = tr_error;
        vl_minimum = vl_error;
        numInputDelays_best = net.numInputDelays;
        hiddenSize_best = net.layers{1}.size;
        lr_best = net.trainParam.lr;
        mc_best = net.trainParam.mc;
        epochs_best = net.trainParam.epochs;        
        regularization_best = net.performParam.regularization;
    elseif vl_error < vl_minimum
        %net_best = net;
        tr_minimum = tr_error;
        vl_minimum = vl_error;
        numInputDelays_best = net.numInputDelays;
        hiddenSize_best = net.layers{1}.size;
        lr_best = net.trainParam.lr;
        mc_best = net.trainParam.mc;
        epochs_best = net.trainParam.epochs;        
        regularization_best = net.performParam.regularization;
    end
end

% Refit
net_best = timedelaynet(1:numInputDelays_best);
[delayedInput, initialInput, initialStates, delayedTarget] = preparets(net_best, dv_in, dv_tg);
net_best.divideFcn = 'dividetrain';
net_best.trainParam.showWindow = 0;
net_best.layers{1}.size = hiddenSize_best;
net_best.trainParam.lr = lr_best;
net_best.trainParam.mc = mc_best;
net_best.trainParam.epochs = epochs_best;        
net_best.performParam.regularization = regularization_best;
[net_best, t] = train(net_best, delayedInput, delayedTarget, initialInput);

% Save the hyper-parameters
save(fullfile('results', strcat('IDNN', 'hyperparameters', '.mat')), 'numInputDelays_best', 'hiddenSize_best', 'lr_best', 'mc_best', 'epochs_best', 'regularization_best')

% Architecture
view(net_best)

% Test the net
ts_out = net_best(ts_in);
ts_error = immse(cell2mat(ts_out), cell2mat(ts_tg));

disp(['TR MSE (best config): ', num2str(tr_minimum)])
disp(['VL MSE (best config): ', num2str(vl_minimum)])
disp(['TS MSE (best config after refit): ', num2str(ts_error)]);

% Save the MSE for the TR, VL and TS sets
save(fullfile('results', strcat('IDNN', 'mse', '.mat')),'tr_minimum', 'vl_minimum', 'ts_error')

plot(t.time, t.perf)