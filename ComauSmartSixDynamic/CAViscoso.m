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


Attr_Viscoso = [33.4885*dqDH(1)
                47.1106*dqDH(2)
                42.3273*dqDH(3)
                1.77025*dqDH(4)
                5.13204*dqDH(5)
                1.13629*dqDH(6)];
