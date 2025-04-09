clear;
datos = readtable('data_motor.csv');

tiempo = datos.time_t_;
ex_sgn = datos.ex_signal_u_;
respuesta = datos.system_response_y_;

% Indice del primer valor donde la respuesta tiene un valor dentro del
% 2% del valor final
i_max = find(respuesta < 0.98*respuesta(end), 1, "last") + 1;

% Linea 100%
max_respuesta = mean(respuesta(i_max:end));

% Linea Base
min_respuesta = min(respuesta);

% Punto 0.284
P1_y = max_respuesta * 0.284;
P1_x  = tiempo(find(respuesta < 0.284*max_respuesta,  1, 'last') + 1);

% Punto 0.6321
P2_y = max_respuesta*0.6321;
P2_x  = tiempo(find(respuesta < 0.6321*max_respuesta,  1, 'last') + 1);

% Recta Tangente
m_tangente = (P2_y - P1_y)/(P2_x - P1_x);
b_tangente = P1_y - m_tangente*P1_x;
y_tangente = m_tangente*tiempo(1:i_max) + b_tangente;

%%%%%%%%%%%%%%%%%%

K = (max_respuesta - min_respuesta)/(max(ex_sgn) - min(ex_sgn)); % Ganancia
theta = tiempo(find(diff(ex_sgn) ~= 0) + 1); % Momento en que empieza el transitorio

% Ziegler y Nichols

% Encontrar el instante en que la respuesta se mantiene estable
tau1 = respuesta(i_max) - theta;

% FODT
G1 = tf(K,[tau1 1], 'InputDelay', theta);
[y1, x1] = lsim(G1, ex_sgn, tiempo);

%%%%%%%%%%%%%%%%%%%

% Miller

% Momento en el que la respuesta alcanza el 63.21% del valor maximo
tau2 = tiempo(find(respuesta < 0.6321*max_respuesta, 1, 'last') + 1) - theta;

% FODT
G2 = tf(K,[tau2 1], 'InputDelay', theta);
[y2, x2] = lsim(G2, ex_sgn, tiempo);

%%%%%%%%%%%%%%%%%%%

% Analítico

tau3 = 1.5 * (P2_x - P1_x);
theta3 = P2_x - tau3;

G3 = tf(K,[tau3 1], 'InputDelay', theta3);
[y3, x3] = lsim(G3, ex_sgn, tiempo);

%%%%%%%%%%%%%%%%%%%

% Gráfica
hold on;
x = xlim;

plot(x, [max_respuesta max_respuesta], 'b--');  % 100%
plot(x, [min_respuesta min_respuesta], 'b--');  % Base
plot(tiempo(1:i_max), y_tangente, 'b--');       % Tangente
plot(tiempo, ex_sgn, 'r-');                     % Externa
plot(tiempo, respuesta, 'k-');                  % Respuesta
plot(x1, y1, 'g-');                             % Ziegler & Nichols
plot(x2, y2, 'y-');                             % Miller
plot(x3, y3, 'm-');                             % Analitico

%legend("Linea 100%", "Linea Base", "Linea Tangente", "Señal Externa", "Respuesta");

legend("Linea 100%", "Linea Base", "Linea Tangente", ...
    "Señal Externa", "Respuesta", "Ziegler & Nichols", ...
    "Miller", "Analítico");

xlabel("Tiempo (t)");
ylabel("Amplitud");
grid on;
hold off;
