function  Attr_Statico = CAStatico(dqDH)
%Calcola le coppie di Attrito Statico
% Ingressi: 
%        dqDH : vettori 6x1 secondo convenzioni DH in rad/s
%
% Uscite:
%       Attr_Viscoso: Coppie di Attrito Viscoso F*dqDH in convenzione DH
%
% Note:
%   le coppie in uscita sono in convenzione DH e sono quelle richieste agli attuatori (a valle dei riduttori)
%

% DUBBI: 
%            non sono sicuro sulla conversione da cioppie COMAU a coppie DH
%            e sul fatto che siano presenti le velocita' dei motori

% **********************************************************************************************************************
% Costanti
% **********************************************************************************************************************

% Lettura dei dati registrati in "costanti.m"
% addpath('../modello SIX/')
% costanti;
 
% H
H = [-1,     0,     0,     0,     0,     0;
      0,     1,     0,     0,     0,     0;
      0,     0,    -1,     0,     0,     0;
      0,     0,     0,    -1,     0,     0;
      0,     0,     0,     0,     1,     0;
      0,     0,     0,     0,     0,    -1];
  
Kr = diag([-147.8019, 153, 141, -51.4170, 81, 50]);
Kr(6,5) = -1;
soglia = 0.3;
     
% vettore dei parametri di attrito viscoso 
fs = [-45.2048; 43.5173; 27.3101; -5.3029; 10.6985; 10.7893];

dq(:, 1) = dh2comau_vel(dqDH*180/pi);


% Velocita' dei motori
dqm = (Kr*dq) * (pi/180); % in convenzione COMAU in rad/sec


Phi = zeros(6,6);
for i=1:6
    if abs(dqm(i)) > soglia
        Phi(i,i) = dqm(i)/abs(dqm(i));
    else
        Phi(i,i) = dqm(i)/soglia;
    end % if
end

Attr_Statico = (H')^-1*Phi*fs;
