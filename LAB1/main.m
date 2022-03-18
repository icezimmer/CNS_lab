data_values = load(fullfile('data', 'data_value.mat'));
input_values = load(fullfile('data', 'input_signal.mat'), 'input_signal');
input_signal = input_values.input_signal;

u0 = -65;

for i = 1:20
    name = data_values.Neuro_computational_feature(i);
    tau = data_values.Tau(i);
    parameters = data_values.Parameters(i,:);
    input = cell2mat(input_signal(i));
    izhikevich_model(name, u0, tau, parameters, input);
end