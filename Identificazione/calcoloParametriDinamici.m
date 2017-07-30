%%%%% CALCOLO PARAMETRI DINAMICI 
function [] = calcoloParametriDinamici(zita, dzita, ddzita, ist, interest, tau_sim, T)

% Prendo i punti zita, dzita, ddzita e gli istanti ist di interesse
for i = 1 : 6
    temp_p(:,1) = zita{:,i};
    zita_int(:,i) = temp_p(interest(:,i));
    temp_v(:,1) = dzita{:,i};
    dzita_int(:,i) = temp_v(interest(:,i));
    temp_a(:,1) = ddzita{:,i};
    ddzita_int(:,i) = temp_a(interest(:,i));
    temp_ist(:,1) = ist{:,i};
    ist_int(:,i) = temp_ist(interest(:,i));
    clear temp_p temp_v temp_a temp_ist
end


%%%%% CALCOLO TAU NOMINALI
% Parametri dinamici nominali
pi_greco_nom = carico(0);


% Creo il regressore completo da cui ottenere la pseudoInvSx. 
% Wn sara' una matrice rettangolare alta (piu' righe che colonne)
N = length(interest(:,1));
Wn = [];
for i = 1 : N
   Wn = [Wn; phiDH(zita_int(i,:), dzita_int(i,:), ddzita_int(i,:))];   
end
% tau_nom: le tau ottenute sono comprensive dell'attrito statico.
tau_temp =  Wn * pi_greco_nom;
for i = 1 : N
    tau_nom(i,1:6) = tau_temp(i*6-5:i*6);
end
clear tau_temp




%%%%% STIMA PARAMETRI DINAMICI
% Ottengo il regressore completo (cio? la pseudo inversa sinistra)
pseudoInvSx = (Wn'*Wn)^(-1)*Wn';

% Prendo le tau di simulink, che dovrebbero essere quelle "reali", negli
% istanti d'interesse.
tau_simulink = [];
for i = 1 : N
    for j = 1 : 6 
        temp(1,j) = tau_sim(round(ist_int(i,j)/T)+1, j);
    end
    tau_simulink = [tau_simulink; temp'];
end


pi_greco_stim = pseudoInvSx * tau_simulink; % teoricamente diverso con carico(0) 

% Verico la diversita' dei parametri nominali (definiti in carico(0)) e
% quelli stimati
tau_temp = Wn * pi_greco_stim;
for i = 1 : N
    tau_stim(i,1:6) = tau_temp(i*6-5:i*6);
end

%%%%% GRAFICI
figure,
for i = 1 : 6
    subplot(3,2,i);
    plot(tau_stim(:,i)), hold on,
    plot(tau_nom(:,i)), axis auto;
    title(sprintf('Giunto %d', i));
end

figure,
stem(pi_greco_nom, 'r'), hold on,
stem(pi_greco_stim, 'b')












