clear; clc;

R1 = 10e3;
R2 = 10e3;
R3 = 10e3;
R4 = 10e3;
C = 1e-6;
C1 = 1e-12;

num = R4*R2*[R1*C1 1];

den = R3*R1*[R2*C 1];

G_s = tf(num,den);

N = 1000;
w = logspace(-1, 10, N);

s = 1i*w;
P = (num(1)*s + num(2))./(den(1)*s + den(2));

P_mag = 20*log10(abs(P));

P_ph = angle(P)*180/pi;
    
figure;
subplot(2,1,1);
semilogx(w./(2*pi), P_mag, 'b-', 'LineWidth', 2);
grid on;
xlabel('Frecuencia [Hz]');
ylabel('Amplitud [dB]');
title('Diagrama de Bode en MAGNITUD');

subplot(2,1,2);
semilogx(w./(2*pi), P_ph, 'r-', 'LineWidth', 2);
grid on;
xlabel('Frecuencia [Hz]');
ylabel('Magnitud Fase [dB]');
title('Diagrama de Bode en FASE');