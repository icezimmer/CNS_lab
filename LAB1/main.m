create_data

data_values = load(fullfile('data', 'data_values.mat'));
input_values = load(fullfile('data', 'input_values.mat'), 'input_signals');
input_signals = input_values.input_signals;

for i = 1:20
    name = data_values.Neuro_computational_feature(i);
    u0 = data_values.Initial_conditions(i,1);
    w0 = data_values.Initial_conditions(i,2);
    parameters = data_values.Parameters(i,:);
    tau = data_values.Tau(i);
    input = cell2mat(input_signals(i));
    Neuron = Izhikevich(u0, w0, parameters, tau, input, name);
    Neuron.plot(name)
end