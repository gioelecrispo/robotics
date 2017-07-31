function [limiti_giunto_inf, limiti_giunto_sup, limiti_veloc, limiti_accel] = limiti_manipolatore()
% Questa funzione restituisce i limiti fisici del manipolatore; sono presi
% in considerazione solo i limiti di giunto, velocita', accelerazione, ridotti
% opportunamente per il calcolo.

%%%%%% LIMITI FISICI DEL MANIPOLATORE %%%%%%
% Limiti di giunto (piu' stringenti)
limiti_giunto_inf = [0   -2.4435   -1.3963     -3.6652   -2.2689   -43.9823];
limiti_giunto_sup = [2.9671   -1.1345    1.2217      3.6652    2.2689    50.2655];
limiti_veloc = [2.4330    2.7925   2.9671   7.8534    6.5443   9.5986];
limiti_accel = [10   10  10 17.5   22.5  22.5];