input_data = load('lab2_1_data.csv');

alpha = 3; learning_rate = 0.1; max_epoch = 100; eps = 0.1;

W = oja_rule(input_data, alpha, learning_rate, max_epoch, eps);
Q = cov(input_data');
[V, D] = eig(Q);
[~, max_index] = max(diag(D));
max_eigenvector = V(:,max_index);

save(fullfile('results', 'weight_vector.mat'), 'W')

gcf1 = figure('Name','Oja');
hold on
sct1 = scatter(input_data(1,:), input_data(2,:), 'filled', 'k');
plt1 = plot([0, W(1,end) / norm(W(:,end))],[0, W(2,end) / norm(W(:,end))] , '-r');
plt2 = plot([0 max_eigenvector(1)  / norm(max_eigenvector)], [0 max_eigenvector(2)  / norm(max_eigenvector)], '-b');
hold off
legend([sct1, plt1, plt2], 'Points', 'Last weight vector', 'Eigenvec. (max eigenval.)')
title('Oja rule')
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