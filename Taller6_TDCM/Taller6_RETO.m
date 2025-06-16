clc; clear;
%Constantes RLC
R = 5;
L = 0.1;
C = 220e-6;

%Constantes PID
Kp = 10;
Ki = 1000;
Kd = 0.05;

%Sistema RLC
num = 1/(L*C);
den = [1 R/L 1/(L*C)];
sys = tf(num, den);

%Proporcional
sys_p = tf(Kp, 1);

%Integral
sys_i = tf(Ki, [1 0]);

%Derivativo
sys_d = tf([Kd 0], 1);

PID = parallel(parallel(sys_p, sys_i), sys_d);
sys_ol = series(PID, sys);
sys_fb = feedback(sys_ol, 1);

%Ecuación Caractreistica
ec_car = sys_fb.Denominator{1};

figure();
subplot(2,1,1);
step(sys_fb);
subplot(2,1,2);
pzmap(sys_fb);

