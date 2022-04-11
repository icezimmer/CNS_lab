input_data = load('lab2_1_data.csv');

learning_rate = 0.1; max_epoch = 100; eps = 0.1;
W = hebb_rule(input_data, learning_rate, max_epoch, eps);
Q = cov(input_data');
[V, D] = eig(Q);
diag(D)
[~, max_index] = max(diag(D));
max_eigenvector = V(:,max_index); 

gcf1 = figure('Name','Results');
hold on
scatter(input_data(1,:), input_data(2,:), 'filled', 'k')
plotv(W(:,end) / norm(W(:,end)), '-r')
plotv(max_eigenvector  / norm(max_eigenvector), '-b')
hold off

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
plot(vecnorm(W));
xlabel("time")
title("Norm")