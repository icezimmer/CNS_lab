create_data

data_values = load(fullfile('data', 'data_values.mat'));
input_values = load(fullfile('data', 'input_values.mat'), 'input_signal');
input_signal = input_values.input_signal;

for i = 1:20
    name = data_values.Neuro_computational_feature(i);
    u0 = data_values.Initial_conditions(i,1);
    w0 = data_values.Initial_conditions(i,2);
    parameters = data_values.Parameters(i,:);
    tau = data_values.Tau(i);
    input = cell2mat(input_signal(i));
    izhikevich_model(name, u0, w0, parameters, tau, input);
end