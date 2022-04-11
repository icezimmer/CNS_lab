function W = hebb_rule(input_data, learning_rate, max_epoch, eps)

W = 2 * rand(2, 1) - 1;

for epoch = 1 : max_epoch
    [~, num_pattern] = size(input_data);
    input_data_shuffle = input_data(:, randperm(num_pattern));
    for pattern = 1 : num_pattern
        U = input_data_shuffle(:, pattern);
        v = W(:, end)' * U;
        delta_w = v * U;
        W = [W, W(:, end) + learning_rate * delta_w];
    end
    if norm(W(:, end) - W(:, end-1)) < eps
        epoch = max_epoch;
    end
end

end