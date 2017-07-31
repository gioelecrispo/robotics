%%%%% INIZIALIZZAZIONE
addpath(genpath('./'))     % Setta path 
T = 0.002;                 % Tempo di campionamento
% FLAGS
produciPunti = 0;          % ON/OFF  -  geneticAlgoritm          
ordinaPunti = 0;           % ON/OFF  -  ordina i punti dell'interpolazione minimizzando l'errore 
cambiaTempo = 0;           % ON/OFF  -  permette di cambiare l'intervallo temporale tra due punti
aggiungiPunti = 0;           % ON/OFF  -  permette di cambiare l'intervallo temporale tra due punti
modificaPunti = 0;         % ON/OFF  -  aggiunge i punti all'interpolazione
cambiaPunti = 0;           % ON/OFF  -  cambia i punti dell'interpolazione
trajGiaFatta = 1;          % ON/OFF  -  prendi la traiettoria già corretta
plotData = 0;              % ON/OFF  -  grafici interpolazione  
avviaVREP = 0;             % ON/OFF  -  VREP    
effettuaControllo = 0;     % ON/OFF  -  avvia simulink per il controllo
stimaParametri = 0;        % ON/OFF  -  definisce se stimare i dati o caricarli dal workspace, dato
                                        % che la computazione su tutti i punti è lenta
calcoloMatriciDinamiche = 0;
testTraiettoria = 'All';   % All/50pnt/OFF  -  verifica le tau su tutta la traiettoria/50pnt/nessuna verifica



%%%%% PUNTI TRAIETTORIA
if produciPunti == 1
    N = 50;
    time = 60*60*48;  % 2 giorni
    numIter = 1e7;
    [zita, dzita, ddzita] = geneticAlgorithm(N, time, numIter);
else
    load('punti_traiettoria');
end

%%%%% INTERPOLAZIONE
[zita, dzita, ddzita, qData, dqData, ddqData, ist, interest, tempo] = makeTrajectory(zita, dzita, ddzita, T, plotData);



%%%%% CORREGGI TRAIETTORIA
if ordinaPunti == 1
    numeroOrdinamenti = 1000;
    [zita, dzita, ddzita] = shakePoints(zita, dzita, ddzita, T, ist, numeroOrdinamenti); 
end
if cambiaTempo == 1
    [zita, dzita, ddzita, ist, interest] = changeTime(zita, dzita, ddzita, ist, interest); 
end
if aggiungiPunti == 1
    [zita, dzita, ddzita, ist, interest, qData, dqData, ddqData] = addPointsToTrajectory(zita, dzita, ddzita, qData, dqData, ddqData, T, tempo, ist, interest);
end
if modificaPunti == 1
    numGiunto = 1;
    [zita, dzita, ddzita, qData, dqData, ddqData] = changePoints(zita, dzita, ddzita, T, ist, interest, tempo, numGiunto);
end
if trajGiaFatta == 1
   load('traiettoria_interpolata.mat'); 
end




%%%%% VREP
if avviaVREP == 1
    VREP_init
    pause(1);
    slitta = 0.6;
    graphicControl = 0;
    sendTrajectoryToVRep(robot, slitta, qData, tempo, graphicControl)
end


%%%%% CONTROLLO
if effettuaControllo == 1
    progettoMotori;   % carica dati motori
    sim('schema_controllo_attritoStatico');
else
    load('after_simulink.mat');
end

%%%%% IDENTIFICAZIONE PARAMETRICI DINAMICI
load('post-lab_data.mat');
if testTraiettoria == 'All'    % Stima sui dati reali (traiettoria completa)
    if stimaParametri == 1
        pi_greco_stim_tot = identificationTotal(actualPos, actualVel, actualAcc, actualCurrent, A);
    else
        load('stima_pi_su_tutti_i_punti.mat');
    end
elseif testTraiettoria == '50pnt'  % Stima sui dati reali (punti di interesse)
    pi_greco_stim = identification(actualPos, actualVel, actualAcc, actualCurrent, A);
else % Stima sui dati simulink
    pi_greco_stim_sim = calcoloParametriDinamici(zita, dzita, ddzita, ist, interest, tau_sim, T);
end


%%%%% CALCOLO MATRICI DINAMICHE
if calcoloMatriciDinamiche == 1
    [B, Bddq, Cdq, FSta, FVist, g, Wnsym, pi_greco_stim_tot_NoAttr] = obtainDynamicMatrices(pi_greco_stim_tot);
else
    load('matrici_dinamiche.mat');
end


