classdef Hopfield

    properties
        neurons
        measures
        energy
        discrepancy
    end

    methods
        function obj = Hopfield(input_patterns, pattern, bias, distortion_prop)
            N = size(input_patterns, 1);
            M = size(input_patterns, 2);
            
            W = zeros(N, N);
            for i = 1 : M
                W = W + input_patterns(:, i) * input_patterns(:, i)';
            end
            W = (1 / N) * (W - M * eye(N));
            
            obj.neurons = distort_image(input_patterns(:, pattern), distortion_prop);
            obj.measures = zeros(M, 0);
            obj.energy = zeros(1, 0);
            
            stability = false;
            shuffle = randperm(N);
            neurons_new = obj.neurons(:, end);
            
            while ~stability
                for i = 1 : N
                    j = shuffle(i);
                    neurons_new(j) = sign(W(j, :) * neurons_new + bias + eps);
                    obj.measures = [obj.measures, (1 / N) * (input_patterns' * neurons_new)];
                    obj.energy = [obj.energy, (-1/2) * sum(W .* kron(neurons_new, neurons_new'), "all")];
                end
                obj.neurons = [obj.neurons, neurons_new];
                if isequal(obj.neurons(:, end), obj.neurons(:, end-1))
                    stability = true;
                end
            end

            obj.discrepancy = nnz(obj.neurons(:, end) ~= input_patterns(:, pattern)) / numel(input_patterns(:, pattern));
        end

        function plot(obj, pattern, distortion_prop)
            subt1 = num2str(pattern);
            subt2 = regexprep(num2str(distortion_prop), '[.]', '');

            gcf1 = figure('Name','Energy');
            plot(obj.energy, '-b')
            title("Energy function")
            saveas(gcf1, fullfile('results', strcat('energy_', subt1, '_', subt2, '.png')))
            
            gcf2 = figure('Name','Overlap. functions');
            plt2 = plot(obj.measures');
            title("Overlapping functions")
            legend(plt2,'m_0', 'm_1', 'm_2','Location', 'best')
            saveas(gcf2, fullfile('results', strcat('overFun_', subt1, '_', subt2, '.png')))
            
            img1 = reshape(obj.neurons(:, 1), 32, 32);
            img2 = reshape(obj.neurons(:, end), 32, 32);
            gcf3 = figure('Name', 'Reconstructed image');
            t = tiledlayout(1,2);
            nexttile
            imagesc(img1)
            nexttile
            imagesc(img2)
            title(t, ['Discrepancy is ', num2str(obj.discrepancy)])
            saveas(gcf3, fullfile('results', strcat('reconstruction_', subt1, '_', subt2,  '.png')))
        end
    end
end
