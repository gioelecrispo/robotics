function theta = carico(AggiungiCarico)
%
%   Smart Six - Settembre 2007
%
%   function GammaPars = carico(AggiungiCarico)
%
%   Carica i parametri per il calcolo delle coppie
%
% - AggiungiCarico : Flag per aggiunta carico nominale di 6Kg sulla flangia robot
%

costanti;


if(AggiungiCarico)
  m = 6.058917; %massa del carico

theta_sin  =  DYN.MODEL(1:52);
theta = theta_sin;
%BARICENTRO  E TENSORE DI INERZIA IN TERNA UTENTE (AL CENTRO DELLA FLANGIA)


c_UTENTE(1) = 99.845*10^-3; %m
c_UTENTE(2) = 0;
c_UTENTE(3) = 77.634*10^-3;
    
I_UTENTE(1,1) =0.008702; % Ixx 
I_UTENTE(1,2) =0.000000; % Ixy
I_UTENTE(1,3) = -0.001949; % Ixz
I_UTENTE(2,2) =0.010942; % Iyy
I_UTENTE(2,3) =0.000000; % Iyz
I_UTENTE(3,3) =0.012465; % Izz
  
%CONVERSIONE IN TERNA CREATE
c_CREATE(1) = c_UTENTE(1);
c_CREATE(2) = c_UTENTE(2);
c_CREATE(3) = c_UTENTE(3) + d(6);   
    
I_CREATE(1,1) = I_UTENTE(1,1) + m * ( c_UTENTE(3)+d(6))^2 + m * c_UTENTE(2)^2;
I_CREATE(1,2) = I_UTENTE(1,2) - m * c_UTENTE(2)*c_UTENTE(1);
I_CREATE(1,3) = I_UTENTE(1,3) - m * ( c_UTENTE(3)+d(6))*c_UTENTE(1);
I_CREATE(2,2) = I_UTENTE(2,2) + m * (-c_UTENTE(3)-d(6))^2 + m * c_UTENTE(1)^2;
I_CREATE(2,3) = I_UTENTE(2,3) + m * (-c_UTENTE(3)-d(6))*c_UTENTE(2);
I_CREATE(3,3) = I_UTENTE(3,3) + m * c_UTENTE(2)^2 + m * c_UTENTE(1)^2;


%DEFINIZIONE PARAMETRI DINAMICI CARICO

m6 = m;


I6xx = I_CREATE(1,1);
I6xy = I_CREATE(1,2);
I6xz = I_CREATE(1,3);
I6yy = I_CREATE(2,2);
I6yz = I_CREATE(2,3);
I6zz = I_CREATE(3,3);
mc6x = m6*c_CREATE(1);
mc6y = m6*c_CREATE(2);
mc6z = m6*c_CREATE(2);

theta(1)  =  theta_sin(1);
theta(2)  =  theta_sin(2);
theta(3)  =  theta_sin(3);
theta(4)  =  theta_sin(4);
theta(5)  =  theta_sin(5);
theta(6)  =  theta_sin(6);
theta(7)  =  theta_sin(7);
theta(8)  =  theta_sin(8);
theta(9)  =  theta_sin(9);
theta(10)  =  theta_sin(10);
theta(11)  =  theta_sin(11);
theta(12)  =  theta_sin(12);
theta(13)  =  theta_sin(13);
theta(14)  =  theta_sin(14);
theta(15)  =  theta_sin(15);
theta(16)  =  theta_sin(16)  +  mc6x;
theta(17)  =  theta_sin(17)  +  mc6y;
theta(18)  =  theta_sin(18)  +  I6xy;
theta(19)  =  theta_sin(19)  +  I6xz;
theta(20)  =  theta_sin(20)  +  I6yz;
theta(21)  =  theta_sin(21)  +  I6zz;
theta(22)  =  theta_sin(22);
theta(23)  =  theta_sin(23)  +  0.387500*m6;  
theta(24)  =  theta_sin(24)  +  0.590000*m6;
theta(25)  =  theta_sin(25)  -  0.348100*m6;
theta(26)  =  theta_sin(26);
theta(27)  =  theta_sin(27)  +  0.348100*m6;
theta(28)  =  theta_sin(28)  +  0.130000*m6;
theta(29)  =  theta_sin(29)  +  0.647070*m6;
theta(30)  =  theta_sin(30)  +  0.401800*m6;
theta(31)  =  theta_sin(31)  -  0.0841191*m6;
theta(32)  =  theta_sin(32)  +  0.435600*m6;
theta(33)  =  theta_sin(33);
theta(34)  =  theta_sin(34);
theta(35)  =  theta_sin(35);
theta(36)=theta_sin(36);
theta(37)=theta_sin(37)+mc6z;
theta(38)=theta_sin(38)+I6yy;
theta(39)=theta_sin(39)+I6yy;
theta(40)=theta_sin(40)+I6xx-I6yy;
else
   theta = DYN.MODEL(1:52);
end



