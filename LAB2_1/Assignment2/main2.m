input_data = load('lab2_1_data.csv');

alpha = 3; learning_rate = 0.1; max_epoch = 100; eps = 0.1;

W = oja_rule(input_data, alpha, learning_rate, max_epoch, eps);
Q = cov(input_data');
[V, D] = eig(Q);
[~, max_index] = max(diag(D));
max_eigenvector = V(:,max_index);

save(fullfile('results', 'weight_vector.mat'), 'W')

gcf1 = figure('Name','Results');
hold on
scatter(input_data(1,:), input_data(2,:), 'filled', 'k')
plotv(W(:,end) / norm(W(:,end)), '-r')
plotv(max_eigenvector  / norm(max_eigenvector), '-b')
hold off
title('Oja vs. eigenvector (max eigenvalue)')
saveas(gcf1, fullfile('results', strcat('scatter', '.png')))

gcf2 = figure('Name','Weights');
tiledlayout(3,1)
first = nexttile;
plot(W(1,:));
xlabel("time")
title("First component")
second = nexttile;
plot(W(2,:));
xlabel("time")
title("Second component")
third = nexttile;
hold on
plot((1/sqrt(alpha)) * ones(1, size(W, 2)), 'r')
plot(vecnorm(W), 'b');
xlabel("time")
hold off
title("Norm")
saveas(gcf2, fullfile('results', strcat('components', '.png')))