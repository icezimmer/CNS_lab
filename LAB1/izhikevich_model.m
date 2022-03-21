function [uu, ww] = izhikevich_model(name, u0, w0, parameters, tau, I)

f = @(u, w, I) 0.04 * u^2 + 5 * u + 140 - w + I;
g = @(u, w, a, b) a * (b * u - w);

display(name)

a=parameters(1);
b=parameters(2);
c=parameters(3);
d=parameters(4);

u = u0;
w = w0;

uu = [];
ww = [];


for i = 1 : length(I)
    u = u + tau * f(u, w, I(i));
    w = w + tau * g(u, w, a, b);

    if (u > 30)
        uu(end+1) = 30;
        u = c;
        w = w + d;
    else
        uu(end+1) = u;
    end
    ww(end+1) = w;
end

gcf = figure('Name',name,'NumberTitle','off');

tiledlayout(2,2)

nexttile
plot(uu, '-b')
title("Neuron")
xlabel('time')
ylabel('membrane potential')

nexttile
plot(uu, ww, '-r')
title("Dynamical system")
xlabel("membrane potential")
ylabel("recovery")

nexttile
plot(I, '-g')
title("Input")

saveas(gcf, fullfile('results', strcat(name, '.png')))

end