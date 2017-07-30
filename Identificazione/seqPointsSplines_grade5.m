function [qData, dqData, ddqData] = seqPointsSplines_grade5(zita, dzita, ddzita, T, ist)
%%% seqPointsPolynomial_grade5
% Questa funzione genera la traiettoria tramite polinomi interpolanti di
% grado 5 (spline), a partire da una sequenza di punti di "misura".
% I vettori da dare in input e quelli restituiti in output sono vettori
% colonna.
% POSIZIONI IN RAD
%
%  Input:
%       - zita:       measurement points (posizione); devono essere 3 almeno
%       - dzita:      measurement points (velocita'); devono essere 3 almeno
%       - ddzita:     measurement points (accelerazione); devono essere 3 almeno
%       - T:          tempo di campionamento
%       - ist:        vettore degli istanti temporali che tiene conto del 
%                     soddisfacimento dei limiti di giunto.
%  Output:
%       - qData:      posizione ai giunti
%       - dqData:     velocita' ai giunti
%       - ddqData:    accelerazione ai giunti
%
%%%%%%%%
%%%%% PARAMETRI DI CONFIGURAZIONE
N = length(zita);                 % Numero di punti zita
k = 5;                            % Grado delle spline




%%%%% DEFINISCO I POLINOMI
% COSTRUZIONE POLINOMI con spapi
for i = 1 : N-1
    x = [ist(i), ist(i), ist(i), ist(i+1), ist(i+1), ist(i+1)];
    y = [zita(i), dzita(i), ddzita(i), zita(i+1), dzita(i+1), ddzita(i+1)];
    polinomio(i) = spapi(optknt(x, k), x, y); 
    dPolinomio(i) = fnder(polinomio(i));
    ddPolinomio(i) = fnder(dPolinomio(i));
end



%%%%% DATA
% Riorganizzazione dei dati di output.
% Salvo i dati nelle matrici posiz, veloc e accel per poter effettuare un
% controllo sui limiti successivamente.
for i = 1 : N-1
    clear time
    time = ist(i):T:ist(i+1)-T;
    posiz{:,i} = fnval(polinomio(i), time)';
    veloc{:,i} = fnval(dPolinomio(i), time)';
    accel{:,i} = fnval(ddPolinomio(i), time)';
end
posiz{:,N-1} = [posiz{:,N-1}; fnval(polinomio(i), ist(end))'];
veloc{:,N-1} = [veloc{:,N-1}; fnval(dPolinomio(i), ist(end))'];
accel{:,N-1} = [accel{:,N-1}; fnval(ddPolinomio(i), ist(end))'];


qData = [];
dqData = [];
ddqData = [];
for i = 1 : N-1
   qData = [qData; posiz{:,i}]; 
   dqData = [dqData; veloc{:,i}]; 
   ddqData = [ddqData; accel{:,i}]; 
end




%%%%% CONTROLLO LIMITI DI GIUNTO
% Sebbene i punti dati in input siano conformi ai limiti di giunto,
% potrebbe accadere che i limiti di giunto non siano rispettati tra un
% punto e l'altro.
% POSIZIONI IN RAD
%[limiti_giunto_inf, limiti_giunto_sup, limiti_veloc, limiti_accel] = limiti_manipolatore(); 


% clear errori
% for i = 1 : N-1
%     % Controllo posizione
%     minPosiz = min(posiz{:,i});
%     maxPosiz = max(posiz{:,i});
%     if minPosiz < limiti_giunto_inf(numGiunto) 
%         errori(i,1) = minPosiz - limiti_giunto_inf(numGiunto); % Registro lo scarto tra i due valori
%     elseif maxPosiz > limiti_giunto_sup(numGiunto)
%         errori(i,1) = maxPosiz - limiti_giunto_sup(numGiunto); % Registro lo scarto tra i due valori
%     else
%         errori(i,1) = 0;
%     end
%         
%     % Controllo velocita'
%    	velocMaggiore = max(veloc{:,i});
%     velocMinore = min(veloc{:,i});
%     maxVeloc = max([abs(velocMaggiore); abs(velocMinore)]);
%     if maxVeloc > limiti_veloc(numGiunto) 
%         errori(i,2) = maxVeloc - limiti_veloc(numGiunto);   % Registro lo scarto tra i due valori
%     else
%         errori(i,2) = 0;
%     end
%     
%     % Controllo accelerazione
%     accelMaggiore = max(accel{:,i});
%     accelMinore = min(accel{:,i});
%     maxAccel = max([abs(accelMaggiore); abs(accelMinore)]);
%     if maxAccel > limiti_accel(numGiunto) 
%         errori(i,3) = maxAccel - limiti_accel(numGiunto);   % Registro lo scarto tra i due valori
%     else
%         errori(i,3) = 0;
%     end
% 
% end
% errori = 0;



