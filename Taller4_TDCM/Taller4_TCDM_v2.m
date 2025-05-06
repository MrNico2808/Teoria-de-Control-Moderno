% Parámetros del circuito
R = 100; % Resistencia (ohmios)
L = 0.1; % Inductancia (henrios)
Cap = 1e-6; % Capacitancia (faradios)
A = [0 1; -1/(L*Cap) -R/L];  % Matriz de Estado
B = [0; 1/L];  % Matriz de Entrada
C = [1/Cap 0];  % Matriz de Salida
D = 0;  % Matriz de Transferencia directa


% Aquí el código para definir el espacio de estados
function dx = modelRLC(t, x, A, B, u)
    dx = A * x + B * u;  % Ecuación de Estado
end 

ts = 0.015;
% Tiempo de simulación
tspan = [0 ts];
u = 1;
x0 = [0; 0];
% Voltaje de entrada Condiciones iniciales
[t, X] = ode45(@(t,x) modelRLC(t, x, A, B, u), tspan, x0);
y = C * X.' + D * u;

plot(t,y);
ylabel("Voltaje Capacitor [V]");
xlabel("Time[S]");
grid on;

ti = 0:0.0001:5*ts;         % Vector de tiempo desde 0 hasta 5ts con paso 0.0001
N = length(ti);             % Número total de pasos de tiempo

size_y = int32(N/5);        % Tamaño base para tramos de la señal
s1 = linspace(0, 3, size_y);
s2 = ones(1, size_y)*3;
s3 = ones(1, size_y)*5;
s4 = linspace(5, 2, size_y);
s5 = ones(1, N-4*size_y); 

u = [s1 s2 s3 s4 s5]';      % Señal arbitraria

n = size(A, 1);             % Asigna automáticamente el número de estados según A
X = zeros(N, n);            % n = número de estados, debes definirlo antes
X(1,:) = 0;                 % Condición inicial

t = zeros(N,1);             % Vector de tiempo de la solucion
t(1) = ti(1);               % Tiempo inicial

for k = 2:N
    [tk, Xk] = ode45(@(t,x) modelRLC(t, x, A, B, u(k)), ...
        [ti(k-1), ti(k)], X(k-1,:));
    t(k) = tk(end);
    X(k,:) = Xk(end,:);
end

Y = zeros(N, size(C,1)); 

for k = 1:N
    Y(k,:) = C * X(k,:)' + D * u(k);
end

figure;
plot(t, Y, 'b', 'LineWidth', 1.5); hold on;
plot(t, u, 'r--', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Respuesta a una señal arbitraria');
legend('y(t)', 'u(t)');
grid on;

