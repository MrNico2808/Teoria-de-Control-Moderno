clc; clear;

R = 10;
L = 1e-3;
C = 100e-6;

num = 1/(L*C);
den = [1 R/L 1/(L*C)];
G = tf(num, den);

N = 100;
w = logspace(-1, 7, N);
f = w./(2*pi);
s = 1j*w;

P = num./(den(1).*s.^2 + den(2).*s + den(3));
P_mag = 20*log10(abs(P));
P_ph = angle(P)*(180/pi);

figure();
subplot(2,1,1);
semilogx(f, P_mag, 'b-', 'LineWidth', 2);
grid on;
xlabel("Frecuencia (Hz)");
ylabel("Magnitud (dB)");
subplot(2,1,2);
semilogx(f, P_ph, 'b-', 'LineWidth', 2);
xlabel("Frecuencia (Hz)");
ylabel("Fase (Gados)");
grid on;

figure();
bode(G, w);
