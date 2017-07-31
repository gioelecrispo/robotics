function dqdh = comau2dh_vel(dqcomau)
%
% SIX - Gennaio 2005
%
% dqdh = comau2dh_vel(dqcomau)
%
% Converte le velocità/accelerazioni dei giunti dalla convenzione COMAU alla convenzione DH
%
% Ingressi:
%   dqcomau: vettore 6x1 delle velocità (o accelerazioni) in convenzione COMAU
% Uscite:
%   dqdh   : vettore 6x1 delle velocità (o accelerazioni) in convenzione DH
% Note:
%   le unità di misura sono ininfluenti

dqdh(1) = -dqcomau(1);
dqdh(2) =  dqcomau(2);
dqdh(3) = -dqcomau(3);
dqdh(4) = -dqcomau(4);
dqdh(5) =  dqcomau(5);
dqdh(6) = -dqcomau(6);
