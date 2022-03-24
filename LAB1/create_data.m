field1 = 'Neuro_computational_feature';
value1 = ["Tonic Spiking";"Phasic Spiking";"Tonic Bursting";"Phasic Bursting";
    "Mixed Mode";"Spike Frequency Adaptation";"Class 1";"Class 2";
    "Spike Latency";"Subthreshold Oscillations";"Resonator";"Integrator";
    "Rebound Spike";"Rebound Burst";"Threshold Variability";"Bistability";
    "Depolarizing Afterpotential";"Accomodation";"Inhibition-induced Spiking";"Inhibition-induced Bursting"];

field2 = 'Initial_conditions';
value2 = [-70 -14;
    -64 -16;
    -70 -14;
    -64 -16;
    -70 -14;
    -70 -14;
    -60 6;
    -64 -16.64;
    -70 -14;
    -62 -16.12;
    -62 -16.12;
    -60 6;
    -64 -16;
    -64 -16;
    -64 -16;
    -61 -15.86;
    -70 -14;
    -65 -16;
    -63.8 63.8;
    -63.8 63.8];

field3 = 'Parameters';
value3 = [0.02 0.2 -65 6;
    0.02 0.25 -65 6;
    0.02 0.2 -50 2;
    0.02 0.25 -55 0.05;
    0.02 0.2 -55 4;
    0.01 0.2 -65 8;
    0.02 -0.1 -55 6;
    0.2 0.26 -65 0;
    0.02 0.2 -65 6;
    0.05 0.26 -60 0;
    0.1 0.26 -60 -1;
    0.02 -0.1 -55 6;
    0.03 0.25 -60 4;
    0.03 0.25 -52 0;
    0.03 0.25 -60 4;
    0.1 0.26 -60 0;
    1 0.2 -60 -21;
    0.02 1 -55 4;
    -0.02 -1 -60 8;
    -0.026 -1 -45 -2];

field4 = 'Tau';
value4 = [0.25; 0.25; 0.25; 0.2; 0.25; 0.25; 0.25; 0.25; 0.2; 0.25; 0.25; 0.25; 0.2; 0.2; 0.25; 0.25; 0.1; 0.5; 0.5; 0.5];

data_values = struct(field1, value1, field2, value2, field3, value3, field4, value4);


input_signals = {};

%%%%%%%%%%%%%%% (A) tonic spiking %%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(1); tspan = 0:tau:100;
T1=tspan(end)/10;
for t=tspan
    if (t>T1) 
        I(end+1)=14;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%%%%% (B) phasic spiking %%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(2); tspan = 0:tau:200;
T1=20;
for t=tspan
    if (t>T1) 
        I(end+1)=0.5;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%% (C) tonic bursting %%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(3); tspan = 0:tau:220;
T1=22;
for t=tspan
    if (t>T1) 
        I(end+1)=15;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%% (D) phasic bursting %%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(4); tspan = 0:tau:200;
T1=20;
for t=tspan
    if (t>T1) 
        I(end+1)=0.6;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%% (E) mixed mode %%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(5); tspan = 0:tau:160;
T1=tspan(end)/10;
for t=tspan
    if (t>T1) 
        I(end+1)=10;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%%% (F) spike freq. adapt %%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(6); tspan = 0:tau:85;
T1=tspan(end)/10;
for t=tspan
    if (t>T1) 
        I(end+1)=30;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%%%% (G) Class 1 exc. %%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(7); tspan = 0:tau:300;
T1=30;
for t=tspan
    if (t>T1) 
        I(end+1)=(0.075*(t-T1)); 
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%%%%% (H) Class 2 exc. %%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(8); tspan = 0:tau:300;
T1=30;
for t=tspan
    if (t>T1) 
        I(end+1)=-0.5+(0.015*(t-T1)); 
    else
        I(end+1)=-0.5;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%%%% (I) spike latency %%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(9); tspan = 0:tau:100;
T1=tspan(end)/10;
for t=tspan
    if t>T1 && t < T1+3 
        I(end+1)=7.04;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%%%% (J) subthresh. osc. %%%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(10); tspan = 0:tau:200;
T1=tspan(end)/10;
for t=tspan
    if (t>T1) && (t < T1+5) 
        I(end+1)=2;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%%%%% (K) resonator %%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(11); tspan = 0:tau:400;
T1=tspan(end)/10;
T2=T1+20;
T3 = 0.7*tspan(end);
T4 = T3+40;
for t=tspan
    if ((t>T1) && (t < T1+4)) || ((t>T2) && (t < T2+4)) || ((t>T3) && (t < T3+4)) || ((t>T4) && (t < T4+4)) 
        I(end+1)=0.65;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%%% (L) integrator %%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(12); tspan = 0:tau:100;
T1=tspan(end)/11;
T2=T1+5;
T3 = 0.7*tspan(end);
T4 = T3+10;
for t=tspan
    if ((t>T1) && (t < T1+2)) || ((t>T2) && (t < T2+2)) || ((t>T3) && (t < T3+2)) || ((t>T4) && (t < T4+2)) 
        I(end+1)=9;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%%%% (M) rebound spike %%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(13); tspan = 0:tau:200;
T1=20;
for t=tspan
    if (t>T1) && (t < T1+5) 
        I(end+1)=-15;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%%%% (N) rebound burst %%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(14); tspan = 0:tau:200;
T1=20;
for t=tspan
    if (t>T1) && (t < T1+5) 
        I(end+1)=-15;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%%%%% (O) thresh. variability %%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(15); tspan = 0:tau:100;
for t=tspan
   if ((t>10) && (t < 15)) || ((t>80) && (t < 85)) 
        I(end+1)=1;
   elseif (t>70) && (t < 75)
        I(end+1)=-6;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%% (P) bistability %%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(16); tspan = 0:tau:300;
T1=tspan(end)/8;
T2 = 216;
for t=tspan
    if ((t>T1) && (t < T1+5)) || ((t>T2) && (t < T2+5)) 
        I(end+1)=1.24;
    else
        I(end+1)=0.24;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%% (Q) DAP %%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(17); tspan = 0:tau:50;
T1=10;
for t=tspan
     if abs(t-T1)<1 
         I(end+1)=20;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%% (R) accomodation %%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(18); tspan = 0:tau:400;
for t=tspan
    if (t < 200)
        I(end+1)=t/25;
    elseif t < 300
        I(end+1)=0;
    elseif t < 312.5
        I(end+1)=(t-300)/12.5*4;
    else
        I(end+1)=0;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%% (S) inhibition induced spiking %%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(19); tspan = 0:tau:350;
for t=tspan
    if (t < 50) || (t>250)
        I(end+1)=80;
    else
        I(end+1)=75;
    end
end
input_signals{end+1} = I;

%%%%%%%%%%%%%% (T) inhibition induced bursting %%%%%%%%%%%%%%%%%%%%%%%%%%
I = [];
tau = data_values.Tau(20); tspan = 0:tau:350;
for t=tspan
    if (t < 50) || (t>250)
        I(end+1)=80;
    else
        I(end+1)=75;
    end
end
input_signals{end+1} = I;


save(fullfile('data', 'data_values.mat'), '-struct', 'data_values')
save(fullfile('data', 'input_values.mat'), 'input_signals')