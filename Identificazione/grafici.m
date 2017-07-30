function [ax] = grafici(qData, dqData, ddqData, zita, dzita, ddzita, tempo, ist, interest, giunti)

[limiti_giunto_inf, limiti_giunto_sup, limiti_veloc, limiti_accel] = limiti_manipolatore(); 

if ~exist('giunti', 'var')
    giunti = [1 2 3 4 5 6];
end

N = length(giunti);

figure('units','normalized','outerposition',[0 0 1 1]),
for j = 1 : N
    i = giunti(j);
    zita_ = zita{:,i};
    dzita_ = dzita{:,i};
    ddzita_ = ddzita{:,i};
    ist_ = ist{:,i};
    interest_ = interest(:,i);
    % Posizione
    ax(j) = subplot(3,N,j);
    plot(tempo, qData(:,i)), hold on
    plot(ist_(interest_), zita_(interest_), 'bo'),
    for k = 1 : length(interest_)
        text(ist_(interest_(k)), zita_(interest_(k)), num2str(k), 'Color', 'r')
    end
    plot(tempo, ones(size(tempo)) * limiti_giunto_inf(i), 'r--');
    plot(tempo, ones(size(tempo)) * limiti_giunto_sup(i), 'r--');
    xlim([tempo(1) tempo(end)]);
    strTitlePosiz = sprintf('Posiz - giunto %d', i);
    title(strTitlePosiz);
    
    % Velocita'
    ax(j+N) = subplot(3,N,j+N);
    plot(tempo, dqData(:,i)), hold on, axis auto
    plot(ist_(interest_), dzita_(interest_), 'bo'),
    for k = 1 : length(interest_)
        text(ist_(interest_(k)), dzita_(interest_(k)), num2str(k),'Color', 'r')
    end
    plot(tempo, ones(size(tempo)) * -limiti_veloc(i), 'r--');
    plot(tempo, ones(size(tempo)) * limiti_veloc(i), 'r--');
    xlim([tempo(1) tempo(end)]);
    strTitleVeloc = sprintf('Veloc - giunto %d', i);
    title(strTitleVeloc);
    
    % Accelerazione
    ax(j+N*2) = subplot(3,N,j+N*2);
    plot(tempo, ddqData(:,i)), hold on, axis auto
    plot(ist_(interest_), ddzita_(interest_), 'bo'),
    for k = 1 : length(interest_)
        text(ist_(interest_(k)), ddzita_(interest_(k)), num2str(k),'Color', 'r')
    end
    plot(tempo, ones(size(tempo)) * -limiti_accel(i), 'r--');
    plot(tempo, ones(size(tempo)) * limiti_accel(i), 'r--');
    xlim([tempo(1) tempo(end)]);
    strTitleAccel = sprintf('Accel - giunto %d', i);
    title(strTitleAccel);
end
