R = 5;
L = 0.1;
C = 220e-6;

num = 1/(L*C);
den = [1 R/L 1/(L*C)];

Kp = linspace(1,100,4);