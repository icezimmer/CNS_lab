data = load("lab2_2_data.mat");

input_patterns = [data.p0, data.p1, data.p2];
memory_pattern = 0;
distortion_prop = 0.05;

num_config = 10;
for config=1:num_config
    bias = (1+1) * rand - 1;
    Model = Hopfield(input_patterns, memory_pattern+1, bias, distortion_prop);
    % Best configuration
    if config == 1
        minimum = Model.discrepancy;
        bias_best = bias;
    elseif Model.discrepancy < minimum
        minimum = Model.discrepancy;
        bias_best = bias;
    end
end

Model_best = Hopfield(input_patterns, memory_pattern+1, bias_best, distortion_prop);
Model_best.plot(memory_pattern+1, distortion_prop)