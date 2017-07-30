%%%%% GESTIONE PUNTI AGGIUNTIVI
function [zita, dzita, ddzita, ist, interest] = addPointsToTrajectory(zita, dzita, ddzita, qData, dqData, ddqData, T, tempo, ist, interest)


numeroGiunti = 6;
aggiungiPunti = 1;
l = 1;
while aggiungiPunti == 1
    for i = 1 : numeroGiunti
        close all
        istants = ist{:,i};
        y = 1;
        while istants(y+1) ~= istants(end)
            graficiInterval(qData, dqData, ddqData, istants(y), istants(y+1), i);
            newIst = input('Specifica l istante desiderato per il nuovo punto:     ');
            if ~isempty(newIst)
                if newIst == 0
                    return;
                end
                pos = input('Specifica la posizione desiderata del nuovo punto:     ');
                if isempty(pos)
                    pos = qData(round(newIst/T)+1,i);
                end
                vel = input('Specifica la velocita desiderata nel nuovo punto:      ');
                if isempty(vel)
                    vel = dqData(round(newIst/T)+1,i);
                end
                acc = input('Specifica l accelerazione desiderata nel nuovo punto:  ');
                if isempty(acc)
                    acc = ddqData(round(newIst/T)+1,i);
                end
                newIst = round(newIst, 3);
                if(mod(newIst, T) ~= 0)
                    newIst = newIst - T/2;
                end
                % Salvo i punti che aggiungo
                new_p(l,i) = pos;
                new_v(l,i) = vel;
                new_a(l,i) = acc;
                new_t(l,i) = newIst;
                % Aggiunto il punto cosi' definito ai vettori zita, dzita,
                % ddzita e ist; aggiorno interest.
                temp_zita = zita{:,i};
                temp_dzita = dzita{:,i};
                temp_ddzita = ddzita{:,i};
                temp_ist = ist{:,i};
                indexWhereToAdd = find(newIst > temp_ist);
                indexWhereToAdd = indexWhereToAdd(end);
                nzita = [temp_zita(1:indexWhereToAdd); pos; temp_zita(indexWhereToAdd+1:end)];
                ndzita = [temp_dzita(1:indexWhereToAdd); vel; temp_dzita(indexWhereToAdd+1:end)];
                nddzita = [temp_ddzita(1:indexWhereToAdd); acc; temp_ddzita(indexWhereToAdd+1:end)];
                nist = [temp_ist(1:indexWhereToAdd); newIst; temp_ist(indexWhereToAdd+1:end)];
                
                % Costruisco i nuovi valori di zita, dzita e ddzita, ricopiando
                % i vecchi valori e aggiornando solo quelli per il giunto
                % corrente (cio? quelli definiti in nzita, ndzita e nddzita).
                new_zita = zita;
                new_dzita = dzita;
                new_ddzita = ddzita;
                new_ist = ist;
                new_zita{:,i} = nzita;
                new_dzita{:,i} = ndzita;
                new_ddzita{:,i} = nddzita;
                new_ist{:,i} = nist;
                % Aggiorno anche interest per il giunto i-esimo con la stessa
                % tecnica
                new_interest = interest;
                for k = 1 : length(interest(:,i))
                    if new_interest(k,i) > indexWhereToAdd
                        new_interest(k,i) = new_interest(k,i)+1;
                    end
                end
                
                % Ottenuti i nuovi valori, genero la nuova traiettoria
                [qData(:,i), dqData(:,i), ddqData(:,i)] = seqPointsSplines_grade5(nzita, ndzita, nddzita, T, nist);
                grafici(qData, dqData, ddqData, new_zita, new_dzita, new_ddzita, tempo, new_ist, new_interest, i);
                % Conferma
                choice = input('Confermare nuova traiettoria? [1. Si, 2. No] ');
                if choice == 1
                    zita{:,i} = nzita;
                    dzita{:,i} = ndzita;
                    ddzita{:,i} = nddzita;
                    ist{:,i} = nist;
                    interest = new_interest;
                    l = l + 1;
                else
                    % Ritorna alla traiettoria di prima!
                    [qData(:,i), dqData(:,i), ddqData(:,i)] = seqPointsSplines_grade5(zita{:,i}, dzita{:,i}, ddzita{:,i}, T, ist{:,i});
                end
            end
            y = y + 1;
            close all
        end
    end
end