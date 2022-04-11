data = load("lab2_2_data.mat");

p0 = data.p0;
p1 = data.p1;
p2 = data.p2;

input_patterns = [p0, p1, p2];
memory_pattern = 2;
distortion_prop = 0;
[states, measures, energy] = hopfield(input_patterns, memory_pattern+1, distortion_prop);