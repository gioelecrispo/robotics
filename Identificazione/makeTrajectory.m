%%%%% MAKETRAJECTORY
% Questo script...
function [zita, dzita, ddzita, qData, dqData, ddqData, ist, interest, tempo] = makeTrajectory(zita, dzita, ddzita, T, plotData)


%%%%% PARAMETRI DI CONFIGURAZIONE
Ti = 0;                                  % Tempo iniziale
Tf = 2*length(zita) + 2;                 % Tempo finale
numeroGiunti = 6;                        % Numero giunti



%%%%% CALCOLO INTERVALLI TEMPORALI
N = length(zita);
% eseguo questa funzione per la prima volta: l'obiettivo e' definire gli
% intervalli temporali, aggiungendo i punti iniziale e finale.
% STEPS: Steps per gli instanti temporali, considero anche i due punti
% iniziale e finale. N sono sono i punti della traiettoria, dunque si
% avranno N-1 intervalli; dovendo aggiungere anche i punti iniziale e
% finale, in totale si hanno N+1 intervalli
steps = (Tf-Ti)/(N+1);
% Calcolo istanti temporali:
% arrotondo alla 3 cifra decimale conformemente con il tempo di campionamento;
% mi assicuro che gli istanti temporali capitino in uno degli instanti di
% campionamento.
for i = 1 : numeroGiunti
    temp_ist(:,i) = round(Ti:steps:Tf, 3);
    for j = 1 : length(temp_ist(:,i))
        if(mod(temp_ist(j,i), T) ~= 0)
            temp_ist(j,i) = temp_ist(j,i) - T/2;
        end
    end
    ist{:,i} = temp_ist(:,i);   
    interest(:,i) = 2:N+1;
end

   



%%%%% AGGIUNTA PUNTI INIZIALE E FINALE ALLA TRAIETTORIA TOTALE
% Lo faccio per tutti i numeroGiunti, avendo cura di considerare che per il
% giunto 1 e 2 i valori di posizione iniziale sono diversi da 0.
zita_iniz = [pi/2, -pi/2, 0, 0, 0, 0];
dzita_iniz = zeros(1,6);
ddzita_iniz = zeros(1,6);
temp_zita = [zita_iniz; zita; zita_iniz];
temp_dzita = [dzita_iniz; dzita; dzita_iniz];
temp_ddzita = [ddzita_iniz; ddzita; ddzita_iniz];


clear zita dzita ddzita
for i = 1 : numeroGiunti
    zita{:,i} = temp_zita(:,i);   
    dzita{:,i} = temp_dzita(:,i);  
    ddzita{:,i} = temp_ddzita(:,i);   
end


          
%%%%% PULIZIA VARIABILI
clear steps i
clear temp_zita temp_dzita temp_ddzita
% Aggiorno il numero di punti zita
N = N+2;   
% Definisco il tempo
tempo = Ti:T:Tf;                 



%%% GENERA TRAIETTORIA
% Genera traiettoria interpolando i punti in zita, dzita e ddzita; c'?
% anche un controllo sui limiti di giunto, per cui vengono salvati
% nella variabile errori.
for i = 1 : numeroGiunti
    [qData(:,i), dqData(:,i), ddqData(:,i)] = seqPointsSplines_grade5(zita{:,i}, dzita{:,i}, ddzita{:,i}, T, ist{:,i});
end

%%% GRAFICI
if plotData == 1
    grafici(qData, dqData, ddqData, zita, dzita, ddzita, tempo, ist, interest);
end






