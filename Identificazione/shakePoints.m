%%%%% RANDOMIZZO PUNTI
function [zita, dzita, ddzita] = shakePoints(zita, dzita, ddzita, T, ist, numeroIterazioni)


if ~exist('numeroIterazioni', 'var')
    numeroIterazioni = 1000;
end
N = length(zita{:,1}); 
numeroGiunti = 6;

%%%%% LIMITI
[limiti_giunto_inf, limiti_giunto_sup, limiti_veloc, limiti_accel] = limiti_manipolatore();



% CALCOLO ERRORI NELLA CONFIGURAZIONE INIZIALE
% Ottengo la traiettoria
for h = 1 : numeroGiunti
    [qData(:,h), dqData(:,h), ddqData(:,h)] = seqPointsSplines_grade5(zita{:,h}, dzita{:,h}, ddzita{:,h}, T, ist{:,h});
end
    
% Calcolo errori
errors_init = 0;
for h = 1 : numeroGiunti
    errors_init = errors_init + length(find(qData(:,h) > limiti_giunto_sup(h) | qData(:,h) < limiti_giunto_inf(h)));
    errors_init = errors_init + length(find(dqData(:,h) > limiti_veloc(h) | dqData(:,h) < limiti_veloc(h)));
    errors_init = errors_init + length(find(ddqData(:,h) > limiti_accel(h) | ddqData(:,h) < limiti_accel(h)));
end


% CALCOLO ERRORI PER TUTTE LE ALTRE CONFIGURAZIONI (SCELTE RANDOM)
errors = zeros(numeroIterazioni, 1);
for i = 1 : numeroIterazioni
    randomScambi = randi([10 50], 1);
    for j = 1 : randomScambi
        indici = randi([2 N-1], 1, 2);
        
        zitaArray = cell2mat(zita);
        dzitaArray = cell2mat(dzita);
        ddzitaArray = cell2mat(ddzita);
        temp_zita = zitaArray;
        temp_dzita = dzitaArray;
        temp_ddzita = ddzitaArray;
        
        temp_zita(indici(1),:) = zitaArray(indici(2),:);
        temp_zita(indici(2),:) = zitaArray(indici(1),:);
        temp_dzita(indici(1),:) = dzitaArray(indici(2),:);
        temp_dzita(indici(2),:) = dzitaArray(indici(1),:);
        temp_ddzita(indici(1),:) = ddzitaArray(indici(2),:);
        temp_ddzita(indici(2),:) = ddzitaArray(indici(1),:);
        
        for k = 1 : numeroGiunti
            zita{:,k} = temp_zita(:,k);
            dzita{:,k} = temp_dzita(:,k);
            ddzita{:,k} = temp_ddzita(:,k);
        end
    end
    
    for h = 1 : numeroGiunti
        [qData(:,h), dqData(:,h), ddqData(:,h)] = seqPointsSplines_grade5(zita{:,h}, dzita{:,h}, ddzita{:,h}, T, ist{:,h});
    end
    
    % Calcolo errori
    errors(i) = 0;
    for h = 1 : numeroGiunti
        errors(i) = errors(i) + length(find(qData(:,h) > limiti_giunto_sup(h) | qData(:,h) < limiti_giunto_inf(h)));
        errors(i) = errors(i) + length(find(dqData(:,h) > limiti_veloc(h) | dqData(:,h) < limiti_veloc(h)));
        errors(i) = errors(i) + length(find(ddqData(:,h) > limiti_accel(h) | ddqData(:,h) < limiti_accel(h)));
    end
    
    best_zita(i,:) = zita;
    best_dzita(i,:) = dzita;
    best_ddzita(i,:) = ddzita;
end

% Valuta errore minore
errors = [errors_init; errors];
[val, min_err] = min(errors);
m_zita = best_zita(min_err,:);
m_dzita = best_dzita(min_err,:);
m_ddzita = best_ddzita(min_err,:);


zita = m_zita;
dzita = m_dzita;
ddzita = m_ddzita;
