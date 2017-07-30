%%%%%%%%% TOTAL %%%%%
function pi_greco_stim_tot = identificationTotal(actualPos, actualVel, actualAcc, actualCurrent, A)

kt =  [0.7000; 1.0400; 0.7000; 0.5100; 0.5100; 0.5100];
Kt = diag(kt);
Kt(6,5) = -1;


% Ottengo tau_reali
tau_real_tot = A*Kt*actualCurrent';
tau_real_tot = tau_real_tot';

tau_real_temp_tot = [];
for i = 1 : length(actualPos)
   tau_real_temp_tot = [tau_real_temp_tot; tau_real_tot(i,:)'];
end


% Calcolo regressore totale
Wn_tot = [];
for i = 1 : length(actualPos)
   Wn_tot = [Wn_tot; phiDH(actualPos(i,:), actualVel(i,:), actualAcc(i,:))];   
end


%%%%% STIMA PARAMETRI DINAMICI
% Ottengo il regressore completo (cio? la pseudo inversa sinistra)
pseudoInvSx_tot = (Wn_tot'*Wn_tot)^(-1)*Wn_tot';


% Stimo parametri dinamici
pi_greco_stim_tot = pseudoInvSx_tot * tau_real_temp_tot; % teoricamente diverso con carico(0) 

% Verico la diversita' dei parametri nominali (definiti in carico(0)) e
% quelli stimati
tau_temp_tot = Wn_tot * pi_greco_stim_tot;
for i = 1 : length(actualPos)
    tau_stim_tot(i,1:6) = tau_temp_tot(i*6-5:i*6);
end


%%%%% GRAFICI
figure,
for i = 1 : 6
    subplot(3,2,i);
    plot(tau_stim_tot(:,i), 'b'), hold on,
    plot(tau_real_tot(:,i), 'r'), axis auto;
    title(sprintf('Giunto %d', i));
end
legend('tau\_stim\_tot', 'tau\_real _tot');

figure,
stem(pi_greco_stim_tot, 'b')
legend('pi\_stim\_tot');