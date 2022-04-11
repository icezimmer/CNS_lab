function [states,firings] = lsm(input, Ne, Ni, win_e, win_i, w_e, w_i, bias, fun)
% Created by Eugene M. Izhikevich, February 25, 2003
% slightly modified by Claudio Gallicchio, 2021

% Excitatory neurons    Inhibitory neurons
re=rand(Ne,1);          ri=rand(Ni,1);
a=[0.02*ones(Ne,1);     0.02+0.08*ri];
b=[0.2*ones(Ne,1);      0.25-0.05*ri];
c=[-65+15*re.^2;        -65*ones(Ni,1)];
d=[8-6*re.^2;           2*ones(Ni,1)];

% Scaling of input connections
U=[win_e * ones(Ne,1);   win_i * ones(Ni,1)];
% The following matrix contains the recurrent (random) weights
S=[w_e*rand(Ne+Ni,Ne),  -w_i*rand(Ne+Ni,Ni)];

v=-65*ones(Ne+Ni,1);    % Initial values of v
u=b.*v;                 % Initial values of u
firings=[];             % Spike timings

states = []; % Here we construct the matrix of reservoir states

for t=1:size(input,2)            % simulation of 1000 ms
  % we don't need random thalamic input:
  % I=[5*randn(Ne,1);2*randn(Ni,1)]; % thalamic input
  % we use instead the input from the external time series!
  I=input(t) * U;
  fired=find(v>=30);    % indices of spikes
  firings=[firings; t+0*fired,fired];
  v(fired)=c(fired);
  u(fired)=u(fired)+d(fired);
  
  I=I+sum(S(:,fired),2); % here the recurrent input is added
  v=v+0.5*(0.04*v.^2+5*v+140-u+I); % step 0.5 ms
  v=v+0.5*(0.04*v.^2+5*v+140-u+I); % for numerical
  u=u+a.*(b.*v-u);                 % stability
  
  states = [states fun(bias, v)];
  %states = [states (v>=30)];  % neuron is active or not
end
% For each time t plot the active neurons
% plot(firings(:,1),firings(:,2),'.');