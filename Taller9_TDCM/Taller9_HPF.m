clear; clc;

R = 100;
L = 112.54e-3;
C = 22.5e-6;

num = [L*C 0 0];
den = [L*C R*C 1];
G = tf(num, den);

figure();
N = 1000;
w = logspace(-1, 10, N);
bode(G);

f = w/(2*pi);

s = 1i*w;

P = freqresp(G, s);
P_mag = 20*log10(abs(P));
P_ph = angle(P)*(180/pi);

    
figure('Name', "Filtro Pasa Alto");
subplot(2,1,1);
semilogx(f, P_mag(1,:), 'b-', 'LineWidth', 2);
grid on;
xlabel('Frecuencia [Hz]');
ylabel('Magnitud [dB]');
title('Diagrama de Bode en MAGNITUD');

subplot(2,1,2);
semilogx(f, P_ph(1,:), 'r-', 'LineWidth', 2);
grid on;
xlabel('Frecuencia [Hz]');
ylabel('Fase (grados)');
title('Diagrama de Bode en FASE');