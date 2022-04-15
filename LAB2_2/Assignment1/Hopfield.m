classdef Hopfield

    properties
        neurons
        measures
        energy
        streaming
        similarity
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
            obj.streaming = reshape(obj.neurons,32,32);
            
            stability = false;
            shuffle = randperm(N);
            neurons_new = obj.neurons(:, end);
            
            while ~stability
                for i = 1 : N
                    j = shuffle(i);
                    neurons_new(j) = sign(W(j, :) * neurons_new + bias + eps);
                    obj.neurons = [obj.neurons, neurons_new];
                    obj.measures = [obj.measures, (1 / N) * (input_patterns' * neurons_new)];
                    obj.energy = [obj.energy, (-1/2) * sum(W .* kron(neurons_new, neurons_new'), "all")];
                    obj.streaming = cat(3, obj.streaming, reshape(neurons_new, 32, 32));
                    if isequal(obj.neurons(:, end), obj.neurons(:, end-1))
                        stability = true;
                    end
                end
            end

            obj.similarity = 1/2 * sum(abs(obj.neurons(:, end) - input_patterns(:, pattern)));
        end

        function video(obj)
            implay(obj.streaming,100)
        end
        
        function plot(obj)
            figure('Name','Energy');
            plot(obj.energy, '-b')
            title("Energy function")
            
            figure('Name','Overlapping functions');
            plt2 = plot(obj.measures);
            title("Overlapping functions")
            legend(plt2,'m_0', 'm_1', 'm_2','Location', 'best')
            
            img1 = reshape(obj.neurons(:, 1), 32, 32);
            img2 = reshape(obj.neurons(:, end), 32, 32);
            figure('Name', 'Reconstructed image')
            tiledlayout(1,2)
            nexttile
            imagesc(img1)
            nexttile
            imagesc(img2)
        end
    end
end
