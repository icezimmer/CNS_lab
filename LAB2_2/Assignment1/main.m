data = load("lab2_2_data.mat");

input_patterns = [data.p0, data.p1, data.p2];
distortion_prop = [0.05, 0.1, 0.25];

% Model selection
tot_discrepancy = 0;
num_config = 5;
for config=1:num_config
    bias = (1+1) * rand - 1;
    for pattern=1:size(input_patterns,2)
        for j=1:length(distortion_prop)
            Model = Hopfield(input_patterns, pattern, bias, distortion_prop(j));
            tot_discrepancy = tot_discrepancy + Model.discrepancy;
        end
    end
    tot_discrepancy = tot_discrepancy / (size(input_patterns,2) * length(distortion_prop));

    % Best configuration
    if config == 1
        minimum = tot_discrepancy;
        bias_best = bias;
    elseif tot_discrepancy < minimum
        minimum = tot_discrepancy;
        bias_best = bias;
    end
end


for pattern=1:size(input_patterns,2)
    for j=1:length(distortion_prop)
        Model_best = Hopfield(input_patterns, pattern, bias_best, distortion_prop(j));
        Model_best.plot(pattern, distortion_prop(j))
    end
end

%{
Model_best = Hopfield(input_patterns, index_pattern+1, bias_best, distortion_prop);
Model_best.plot(index_pattern+1, distortion_prop)
%}