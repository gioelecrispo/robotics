function graficiInterval(qData, dqData, ddqData, ist1, ist2, i)
% Funzione che grafica il singolo intervallo del giunto i-esimo,
% specificati ist1, ist2 e i

[limiti_giunto_inf, limiti_giunto_sup, limiti_veloc, limiti_accel] = limiti_manipolatore(); 


T = 0.002;
tempo = ist1:T:ist2;
i1 = round(ist1/T)+1;
i2 = round(ist2/T)+1;


figure('units','normalized','outerposition',[0 0 1 1]),

% Posizione
subplot(3,1,1);
plot(tempo, qData(i1:i2,i)), hold on

plot(tempo, ones(size(tempo)) * limiti_giunto_inf(i), 'r--');
plot(tempo, ones(size(tempo)) * limiti_giunto_sup(i), 'r--');
xlim([ist1 ist2]);
strTitlePosiz = sprintf('Posiz - giunto %d', i);
title(strTitlePosiz);

% Velocita'
subplot(3,1,2);
plot(tempo, dqData(i1:i2,i)), hold on, axis auto

plot(tempo, ones(size(tempo)) * -limiti_veloc(i), 'r--');
plot(tempo, ones(size(tempo)) * limiti_veloc(i), 'r--');
xlim([ist1 ist2]);
strTitleVeloc = sprintf('Veloc - giunto %d', i);
title(strTitleVeloc);

% Accelerazione
subplot(3,1,3);
plot(tempo, ddqData(i1:i2,i)), hold on, axis auto
plot(tempo, ones(size(tempo)) * -limiti_accel(i), 'r--');
plot(tempo, ones(size(tempo)) * limiti_accel(i), 'r--');
xlim([ist1 ist2]);
strTitleAccel = sprintf('Accel - giunto %d', i);
title(strTitleAccel);

