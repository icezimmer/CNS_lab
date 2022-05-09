function [net, delayedInput, initialInput, initialStates, delayedTarget] = randomIDNNgen(data_in, data_tg, sd, hs, lr, mc, epochs, reg)
% Random generation of the net

sizeDelays = randi([sd(1),sd(2)]);
inputDelays = 0:sizeDelays;
% Create the net
net = timedelaynet(inputDelays);
% Prepare the time series
[delayedInput, initialInput, initialStates, delayedTarget] = preparets(net,data_in,data_tg);
net.divideFcn = 'dividetrain';
net.trainParam.showWindow=0;
net.layers{1}.size = randi([hs(1), hs(2)]);
net.trainParam.lr = lr(1)+(lr(2)+lr(2))*rand -lr(2); %learning rate for gradient descent alg
net.trainParam.mc = mc(1)+(mc(2)+mc(2))*rand -mc(2); %momentum constant
net.trainParam.epochs = randi([epochs(1), epochs(2)]); %maximum number of epochs
net.performParam.regularization = reg(1)+(reg(2)+reg(2))*rand -reg(2); %for weight decay regularization
end

