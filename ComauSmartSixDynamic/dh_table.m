function [a,d,alpha] = dh_table
%
% SIX - Gennaio 2005
%
% [a,d,alpha] = dh_table
% 
% Carica i valori numerici delle costanti di denavit-hartenberg
%
% Uscite:
%   a     : vettore 6x1 dei termini ai
%   d     : vettore 6x1 dei termini di
%   alpha : vettore 6x1 dei termini alphai
% Note:
%   le distanze sono in metri, gli angoli in radianti


% ***********************************************************************************************************************
% Caricamento dei dati che definiscono le costanti del robot
% ***********************************************************************************************************************

SIX_INIT_XX001;

a     = TabellaDH.a;
d     = TabellaDH.d;
alpha = TabellaDH.alpha;
