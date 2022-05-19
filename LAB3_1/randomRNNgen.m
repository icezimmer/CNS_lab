function [net, delayedInput, initialInput, initialStates, delayedTarget] = randomRNNgen(data_in, data_tg, sd, hs, lr, mc, epochs, reg)
% Ramdom generation of the net


sizeDelays = randi([sd(1),sd(2)]);
layerDelays = 0:sizeDelays;
% Create the net
net = layrecnet(layerDelays);
% Prepare the time series
[delayedInput, initialInput, initialStates, delayedTarget] = preparets(net,data_in,data_tg);
net.divideFcn = 'dividetrain';
net.trainParam.showWindow=0;
net.layers{1}.size = randi([hs(1), hs(2)]); %size of the (first) hidden layer
net.trainParam.lr = lr*rand; %learning rate for gradient descent alg
net.trainParam.mc = mc*rand; %momentum constant
net.trainParam.epochs = randi([epochs(1), epochs(2)]);
net.performParam.regularization = 10^(-randi([reg(1), reg(2)])); %for weight decay regularization
end