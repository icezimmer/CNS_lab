classdef Izhikevich
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Potential
        Recovery
        Input
    end
    
    methods
        function obj = Izhikevich(u0, w0, parameters, tau, I, name)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            if(strcmp(name,"Class 1") || strcmp(name,"Integrator"))
                f = @(u, w, I) 0.04 * u^2 + 4.1 * u + 108 - w + I;
                g = @(u, w, a, b) a * (b * u - w);
            elseif(strcmp(name,"Accomodation"))
                f = @(u, w, I) 0.04 * u^2 + 5 * u + 140 - w + I;
                g = @(u, w, a, b) a * (b * u + 65);
            else
                f = @(u, w, I) 0.04 * u^2 + 5 * u + 140 - w + I;
                g = @(u, w, a, b) a * (b * u - w);
            end

            a=parameters(1);
            b=parameters(2);
            c=parameters(3);
            d=parameters(4);

            obj.Input = I;
            u = u0;
            w = w0;
            
            obj.Potential = [];
            obj.Recovery = [];
            
            
            for i = 1 : length(I)
                u = u + tau * f(u, w, I(i));
                w = w + tau * g(u, w, a, b);
            
                if (u > 30)
                    obj.Potential(end+1) = 30;
                    u = c;
                    w = w + d;
                else
                    obj.Potential(end+1) = u;
                end
                obj.Recovery(end+1) = w;
            end
        end

        function plot(obj, name)
            gcf = figure('Name',name,'NumberTitle','off');
            
            tiledlayout(2,2)
            
            nexttile
            plot(obj.Potential, '-b')
            title("Neuron")
            xlabel('time')
            ylabel('membrane potential')
            
            nexttile
            plot(obj.Potential, obj.Recovery, '-r')
            title("Dynamical system")
            xlabel("membrane potential")
            ylabel("recovery")
            
            nexttile
            plot(obj.Input, '-g')
            title("Input")
            
            saveas(gcf, fullfile('results', strcat(name, '.png')))
        end
    end
end

