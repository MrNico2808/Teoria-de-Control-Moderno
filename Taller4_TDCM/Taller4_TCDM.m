R = 100;
L = 0.1;
Cap = 1e-6;

A = [0 1; -1/(L*Cap) -R/L];
B = [0; 1/L];
C = [1/Cap 0];
D = 0;

sys = ss(A, B, C, D);

subplot(2,1,1);
step(sys);
xlabel('Time [s]');
ylabel('Vc [V]');

subplot(2,1,2);
impulse(sys);
xlabel('Time [s]');
ylabel('Vc [V]');

