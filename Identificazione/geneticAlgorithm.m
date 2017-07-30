function [zita, dzita, ddzita] = geneticAlgorithm(N, time, numIter) 
%%%%%% GENETIC ALGORITMH
% N         ->     numero punti
% time      ->     tempo per cui deve girare il ga
% numIter   ->     numero massimo di iterazioni dell'algoritmo genetico

if ~exist('N', 'var')
    N = 50;
end
if ~exist('time', 'var')
    time = 60*1;       % 1 minuto
end
if ~exist('numIter', 'var')
    numIter = 1e7;
end

%%%%% LIMITI
% Limit di giunto, velocita' e accelerazione (ristretti per la cella e per
% evitare problemi in fase di interpolazione);
lim_giunto_inf = [0.2       -2.0689   -1.1963     -3.4652   -2.0689   -6.2832];
lim_giunto_sup = [2.7671    -1.5090    1.0217      3.4652    2.0689    6.2832];
limiti_veloc = [2.2    2.5   2.71   7    6  9];
limiti_accel = [8   8  8   15   19  19];
% Limiti totali
limiti_inf = [lim_giunto_inf, -limiti_veloc, -limiti_accel];
limiti_sup = [lim_giunto_sup, limiti_veloc, limiti_accel];


%%%%% GENETIC ALGORITHM
options = gaoptimset('TimeLimit', time, 'Generations', numIter, 'UseParallel', 1, 'TolCon', 1e-10, 'Display', 'iter');

[points, ~, ~, ~] = ga(@optimizeFunction, N*18, [], [], [], [], repmat(limiti_inf,1,N), repmat(limiti_sup,1,N), [], options);


%%%%% SCOMPATTO LA SOLUZIONE
% Ottengo le N soluzioni ottime
for i = 1 : N 
    p(i,:) = points(1,(i*18-17):(i*18-18)+18);
end

% Dalle soluzioni ricavo posizioni, velocita' e accelerazioni
for i = 1 : N
    zita(i,:) = p(i,1:6); 
    dzita(i,:) = p(i,7:12); 
    ddzita(i,:) = p(i,13:18); 
end


save(strcat('punti_traiettoria_new', '.mat'));
disp('zita, dzita, ddzita salvati in "punti_traiettoria_new.mat"');
