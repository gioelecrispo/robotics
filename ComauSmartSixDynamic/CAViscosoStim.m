function  Attr_Viscoso = CAViscoso(dqDH)
% Ingressi:
%        dqDH : vettori 6x1 secondo convenzioni DH in [m/s rad/s (x6)]
% 
% Uscite:
%       Attr_Viscoso: Coppie di Attrito Viscoso F*dqDH in convenzione DH
%
% Note:
%   le coppie in uscita sono in convenzione DH e sono quelle richieste agli attuatori (a valle dei riduttori)
%

Attr_Viscoso = [   -0.3922*dqDH(1)
                    0.8676*dqDH(2)
                    0.5465*dqDH(3)
                   -0.0476*dqDH(4)
                    0.0595*dqDH(5)
                    0.0381*dqDH(6)];


