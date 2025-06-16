clc; clear;

R = 22;
L = 500e-6;
C = 220e-6;

%Constantes Ejercicio
Mp = 0.25;
tss = 0.05;

%Funcion Vo/Vi
G1 = tf(1, [L*C R*C 1]);
%Ceros y Polos
ceros = roots(G1.Numerator{1});
polos = roots(G1.Denominator{1})

figure();
subplot(2,1,1);
step(G1);
subplot(2,1,2);
rlocus(G1);

%Coeficientes para Compensador
coef_amor = log(1/Mp)/sqrt(pi^2 + log(1/Mp)^2);
Wn = 4/(tss*coef_amor);
%Polos Compensador
EC_compensador = [1 2*Wn*coef_amor Wn^2];
polos_compensador = roots(EC_compensador)

m = (imag(polos_compensador(1)) - 0)/(real(polos_compensador(1) - polos(2)));
theta1 = pi + atan(m);
theta4 = pi - theta1;
%Componentes real de z y p
P_x = real(polos_compensador(1)) - imag(polos_compensador(1))/tan(theta4);
Z_x = min(polos);
%Funcion COMPENSADOR
compensador = tf([1 abs(Z_x)], [1 abs(P_x)])

%Kc*compensador*Gs*Hs=1
Kc_sys = 1/series(series(compensador, G1), 1);
Kc = abs(evalfr(Kc_sys, polos_compensador(1)));
%G compensada
G_compensado = series(Kc*compensador, G1);


figure();
subplot(2,1,1); hold on; grid on;
[y1, t1] = step(G1, 0:0.001:0.1);
[y2, t2] = step(feedback(G_compensado, 1), 0:0.001:0.1);
plot(t1, y1, 'b-');
plot(t2, y2, 'r-')
subplot(2,1,2); hold on; grid on;
plot(real(polos_compensador), imag(polos_compensador), 'rx');
plot(P_x, 0, 'rx');
plot(Z_x, 0,'ro');
rlocus(feedback(G_compensado, 1));

figure(); hold on;
step(feedback(G_compensado, 1));
figure(); hold on;
plot(real(polos_compensador), imag(polos_compensador), 'rx');
rlocus(G1);
figure(); hold on;
plot(real(polos_compensador), imag(polos_compensador), 'rx');
rlocus(G_compensado);


