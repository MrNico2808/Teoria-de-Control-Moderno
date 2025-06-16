
G1 = tf(3, [1 0]);
G2 = tf(1, [1 0 1]);
H1 = 3;

Gs = series(G1, G2);

cl = feedback(Gs, H1);

step(cl, 20);


