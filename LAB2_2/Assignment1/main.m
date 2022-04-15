data = load("lab2_2_data.mat");

input_patterns = [data.p0, data.p1, data.p2];
memory_pattern = 2;
distortion_prop = 0.25;

num_config = 10;
for config=1:num_config
    bias = (1+1) * rand - 1;
    Model = Hopfield(input_patterns, memory_pattern+1, bias, distortion_prop);
    Model.similarity
    % Best configuration
    if config == 1
        minimum = Model.similarity;
        bias_best = bias;
    elseif Model.similarity < minimum
        minimum = Model.similarity;
        bias_best = bias;
    end
end

Model_best = Hopfield(input_patterns, memory_pattern+1, bias_best, distortion_prop);
Model_best.video