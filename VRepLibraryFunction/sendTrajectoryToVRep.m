function sendTrajectoryToVRep(robot, slitta, qData, tempo, graphicControl)
% Questa funziona invia la traiettoria desiderata a VRep.
% E' necessario specificare il robot a cui inviare la traiettoria e i
% parametri di slitta e dei giunti.
% tempo e graphicControl sono valori necessari per il plotting dei
% risultati


% Attendo 3 secondi per spostarmi su VRep
pause(3);

if graphicControl == 0
    t1 = tic;        % Misuro il tempo che impiega la traiettoria
    % Invio le posizioni
    for i = 1 : length(qData)
        tic          % Misuro il tempo di invio tra un campione e l'altro
        SendPoseToVRep(robot(2), [slitta, qData(i,:)]); 
        tocTime = toc;
        if tocTime < 0.0013;
            pause(0.0013 - tocTime);
        end
    end
    toc(t1)
else
    [limiti_giunto_inf, limiti_giunto_sup, ~, ~] = limiti_manipolatore();
    clear h
    paused = 0;         % Booleano indicatore di pausa
    fig = figure('units', 'normalized', 'outerposition', [0 0 0.3 1]);
    for i = 1 : 6
        h(i) = subplot(6,1,i);
        h(i).XLimMode = 'auto';
        plot(h(i), tempo, qData(:,i))
        axis([tempo(1) tempo(end) limiti_giunto_inf(i)-1 limiti_giunto_sup(i)+1])
    end
    
    ButtonPause = uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', ' Pause ', 'Units', 'normalized', 'Position', [0.43 0 0.2 0.05], 'Visible', 'on', 'Callback', 'if paused==1 paused=0;, else paused=1;, end');
    
    for i = 1 : length(qData)
        if isvalid(h) == zeros(1, 6)
            break;
        end
        if exist('linea', 'var')
            delete(linea);
        end
        hold(h(1),'on'); hold(h(2),'on'); hold(h(3),'on'); hold(h(4),'on'); hold(h(5),'on'); hold(h(6),'on');
        for j = 1 : 6
            linea(j) = plot(h(j), [tempo(i) tempo(i)], [limiti_giunto_inf(j)-1, limiti_giunto_sup(j)+1], 'r');
        end
        drawnow
        hold off;
        if paused == 0
            SendPoseToVRep(robot(2), [slitta, qData(i,:)]);
        else
            waitfor(warndlg('Paused. Press OK to continue'))
            paused = 0;
        end
    end
end