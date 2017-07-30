%%%%% GESTIONE TEMPO
function [zita, dzita, ddzita, ist, interest] = changeTime(zita, dzita, ddzita, ist, interest, Ti, Tf, T) 
cambiaDurata = 1;
numeroGiunti = 6;
N = 50;
if cambiaDurata == 1
    tempo = Ti:T:Tf;
    clear qData dqData ddqData
    for i = 1 : numeroGiunti
        [qData(:,i), dqData(:,i), ddqData(:,i)] = seqPointsSplines_grade5(zita{:,i}, dzita{:,i}, ddzita{:,i}, T, ist{:,i});
    end
    grafici(qData, dqData, ddqData, zita, dzita, ddzita, tempo, ist, interest, 1);
    for i = 1 : N-1
        addTime = input('Di quanto allungare? [X. quantita da aggiungere; 0. intervallo successivo] ');
        temp_ist = ist{:,i};
        %disp('Vecchi intervalli: '); disp(ist);
        % Logica di incremento: prendo l'intervallo i-esimo da
        % modificare e aggiungo "addTime" ad esso; modifico
        % tutti gli altri intervalli successivi e il tempo
        % finale tf.
        vecchioIntervallo = temp_ist(i+1) - temp_ist(i);
        nuovoIntervallo = vecchioIntervallo + addTime;
        nuovoIntervallo = round(nuovoIntervallo, 3);
        if mod(nuovoIntervallo, T) ~= 0
            nuovoIntervallo = nuovoIntervallo - T/2;
        end
        incremento = nuovoIntervallo - vecchioIntervallo;
        for k = i+1 : N
            temp_ist(k) = temp_ist(k) + incremento;
        end
        Tf_new = Tf + incremento;
        disp('Nuovi intervalli: '); disp(temp_ist);
        for i = 1 : numeroGiunti
            new_ist{:,i} = temp_ist;
        end
        % Rigenera traiettoria con i nuovi intervalli
        clear qData dqData ddqData
        for i = 1 : numeroGiunti
            [qData(:,i), dqData(:,i), ddqData(:,i)] = seqPointsSplines_grade5(zita{:,i}, dzita{:,i}, ddzita{:,i}, T, new_ist{:,i});
        end
        tempo = Ti:T:Tf_new;                  % Tempo (per il grafico)
        grafici(qData, dqData, ddqData, zita, dzita, ddzita, tempo, new_ist, interest);
        % Conferma
        choice = input('Confermare nuova traiettoria? [1. Si, 2. No] ');
        if choice == 1
            ist = new_ist;
            Tf = Tf_new;
        else
            % Ritorna alla traiettoria di prima!
            clear qData dqData ddqData
            for i = 1 : numeroGiunti
                [qData(:,i), dqData(:,i), ddqData(:,i)] = seqPointsSplines_grade5(zita{:,i}, dzita{:,i}, ddzita{:,i}, T, ist{:,i});
            end
            tempo = Ti:T:Tf;                  % Tempo (per il grafico)
            grafici(qData, dqData, ddqData, zita, dzita, ddzita, tempo, ist, interest);
        end
    end
end