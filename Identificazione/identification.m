%%%%% IDENTIFICAZIONE 
function pi_greco_stim = identification(actualPos, actualVel, actualAcc, actualCurrent, A)

indiceMaster = 2812;

N = 50;
for i = 1 : N 
    puntiLabPos(i,:) = actualPos(indiceMaster+(1500*(i-1)),:); 
    puntiLabVel(i,:) = actualVel(indiceMaster+(1500*(i-1)),:); 
    puntiLabAcc(i,:) = actualAcc(indiceMaster+(1500*(i-1)),:); 
    puntiLabCurrent(i,:) = actualCurrent(indiceMaster+(1500*(i-1)),:); 
end

kt =  [0.7000; 1.0400; 0.7000; 0.5100; 0.5100; 0.5100];
Kt = diag(kt);
Kt(6,5) = -1;

%%%%% CALCOLO TAU REALI
% Ottengo tau_reali
tau_real = A*Kt*puntiLabCurrent';
tau_real = tau_real';

tau_real_temp = [];
for i = 1 : N
   tau_real_temp = [tau_real_temp; tau_real(i,:)'];
end


% Calcolo regressore totale
Wn = [];
for i = 1 : N
   Wn = [Wn; phiDH(puntiLabPos(i,:), puntiLabVel(i,:), puntiLabAcc(i,:))];   
end


%%%%% STIMA PARAMETRI DINAMICI
% Ottengo il regressore completo (cio? la pseudo inversa sinistra)
pseudoInvSx = (Wn'*Wn)^(-1)*Wn';


% Stimo parametri dinamici
pi_greco_stim = pseudoInvSx * tau_real_temp; % teoricamente diverso con carico(0) 

% Verico la diversita' dei parametri nominali (definiti in carico(0)) e
% quelli stimati
tau_temp = Wn * pi_greco_stim;
for i = 1 : N
    tau_stim(i,1:6) = tau_temp(i*6-5:i*6);
end
clear tau_temp

%%%%% GRAFICI
figure,
for i = 1 : 6
    subplot(3,2,i);
    plot(tau_stim(:,i), 'b'), hold on,
    plot(tau_real(:,i), 'r'), axis auto;
    title(sprintf('Giunto %d', i));
end
legend('tau\_stim', 'tau\_real');

figure,
stem(pi_greco_stim, 'b')
legend('pi\_stim');

clear tau_real_temp


