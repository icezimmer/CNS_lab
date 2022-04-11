function [neurons, measures, energy] = hopfield(input_patterns, pattern, distortion_prop)

N = size(input_patterns, 1);
M = size(input_patterns, 2);

W = zeros(N, N);
for i = 1 : M
    W = W + input_patterns(:, i) * input_patterns(:, i)';
end
W = (1 / N) * (W - M * eye(N));

neurons = distort_image(input_patterns(:, pattern), distortion_prop);
measures = zeros(M, 0);
energy = zeros(1, 0);
streaming = reshape(neurons,32,32);


shuffle = randperm(N);
neurons_new = neurons(:, end);
for i = 1 : N
    j = shuffle(i);
    neurons_new(j) = sign(W(j, :) * neurons_new);
    neurons = [neurons, neurons_new];
    measures = [measures, (1 / N) * (input_patterns' * neurons_new)];
    energy = [energy, (-1/2) * sum(W .* kron(neurons_new, neurons_new'), "all")];
    streaming = cat(3, streaming, reshape(neurons_new, 32, 32));
end
    


while ~isequal(neurons(:, end), neurons(:, end-1))
    shuffle = randperm(N);
    neurons_new = neurons(:, end);
    for i = 1 : N
        j = shuffle(i);
        neurons_new(j) = sign(W(j, :) * neurons_new + eps);
        neurons = [neurons, neurons_new];
        measures = [measures, (1 / N) * (input_patterns' * neurons_new)];
        energy = [energy, (-1/2) * sum(W .* kron(neurons_new, neurons_new'), "all")];
        streaming = cat(3, streaming, reshape(neurons_new, 32, 32));
    end
end

implay(streaming,100)

figure('Name','Energy');
plot(energy, '-b')
title("Energy function")

figure('Name','Overlapping functions');
plt2 = plot(measures');
title("Overlapping functions")
legend(plt2,'m_0', 'm_1', 'm_2','Location', 'best')

img1 = reshape(neurons(:, 1), 32, 32);
img2 = reshape(neurons(:, end), 32, 32);
figure('Name', 'Reconstructed image')
tiledlayout(1,2)
nexttile
imagesc(img1)
nexttile
imagesc(img2)

end
