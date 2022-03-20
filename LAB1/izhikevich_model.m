function [uu, ww] = izhikevich_model(name, u0, tau, parameters, I)

display(name)

a=parameters(1);
b=parameters(2);
c=parameters(3);
d=parameters(4);

w0 = b * u0;

N = length(I);

u = u0;
w = w0;

uu = [];
ww = [];

f = @(u, w, I) 0.04 * u^2 + 5 * u + 140 - w + I;
g = @(u, w, a, b) a * (b * u - w);

for i = 1: N
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
title("Spiking neuron")
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