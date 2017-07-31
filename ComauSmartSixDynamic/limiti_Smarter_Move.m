function [limiti_giunto_inf, limiti_giunto_sup, dqmaxcomau, ddqmaxcomau, limiti_coppia] = limiti_Smarter_Move()
% Questa funzione restituisce i limiti fisici del manipolatore; sono presi
% in considerazione solo i limiti di giunto, velocita', accelerazione e
% coppia, trasciando i limiti di jerk, inutili al nostro scopo.

%%%%%% LIMITI FISICI DEL MANIPOLATORE %%%%%%
limiti_giunto_inf = [-170 -85  -170  -210 -130 -2700]*pi/180; %da file CAD
limiti_giunto_sup = [170  155    0   +210 +130 +2700]*pi/180; %da file CAD
dqmaxcomau = [2.433 2.7925 2.9671 7.8534 6.5443 9.5986]; %velocita' massime ai giunti rad/s
ddqmaxcomau = [20 20 20 35 45 45]/2; %accelerazioni massime ai giunti rad/s^2
%freq_max = [7.47921986 6.20555 5.99255972 6.96794985 6.54554985 6.47969985];
%dddqmaxcomau = ddqmaxcomau.*freq_max; 
limiti_coppia =[877.8982 1462.6928 558.3315 46.3556 58.4212 46.8812];



