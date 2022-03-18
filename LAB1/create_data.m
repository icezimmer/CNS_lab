field1 = 'Neuro_computational_feature';
value1 = ["Tonic Spiking";"Phasic Spiking";"Tonic Bursting";"Phasic Bursting";"Mixed Mode";"Spike Frequency Adaptation";"Class 1";"Class 2";"Spike Latency";"Subthreshold Oscillations";"Resonator";"Integrator";"Rebound Spike";"Rebound Burst";"Threshold Variability";"Bistability";"Depolarizing Afterpotential";"Accomodation";"Inhibition-induced Spiking";"Inhibition-induced Bursting"];

field2 = 'Parameters';
value2 = [0.02 0.2 -65 6;0.02 0.25 -65 6;0.02 0.2 -50 2;0.02 0.25 -55 0.05;0.02 0.2 -55 4;0.01 0.2 -65 8;0.02 -0.1 -55 6;0.02 0.26 -65 0;0.02 0.2 -65 6;0.05 0.26 -60 0;0.1 0.26 -60 -1;0.02 -0.1 -55 6;0.03 0.25 -60 4;0.03 0.25 -52 0;0.04 0.25 -60 4;0.1 0.26 -60 0;1 0.2 -60 -21;0.02 1 -55 4;-0.02 -1 -60 8;-0.026 -1 -45 -2];

%field3 = 'Input_signal';
%value3 = [zeros(1,10) 14*ones(1,90);zeros(1,20) 0.5*ones(1,180);zeros(1,22) 15*ones(1,198);zeros(1,20) 0.6*ones(1,180);zeros(1,16) 10*ones(1,144);zeros(1,8) 30*ones(1,77);zeros(1,30) 0.075*0:0.25:270;-0.5*ones(1,30) -0.5*ones(1,270*0.25)+0.015*0:0.25:270;zeros(1,10) 7.04*ones(1,2) zeros(1:88);zeros(1,20) 2*ones(1,4) zeros(1:176);];

field3 = 'Tau';
value3 = [0.25; 0.25; 0.25; 0.2; 0.25; 0.25; 0.25; 0.25; 0.2; 0.25; 0.25; 0.25; 0.2; 0.2; 0.25; 0.25; 0.1; 0.5; 0.5; 0.5];


input_signal = {};

I = [];
tau = value3(1); tspan = 0:tau:100;
T1=tspan(end)/10;
for t=tspan
    if (t>T1) 
        I(end+1)=14;
    else
        I(end+1)=0;
    end
end
input_signal{1} = I;

I = [];
tau = value3(2); tspan = 0:tau:100;
T1=20;
for t=tspan
    if (t>T1) 
        I(end+1)=0.5;
    else
        I(end+1)=0;
    end
end
input_signal{2} = I;


I = [];
tau = value3(3); tspan = 0:tau:100;
T1=22;
for t=tspan
    if (t>T1) 
        I(end+1)=15;
    else
        I(end+1)=0;
    end
end
input_signal{3} = I;

I = [];
tau = value3(4); tspan = 0:tau:100;
T1=20;
for t=tspan
    if (t>T1) 
        I(end+1)=0.6;
    else
        I(end+1)=0;
    end
end
input_signal{4} = I;

I = [];
tau = value3(5); tspan = 0:tau:100;
T1=tspan(end)/10;
for t=tspan
    if (t>T1) 
        I(end+1)=10;
    else
        I(end+1)=0;
    end
end
input_signal{5} = I;

I = [];
tau = value3(6); tspan = 0:tau:100;
T1=tspan(end)/10;
for t=tspan
    if (t>T1) 
        I(end+1)=30;
    else
        I(end+1)=0;
    end
end
input_signal{6} = I;

I = [];
tau = value3(7); tspan = 0:tau:100;
T1=30;
for t=tspan
    if (t>T1) 
        I(end+1)=(0.075*(t-T1)); 
    else
        I(end+1)=0;
    end
end
input_signal{7} = I;

I = [];
tau = value3(8); tspan = 0:tau:100;
T1=30;
for t=tspan
    if (t>T1) 
        I(end+1)=-0.5+(0.015*(t-T1)); 
    else
        I(end+1)=-0.5;
    end
end
input_signal{8} = I;

I = [];
tau = value3(9); tspan = 0:tau:100;
T1=tspan(end)/10;
for t=tspan
    if t>T1 && t < T1+3 
        I(end+1)=7.04;
    else
        I(end+1)=0;
    end
end
input_signal{9} = I;

I = [];
tau = value3(10); tspan = 0:tau:100;
T1=tspan(end)/10;
for t=tspan
    if (t>T1) & (t < T1+5) 
        I(end+1)=2;
    else
        I(end+1)=0;
    end
end
input_signal{10} = I;

I = [];
tau = value3(11); tspan = 0:tau:100;
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
input_signal{11} = I;

I = [];
tau = value3(12); tspan = 0:tau:100;
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
input_signal{12} = I;

I = [];
tau = value3(13); tspan = 0:tau:100;
T1=20;
for t=tspan
    if (t>T1) && (t < T1+5) 
        I(end+1)=-15;
    else
        I(end+1)=0;
    end
end
input_signal{13} = I;

I = [];
tau = value3(14); tspan = 0:tau:100;
T1=20;
for t=tspan
    if (t>T1) && (t < T1+5) 
        I(end+1)=-15;
    else
        I(end+1)=0;
    end
end
input_signal{14} = I;

I = [];
tau = value3(15); tspan = 0:tau:100;
for t=tspan
   if ((t>10) && (t < 15)) || ((t>80) && (t < 85)) 
        I(end+1)=1;
   elseif (t>70) && (t < 75)
        I(end+1)=-6;
    else
        I(end+1)=0;
    end
end
input_signal{15} = I;

I = [];
tau = value3(16); tspan = 0:tau:100;
T1=tspan(end)/8;
T2 = 216;
for t=tspan
    if ((t>T1) && (t < T1+5)) || ((t>T2) && (t < T2+5)) 
        I(end+1)=1.24;
    else
        I(end+1)=0.24;
    end
end
input_signal{16} = I;

I = [];
tau = value3(17); tspan = 0:tau:100;
T1=10;
for t=tspan
     if abs(t-T1)<1 
        I(end+1)=20;
    else
        I(end+1)=0;
    end
end
input_signal{17} = I;

I = [];
tau = value3(18); tspan = 0:tau:100;
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
input_signal{18} = I;

I = [];
tau = value3(19); tspan = 0:tau:100;
for t=tspan
    if (t < 50) || (t>250)
        I(end+1)=80;
    else
        I(end+1)=75;
    end
end
input_signal{19} = I;

I = [];
tau = value3(20); tspan = 0:tau:100;
for t=tspan
    if (t < 50) || (t>250)
        I(end+1)=80;
    else
        I(end+1)=75;
    end
end
input_signal{20} = I;

data_values = struct(field1, value1, field2, value2, field3, value3);

save(fullfile('data', 'data_values.mat'), '-struct', 'data_values')
save(fullfile('data', 'input_values.mat'), 'input_signal')