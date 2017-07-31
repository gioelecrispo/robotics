function [out] = CalcCoppieComau(u)
%Calcola la dinamica Inversa del COMAU ......
%In ingresso:
%u che contiene in sequenza
%qDH  :   posizioni ai giunti in convenzione Denavit-Hartenberg
%dqDH :   velocita' ai giunti in convenzione Denavit-Hartenberg
%ddqDH:   accelerazioni ai giunti in convenzione Denavit-Hartenberg


%In uscita:
%out contiene:
%Inerzia      : Coppie di inerzia B(qDH)*ddqDH
%Centrifugo   : Coppie di Coriolis e Centrifughe C(qDH,dqDH)*dqDH

%Attr_Viscoso : Coppie di Attrito Viscoso F*dqDH
%Attr_Statico : Coppie di Attrito Statico
%Gravita'      : Coppie di Gravita' g(qDH)


%NOTE:
%       I contributi vengono calcolati a partire dal file phi.m fornito da COMAU
%       il quale lavora in convenzione COMAU, quindi le variabili qDH,
%       dqDH e ddqDH vengono prima covertite in convenzione COMAU, in
%       seguito le coppie in uscita vengono convertite tramite la
%       matrice H (definita in costanti.m) in convenzione DH

qDH(:, 1) = u(1:6);
dqDH(:, 1) = u(7:12);
ddqDH(:, 1) = u(13:18);


B = MatriceInerzia(qDH);
Inerzia = B*ddqDH;

Centrifugo(:,1) = CCentrifugoCoriolis(qDH, dqDH);
Attr_Viscoso(:,1) = CAViscoso(dqDH);
Gravita(:,1) = CGravita(qDH);
Attr_Statico(:,1) = CAStatico(dqDH);


out = [Inerzia; Centrifugo; Attr_Viscoso; Gravita; Attr_Statico];




