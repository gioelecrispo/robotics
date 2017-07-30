%%%%% CAMBIA PUNTI MALEDETTI
function [zita, dzita, ddzita] = changePoints(zita, dzita, ddzita, qData, dqData, ddqData, T, ist, interest, tempo, numGiunto)

clear temp_p temp_v temp_a
cambiaPunti = 1;
numeroGiunti = 6;

while cambiaPunti == 1
    clear new_zita new_dzita new_ddzita
    grafici(qData, dqData, ddqData, zita, dzita, ddzita, tempo, ist, interest, numGiunto);
    puntoDes = input('Quale punto cambiare? [0. esci]  ');
    if puntoDes == 0 
        cambiaPunti = 0;
        break;
    end
    pos = input('Specifica la posizione desiderata del nuovo punto:     ');
    vel = input('Specifica la velocita desiderata nel nuovo punto:      ');
    acc = input('Specifica l accelerazione desiderata nel nuovo punto:  ');
    puntoCorr = interest(puntoDes, numGiunto);
    
    temp_p = zita{:,numGiunto};
    temp_v = dzita{:,numGiunto};
    temp_a = ddzita{:,numGiunto};
    
    if isempty(pos)
        pos = temp_p(puntoCorr);
    end
    if isempty(vel)
        vel = temp_v(puntoCorr);
    end
    if isempty(acc)
        acc = temp_a(puntoCorr);
    end

    temp_p(puntoCorr) = pos;
    temp_v(puntoCorr) = vel;
    temp_a(puntoCorr) = acc;
    new_zita = zita;
    new_dzita = dzita;
    new_ddzita = ddzita;
    new_zita{:,numGiunto} = temp_p;
    new_dzita{:,numGiunto} = temp_v;
    new_ddzita{:,numGiunto} = temp_a;
    
    % Rigenera traiettoria con i punti cambiati
    clear qData dqData ddqData
    for i = 1 : numeroGiunti
        [qData(:,i), dqData(:,i), ddqData(:,i)] = seqPointsSplines_grade5(new_zita{:,i}, new_dzita{:,i}, new_ddzita{:,i}, T, ist{:,i});
    end
    grafici(qData, dqData, ddqData, new_zita, new_dzita, new_ddzita, tempo, ist, interest, numGiunto);
    % Conferma
    choice = input('Confermare nuova traiettoria? [1. Si, 2. No] ');
    if choice == 1
        zita = new_zita;
        dzita = new_dzita;
        ddzita = new_ddzita; 
    else
        disp('Annullato.');
        clear qData dqData ddqData
        for i = 1 : numeroGiunti
            [qData(:,i), dqData(:,i), ddqData(:,i)] = seqPointsSplines_grade5(zita{:,i}, dzita{:,i}, ddzita{:,i}, T, ist{:,i});
        end
    end
    close all
end


