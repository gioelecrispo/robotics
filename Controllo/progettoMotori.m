%%%%% SCRIPT DI INIZIALIZZAZIONE
% Questo script serve ad inizializzare i parametri per il controllo
% indipendente ai giunti, dunque la simulazione simulink e V-REP.

clear 
load('traiettoria_interpolata.mat')
%%%%% MANIPOLATORE
% Valori manipolatore
kr = [-147.8019; 153.0000; 141.0000; -51.4170; 81.0000; 50.0000];  % Rapporti di trasmissione  
Kr = diag(kr);
bi = [28.2971; 35.9938; 12.4568; 0.2032; 0.2742; 0.1051];          % Bsegn
biStim = [29.7584; 33.3981; 12.1444; 0.1689; 0.4699; 0.1521];
Bsegn = diag(bi);
BsegnStim = diag(biStim);
bm = bi./(kr.^2);  
bmStim = biStim./(kr.^2);
fi = [33.4885; 47.1106; 42.3273; 1.77025; 5.13204; 1.13629];       % Attrito meccanico
fiStim = [57.9743; 132.7360; 77.0541; 2.4482; 4.8170; 1.9066]; 
fm = fi./(kr.^2);
fmStim = fiStim./(kr.^2);


%%%%% PARAMETRI MOTORI
% RaX: resistenza d'armatura  -  in Ohm
% LaX: induttanza d'armatura  -  in Henry
% ktX: costante di coppia     -  in Nm/Arms
% kvX: costante di tensione   -  in Volt
%      il calcolo va fatto cos?:  (dataSheetValue * 60)/(2*pi*1000) 

% MOTORE 1 e 3
Ra13 = 1.7500;   
La13 = 0.0084;
kt13 = 0.7000;
kv13 = 0.4041;

% MOTORE 2
Ra2 = 1.7000;
La2 = 0.0120;
kt2 = 1.0400;
kv2 = 0.6007;

% MOTORE 4, 5 e 6
Ra456 = 34.0000;
La456 = 0.0150;
kt456 = 0.5100;
kv456 = 0.2941;


% MOTORI
Ra = [Ra13; Ra2; Ra13; Ra456; Ra456; Ra456];     % Resistenza d'armatura
La = [La13; La2; La13; La456; La456; La456];     % Induttanza d'armatura
kt = [kt13; kt2; kt13; kt456; kt456; kt456];     % Costante di coppia
kv = [kv13; kv2; kv13; kv456; kv456; kv456];     % Costante di tensione

km = 1./kv;                 % Guadagni motori
Tm = (Ra.*bm)./(kv.*kt);    % Poli motori



%%%%% CONTROLLORE
% Guadagni di trasduzione fissati a 1
ktp = [1; 1; 1; 1; 1; 1];
ktv = [1; 1; 1; 1; 1; 1];
kta = [1; 1; 1; 1; 1; 1];

% Fisso valori della dinamica desiderata
zeta = 1;                       % Coefficiente di smorzamento
ta = 10*0.002;%0.06;                      % Tempo di assestamento 
wn = 5.83/(zeta*ta);            % Pulsazione naturale
Xr_min = wn^2./km;              % Minimo Xr
Xr = Xr_min*1.8;                % Fattore di reiezione del disturbo (Pag. 319 libro)

% Risolvo il sistema di equazioni e ottengo Kp Kv Ka
Ka = ((km.*Xr./wn^2)-1).*(1./km.*kta);
Kp = (wn.*ktv)./(zeta*2.*ktp);
Kv = Xr./(Kp.*Ka.*ktp);



% Setto lo zero del controllore sul polo del motore
Ta = Tm;                    


% Tf 
t=Ti:T:Tf;


%sim('schema_controllo.mdl');
