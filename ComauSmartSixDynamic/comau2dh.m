function qdh = comau2dh(qcomau)
%
% SIX - Gennaio 2005
%
% qdh = comau2dh(qcomau)
%
% Converte le posizioni dei giunti dalla convenzione COMAU alla convenzione DH
%
% Ingressi:
%   qcomau: vettore 6x1 delle posizioni in convenzione COMAU in gradi
% Uscite:
%   qdh   : vettore 6x1 delle posizioni in convenzione DH in gradi
% Note:
%   le unita' di misura devono essere necessariamente in gradi
%   la chiamata seguente: comau2dh(zeros(6,1)) fornisce il vettore q0 in gradi in convenzione DH

  qdh(1) = -qcomau(1) +   0;
  qdh(2) =  qcomau(2) -  90;
  qdh(3) = -qcomau(3) -  90;
  qdh(4) = -qcomau(4) +   0;
  qdh(5) =  qcomau(5) +   0;
  qdh(6) = -qcomau(6) + 180;
