function Phi = phiDH(qDH,dqDH,ddqDH)
%
% SIX - Gennaio 2005
%
% Phi = phi(q,dq,ddq)
%
% Calcola il regressore ridotto in numerico
% 
% Ingressi:
%   q,dq,ddq : vettori 6x1 secondo convenzioni DH (rad link)
%
% Uscite:
%   Phi : regressore ridotto in numerico
%
% Note:
%   le coppie in uscita sono in convenzione DH e sono quelle richieste agli attuatori (a valle dei riduttori)
%
% File letti:
%   costanti.m : definizione delle costanti dinamiche utilizzate


% **********************************************************************************************************************
% Costanti
% **********************************************************************************************************************

q(:,1) = dh2comau(qDH*180/pi);
dq(:,1) = dh2comau_vel(dqDH*180/pi);
ddq(:,1) = dh2comau_vel(ddqDH*180/pi);

% Lettura dei dati registrati in "costanti.m" 
%costanti;

Kr = diag([-1.478018575851390
   1.530000000000000
   1.410000000000000
  -0.514170040485830
   0.810000000000000
   0.500000000000000])*100;

r01x = 0.15;0.150000000000000;
r01y = -0.450000000000000;
 r23x = 0.130000000000000;
 
r12x = 0.590000000000000;
r34y = 0.647070000000000;
k54 = 0;
k64 = 0;
k65 = 0.020000000000000;
%************************************************************************************************************************
% Cinematica diretta
%************************************************************************************************************************

% Calcola, in numerico, le velocita' e le accelerazioni delle terne
  [w,dw,ddp] = ricforw(q,dq,ddq);


% **********************************************************************************************************************
% Riorganizzazione dei vettori
% **********************************************************************************************************************

% Riorganizza i vettori velocita'
  w1x   = w(1,1);     w1y = w(2,1);     w1z = w(3,1);
  w2x   = w(1,2);     w2y = w(2,2);     w2z = w(3,2);
  w3x   = w(1,3);     w3y = w(2,3);     w3z = w(3,3);
  w4x   = w(1,4);     w4y = w(2,4);     w4z = w(3,4);
  w5x   = w(1,5);     w5y = w(2,5);     w5z = w(3,5);
  w6x   = w(1,6);     w6y = w(2,6);     w6z = w(3,6);
% Riorganizza i vettori accelerazioni
  dw1x  = dw(1,1);   dw1y = dw(2,1);   dw1z = dw(3,1);
  dw2x  = dw(1,2);   dw2y = dw(2,2);   dw2z = dw(3,2);
  dw3x  = dw(1,3);   dw3y = dw(2,3);   dw3z = dw(3,3);
  dw4x  = dw(1,4);   dw4y = dw(2,4);   dw4z = dw(3,4);
  dw5x  = dw(1,5);   dw5y = dw(2,5);   dw5z = dw(3,5);
  dw6x  = dw(1,6);   dw6y = dw(2,6);   dw6z = dw(3,6);
% Riorganizza i vettori accelerazioni lineari
  ddp1x = ddp(1,1); ddp1y = ddp(2,1); ddp1z = ddp(3,1);
  ddp2x = ddp(1,2); ddp2y = ddp(2,2); ddp2z = ddp(3,2);
  ddp3x = ddp(1,3); ddp3y = ddp(2,3); ddp3z = ddp(3,3);
  ddp4x = ddp(1,4); ddp4y = ddp(2,4); ddp4z = ddp(3,4);
  ddp5x = ddp(1,5); ddp5y = ddp(2,5); ddp5z = ddp(3,5);
  ddp6x = ddp(1,6); ddp6y = ddp(2,6); ddp6z = ddp(3,6);


% **********************************************************************************************************************
% Conversione delle grandezze
% **********************************************************************************************************************

% Posizioni
  % Converte posizioni Comau in gradi in posizioni DH in radianti
    qdh = (comau2dh(q)) * (pi/180);
  % Riorganizzazione delle posizioni
    q1 = qdh(1); 
    q2 = qdh(2); 
    q3 = qdh(3); 
    q4 = qdh(4); 
    q5 = qdh(5); 
    q6 = qdh(6);

% Velocit???
  % Converte velocita' Comau in gradi/sec in velocita' DH in rad/sec
    dqdh = (comau2dh_vel(dq)) * (pi/180); 
  % Riorganizzazione delle velocita'
    dq1 = dqdh(1); 
    dq2 = dqdh(2); 
    dq3 = dqdh(3); 
    dq4 = dqdh(4); 
    dq5 = dqdh(5); 
    dq6 = dqdh(6);

% Accelerazioni
  % Converte accelerazioni Comau in gradi/sec^2 in accelerazioni DH in rad/sec^2
    ddqdh = (comau2dh_vel(ddq)) * (pi/180); 
  % Riorganizzazione delle accelerazioni
    ddq1 = ddqdh(1); 
    ddq2 = ddqdh(2); 
    ddq3 = ddqdh(3); 
    ddq4 = ddqdh(4); 
    ddq5 = ddqdh(5); 
    ddq6 = ddqdh(6);

% Velocita' dei motori
  dqm = (Kr*dq) * (pi/180); % in convenzione COMAU in rad/sec

% Regressore ridotto  in simbolico del robot 26-Jan-2005       
  % Coppia: 1
    Phi(1,1)  = ddp1z*sin(q2)-r01x*(dw2x+w2y*w2z);
    Phi(1,2)  = (dw2y-w2x*w2z)*sin(q2)+(dw2x+w2y*w2z)*cos(q2);
    Phi(1,3)  = (w2y^2-w2z^2)*sin(q2)+(dw2z-w2y*w2x)*cos(q2);
    Phi(1,4)  = dw3y*sin(q3+q2)-w3z*w3x*sin(q3+q2)+w3x^2*cos(q3+q2)-w3y^2*cos(q3+q2);
    Phi(1,5)  = w3y^2*sin(q3+q2)-w3z^2*sin(q3+q2)+dw3y*cos(q3+q2)+w3z*w3x*cos(q3+q2);
    Phi(1,6)  = 0;
    Phi(1,7)  = (ddp3z*sin(q4)*cos(q3)-(-sin(q4)*ddp3x+cos(q4)*ddp3y+r23x*(sin(q4)*(-w4y^2-w4z^2)-cos(q4)*...
                (-dw4y+w4x*w4z)))*sin(q3))*sin(q2)+(ddp3z*sin(q4)*sin(q3)+(-sin(q4)*ddp3x+cos(q4)*ddp3y+r23x*...
                (sin(q4)*(-w4y^2-w4z^2)-cos(q4)*(-dw4y+w4x*w4z)))*cos(q3)-r12x*(-sin(q4)*...
                (-w4y^2-w4z^2)+cos(q4)*(-dw4y+w4x*w4z)))*cos(q2)-r01x*(-sin(q4)*(-w4y^2-w4z^2)+cos(q4)*...
                (-dw4y+w4x*w4z));
    Phi(1,8)  = (((dw4y-w4x*w4z)*cos(q4)+(w4x^2-w4y^2)*sin(q4))*cos(q3)-(dw4x+w4y*w4z)*sin(q3))*...
                sin(q2)+(((dw4y-w4x*w4z)*cos(q4)+(w4x^2-w4y^2)*sin(q4))*sin(q3)+(dw4x+w4y*w4z)*cos(q3))*...
                cos(q2);
    Phi(1,9)  = (((dw4z+w4y*w4x)*cos(q4)+(dw4x-w4y*w4z)*sin(q4))*cos(q3)-(w4z^2-w4x^2)*sin(q3))*...
                sin(q2)+(((dw4z+w4y*w4x)*cos(q4)+(dw4x-w4y*w4z)*sin(q4))*sin(q3)+(w4z^2-w4x^2)*cos(q3))*...
                cos(q2);
    Phi(1,10) = 0;
    Phi(1,11) = (((ddp4z*sin(q5)+r34y*(-dw5z-w5x*w5y))*cos(q4)+(-sin(q5)*ddp4x+cos(q5)*ddp4y-r34y*(cos(q5)*...
                (-w5y^2-w5z^2)-sin(q5)*(-dw5y+w5x*w5z)))*sin(q4))*cos(q3)-(-ddp4z*cos(q5)+r23x*(sin(q4)*...
                (cos(q5)*(-w5y^2-w5z^2)-sin(q5)*(-dw5y+w5x*w5z))-cos(q4)*(-dw5z-w5x*w5y)))*sin(q3))*...
                sin(q2)+(((ddp4z*sin(q5)+r34y*(-dw5z-w5x*w5y))*cos(q4)+(-sin(q5)*ddp4x+cos(q5)*ddp4y-r34y*...
                (cos(q5)*(-w5y^2-w5z^2)-sin(q5)*(-dw5y+w5x*w5z)))*sin(q4))*sin(q3)+(-ddp4z*cos(q5)+r23x*...
                (sin(q4)*(cos(q5)*(-w5y^2-w5z^2)-sin(q5)*(-dw5y+w5x*w5z))-cos(q4)*(-dw5z-w5x*w5y)))*...
                cos(q3)-r12x*(-sin(q4)*(cos(q5)*(-w5y^2-w5z^2)-sin(q5)*(-dw5y+w5x*w5z))+cos(q4)*(-dw5z-w5x*...
                w5y)))*cos(q2)-r01x*(-sin(q4)*(cos(q5)*(-w5y^2-w5z^2)-sin(q5)*(-dw5y+w5x*w5z))+cos(q4)*...
                (-dw5z-w5x*w5y));
    Phi(1,12) = ((((dw5y-w5x*w5z)*cos(q5)-(w5x^2-w5y^2)*sin(q5))*cos(q4)+(-dw5x-w5y*w5z)*sin(q4))*...
                cos(q3)-((dw5y-w5x*w5z)*sin(q5)+(w5x^2-w5y^2)*cos(q5))*sin(q3))*sin(q2)+((((dw5y-w5x*w5z)*...
                cos(q5)-(w5x^2-w5y^2)*sin(q5))*cos(q4)+(-dw5x-w5y*w5z)*sin(q4))*sin(q3)+((dw5y-w5x*w5z)*...
                sin(q5)+(w5x^2-w5y^2)*cos(q5))*cos(q3))*cos(q2);
    Phi(1,13) = ((((dw5z+w5x*w5y)*cos(q5)-(dw5x-w5y*w5z)*sin(q5))*cos(q4)+(-w5z^2+w5x^2)*sin(q4))*...
                cos(q3)-((dw5z+w5x*w5y)*sin(q5)+(dw5x-w5y*w5z)*cos(q5))*sin(q3))*sin(q2)+((((dw5z+w5x*w5y)*...
                cos(q5)-(dw5x-w5y*w5z)*sin(q5))*cos(q4)+(-w5z^2+w5x^2)*sin(q4))*sin(q3)+((dw5z+w5x*w5y)*...
                sin(q5)+(dw5x-w5y*w5z)*cos(q5))*cos(q3))*cos(q2);
    Phi(1,14) = ((((w5y^2-w5z^2)*cos(q5)-(dw5y+w5x*w5z)*sin(q5))*cos(q4)+(-dw5z+w5x*w5y)*sin(q4))*...
                cos(q3)-((w5y^2-w5z^2)*sin(q5)+cos(q5)*(dw5y+w5x*w5z))*sin(q3))*sin(q2)+((((w5y^2-w5z^2)*...
                cos(q5)-(dw5y+w5x*w5z)*sin(q5))*cos(q4)+(-dw5z+w5x*w5y)*sin(q4))*sin(q3)+((w5y^2-w5z^2)*...
                sin(q5)+cos(q5)*(dw5y+w5x*w5z))*cos(q3))*cos(q2);
    Phi(1,15) = 0;
    Phi(1,16) = (((ddp5z*sin(q6)*cos(q5)-(-sin(q6)*ddp5x+cos(q6)*ddp5y)*sin(q5)+r34y*(-sin(q6)*...
                (-w6y^2-w6z^2)-cos(q6)*(dw6z+w6y*w6x)))*cos(q4)+(ddp5z*cos(q6)-r34y*(cos(q5)*(cos(q6)*...
                (-w6y^2-w6z^2)-(dw6z+w6y*w6x)*sin(q6))-sin(q5)*(-dw6y+w6z*w6x)))*sin(q4))*cos(q3)-(ddp5z*...
                sin(q6)*sin(q5)+(-sin(q6)*ddp5x+cos(q6)*ddp5y)*cos(q5)+r23x*(sin(q4)*(cos(q5)*(cos(q6)*...
                (-w6y^2-w6z^2)-(dw6z+w6y*w6x)*sin(q6))-sin(q5)*(-dw6y+w6z*w6x))-cos(q4)*(-sin(q6)*...
                (-w6y^2-w6z^2)-cos(q6)*(dw6z+w6y*w6x))))*sin(q3))*sin(q2)+(((ddp5z*sin(q6)*cos(q5)-(-sin(q6)*...
                ddp5x+cos(q6)*ddp5y)*sin(q5)+r34y*(-sin(q6)*(-w6y^2-w6z^2)-cos(q6)*(dw6z+w6y*w6x)))*...
                cos(q4)+(ddp5z*cos(q6)-r34y*(cos(q5)*(cos(q6)*(-w6y^2-w6z^2)-(dw6z+w6y*w6x)*sin(q6))-sin(q5)*...
                (-dw6y+w6z*w6x)))*sin(q4))*sin(q3)+(ddp5z*sin(q6)*sin(q5)+(-sin(q6)*ddp5x+cos(q6)*ddp5y)*...
                cos(q5)+r23x*(sin(q4)*(cos(q5)*(cos(q6)*(-w6y^2-w6z^2)-(dw6z+w6y*w6x)*sin(q6))-sin(q5)*...
                (-dw6y+w6z*w6x))-cos(q4)*(-sin(q6)*(-w6y^2-w6z^2)-cos(q6)*(dw6z+w6y*w6x))))*cos(q3)-r12x*...
                (-sin(q4)*(cos(q5)*(cos(q6)*(-w6y^2-w6z^2)-(dw6z+w6y*w6x)*sin(q6))-sin(q5)*(-dw6y+w6z*...
                w6x))+cos(q4)*(-sin(q6)*(-w6y^2-w6z^2)-cos(q6)*(dw6z+w6y*w6x))))*cos(q2)-r01x*(-sin(q4)*...
                (cos(q5)*(cos(q6)*(-w6y^2-w6z^2)-(dw6z+w6y*w6x)*sin(q6))-sin(q5)*(-dw6y+w6z*w6x))+cos(q4)*...
                (-sin(q6)*(-w6y^2-w6z^2)-cos(q6)*(dw6z+w6y*w6x)));
    Phi(1,17) = (((ddp5z*cos(q6)*cos(q5)-(-cos(q6)*ddp5x-sin(q6)*ddp5y)*sin(q5)+r34y*(-sin(q6)*(-dw6z+w6y*...
                w6x)-cos(q6)*(-w6z^2-w6x^2)))*cos(q4)+(-ddp5z*sin(q6)-r34y*(cos(q5)*((-dw6z+w6y*w6x)*...
                cos(q6)-sin(q6)*(-w6z^2-w6x^2))-sin(q5)*(dw6x+w6z*w6y)))*sin(q4))*cos(q3)-(ddp5z*cos(q6)*...
                sin(q5)+(-cos(q6)*ddp5x-sin(q6)*ddp5y)*cos(q5)+r23x*(sin(q4)*(cos(q5)*((-dw6z+w6y*w6x)*...
                cos(q6)-sin(q6)*(-w6z^2-w6x^2))-sin(q5)*(dw6x+w6z*w6y))-cos(q4)*(-sin(q6)*(-dw6z+w6y*...
                w6x)-cos(q6)*(-w6z^2-w6x^2))))*sin(q3))*sin(q2)+(((ddp5z*cos(q6)*cos(q5)-(-cos(q6)*...
                ddp5x-sin(q6)*ddp5y)*sin(q5)+r34y*(-sin(q6)*(-dw6z+w6y*w6x)-cos(q6)*(-w6z^2-w6x^2)))*...
                cos(q4)+(-ddp5z*sin(q6)-r34y*(cos(q5)*((-dw6z+w6y*w6x)*cos(q6)-sin(q6)*...
                (-w6z^2-w6x^2))-sin(q5)*(dw6x+w6z*w6y)))*sin(q4))*sin(q3)+(ddp5z*cos(q6)*sin(q5)+(-cos(q6)*...
                ddp5x-sin(q6)*ddp5y)*cos(q5)+r23x*(sin(q4)*(cos(q5)*((-dw6z+w6y*w6x)*cos(q6)-sin(q6)*...
                (-w6z^2-w6x^2))-sin(q5)*(dw6x+w6z*w6y))-cos(q4)*(-sin(q6)*(-dw6z+w6y*w6x)-cos(q6)*...
                (-w6z^2-w6x^2))))*cos(q3)-r12x*(-sin(q4)*(cos(q5)*((-dw6z+w6y*w6x)*cos(q6)-sin(q6)*...
                (-w6z^2-w6x^2))-sin(q5)*(dw6x+w6z*w6y))+cos(q4)*(-sin(q6)*(-dw6z+w6y*w6x)-cos(q6)*...
                (-w6z^2-w6x^2))))*cos(q2)-r01x*(-sin(q4)*(cos(q5)*((-dw6z+w6y*w6x)*cos(q6)-sin(q6)*...
                (-w6z^2-w6x^2))-sin(q5)*(dw6x+w6z*w6y))+cos(q4)*(-sin(q6)*(-dw6z+w6y*w6x)-cos(q6)*...
                (-w6z^2-w6x^2)));
    Phi(1,18) = (((((dw6y-w6z*w6x)*cos(q6)-(dw6x+w6z*w6y)*sin(q6))*cos(q5)-(w6x^2-w6y^2)*sin(q5))*...
                cos(q4)+(-(dw6y-w6z*w6x)*sin(q6)-(dw6x+w6z*w6y)*cos(q6))*sin(q4))*cos(q3)-(((dw6y-w6z*w6x)*...
                cos(q6)-(dw6x+w6z*w6y)*sin(q6))*sin(q5)+(w6x^2-w6y^2)*cos(q5))*sin(q3))*sin(q2)+(((((dw6y-w6z*...
                w6x)*cos(q6)-(dw6x+w6z*w6y)*sin(q6))*cos(q5)-(w6x^2-w6y^2)*sin(q5))*cos(q4)+(-(dw6y-w6z*w6x)*...
                sin(q6)-(dw6x+w6z*w6y)*cos(q6))*sin(q4))*sin(q3)+(((dw6y-w6z*w6x)*cos(q6)-(dw6x+w6z*w6y)*...
                sin(q6))*sin(q5)+(w6x^2-w6y^2)*cos(q5))*cos(q3))*cos(q2);
    Phi(1,19) = ((((cos(q6)*(dw6z+w6y*w6x)-(w6z^2-w6x^2)*sin(q6))*cos(q5)-(dw6x-w6z*w6y)*sin(q5))*...
                cos(q4)+(-(dw6z+w6y*w6x)*sin(q6)-(w6z^2-w6x^2)*cos(q6))*sin(q4))*cos(q3)-((cos(q6)*(dw6z+w6y*...
                w6x)-(w6z^2-w6x^2)*sin(q6))*sin(q5)+(dw6x-w6z*w6y)*cos(q5))*sin(q3))*sin(q2)+((((cos(q6)*...
                (dw6z+w6y*w6x)-(w6z^2-w6x^2)*sin(q6))*cos(q5)-(dw6x-w6z*w6y)*sin(q5))*cos(q4)+(-(dw6z+w6y*...
                w6x)*sin(q6)-(w6z^2-w6x^2)*cos(q6))*sin(q4))*sin(q3)+((cos(q6)*(dw6z+w6y*w6x)-(w6z^2-w6x^2)*...
                sin(q6))*sin(q5)+(dw6x-w6z*w6y)*cos(q5))*cos(q3))*cos(q2);
    Phi(1,20) = (((((w6y^2-w6z^2)*cos(q6)-(dw6z-w6y*w6x)*sin(q6))*cos(q5)-(dw6y+w6z*w6x)*sin(q5))*...
                cos(q4)+(-(w6y^2-w6z^2)*sin(q6)-(dw6z-w6y*w6x)*cos(q6))*sin(q4))*cos(q3)-(((w6y^2-w6z^2)*...
                cos(q6)-(dw6z-w6y*w6x)*sin(q6))*sin(q5)+(dw6y+w6z*w6x)*cos(q5))*sin(q3))*...
                sin(q2)+(((((w6y^2-w6z^2)*cos(q6)-(dw6z-w6y*w6x)*sin(q6))*cos(q5)-(dw6y+w6z*w6x)*sin(q5))*...
                cos(q4)+(-(w6y^2-w6z^2)*sin(q6)-(dw6z-w6y*w6x)*cos(q6))*sin(q4))*sin(q3)+(((w6y^2-w6z^2)*...
                cos(q6)-(dw6z-w6y*w6x)*sin(q6))*sin(q5)+(dw6y+w6z*w6x)*cos(q5))*cos(q3))*cos(q2);
    Phi(1,21) = ((((cos(q6)*w6z*w6y+sin(q6)*w6z*w6x)*cos(q5)-dw6z*sin(q5))*cos(q4)+(-w6z*w6y*sin(q6)+w6z*w6x*...
                cos(q6))*sin(q4))*cos(q3)-((cos(q6)*w6z*w6y+sin(q6)*w6z*w6x)*sin(q5)+dw6z*cos(q5))*sin(q3))*...
                sin(q2)+((((cos(q6)*w6z*w6y+sin(q6)*w6z*w6x)*cos(q5)-dw6z*sin(q5))*cos(q4)+(-w6z*w6y*...
                sin(q6)+w6z*w6x*cos(q6))*sin(q4))*sin(q3)+((cos(q6)*w6z*w6y+sin(q6)*w6z*w6x)*sin(q5)+dw6z*...
                cos(q5))*cos(q3))*cos(q2);
    Phi(1,22) = 0;
    Phi(1,23) = dw1y;
    Phi(1,24) = -ddp1z*cos(q2)-r01x*(-dw2y+w2x*w2z);
    Phi(1,25) = dw2x*sin(q2)+w2x*w2z*cos(q2);
    Phi(1,26) = (dw2z+w2y*w2x)*sin(q2)+(w2z^2-w2x^2)*cos(q2);
    Phi(1,27) = w2z*(w2y*sin(q2)-w2x*cos(q2));
    Phi(1,28) = -ddp2z*cos(q3+q2)+cos(q2)*r12x*dw3z+cos(q2)*r12x*w3x*w3y+r01x*dw3z+r01x*w3x*w3y;
    Phi(1,29) = ddp2z*sin(q3+q2)-cos(q2)*r12x*dw3x+cos(q2)*r12x*w3z*w3y-r01x*dw3x+r01x*w3z*w3y;
    Phi(1,30) = dw3x*sin(q3+q2)-w3x*w3y*cos(q3+q2);
    Phi(1,31) = dw3z*sin(q3+q2)+w3y*w3x*sin(q3+q2)+dw3x*cos(q3+q2)-w3y*w3z*cos(q3+q2);
    Phi(1,32) = -w3y*w3z*sin(q3+q2)+w3x*w3y*cos(q3+q2);
    Phi(1,33) = (-ddp3z*cos(q4)*cos(q3)-(cos(q4)*ddp3x+sin(q4)*ddp3y+r23x*(sin(q4)*(dw4y+w4x*w4z)-cos(q4)*...
                (-w4x^2-w4y^2)))*sin(q3))*sin(q2)+(-ddp3z*cos(q4)*sin(q3)+(cos(q4)*ddp3x+sin(q4)*ddp3y+r23x*...
                (sin(q4)*(dw4y+w4x*w4z)-cos(q4)*(-w4x^2-w4y^2)))*cos(q3)-r12x*(-sin(q4)*(dw4y+w4x*...
                w4z)+cos(q4)*(-w4x^2-w4y^2)))*cos(q2)-r01x*(-sin(q4)*(dw4y+w4x*w4z)+cos(q4)*(-w4x^2-w4y^2));
    Phi(1,34) = 1/2*dw4x*sin(q2-q4+q3)+1/2*dw4x*sin(q2+q4+q3)+1/2*w4y*w4x*cos(q2+q4+q3)-1/2*w4y*w4x*...
                cos(q2-q4+q3)+w4z*w4x*cos(q3+q2);
    Phi(1,35) = -1/2*w4z*w4y*sin(q2-q4+q3)-1/2*w4z*w4y*sin(q2+q4+q3)-1/2*w4y*w4x*cos(q2+q4+q3)+1/2*w4y*w4x*...
                cos(q2-q4+q3)+dw4y*cos(q3+q2);
    Phi(1,36) = (((w4y^2-w4z^2)*cos(q4)+sin(q4)*(dw4y+w4x*w4z))*cos(q3)-(dw4z-w4y*w4x)*sin(q3))*...
                sin(q2)+(((w4y^2-w4z^2)*cos(q4)+sin(q4)*(dw4y+w4x*w4z))*sin(q3)+(dw4z-w4y*w4x)*cos(q3))*...
                cos(q2);
    Phi(1,37) = (((ddp4z*cos(q5)+r34y*(dw5x-w5y*w5z))*cos(q4)+(-cos(q5)*ddp4x-sin(q5)*ddp4y-r34y*(cos(q5)*...
                (dw5y+w5x*w5z)-sin(q5)*(-w5x^2-w5y^2)))*sin(q4))*cos(q3)-(ddp4z*sin(q5)+r23x*(sin(q4)*...
                (cos(q5)*(dw5y+w5x*w5z)-sin(q5)*(-w5x^2-w5y^2))-cos(q4)*(dw5x-w5y*w5z)))*sin(q3))*...
                sin(q2)+(((ddp4z*cos(q5)+r34y*(dw5x-w5y*w5z))*cos(q4)+(-cos(q5)*ddp4x-sin(q5)*ddp4y-r34y*...
                (cos(q5)*(dw5y+w5x*w5z)-sin(q5)*(-w5x^2-w5y^2)))*sin(q4))*sin(q3)+(ddp4z*sin(q5)+r23x*...
                (sin(q4)*(cos(q5)*(dw5y+w5x*w5z)-sin(q5)*(-w5x^2-w5y^2))-cos(q4)*(dw5x-w5y*w5z)))*...
                cos(q3)-r12x*(-sin(q4)*(cos(q5)*(dw5y+w5x*w5z)-sin(q5)*(-w5x^2-w5y^2))+cos(q4)*(dw5x-w5y*...
                w5z)))*cos(q2)-r01x*(-sin(q4)*(cos(q5)*(dw5y+w5x*w5z)-sin(q5)*(-w5x^2-w5y^2))+cos(q4)*...
                (dw5x-w5y*w5z));
    Phi(1,38) = (((dw5x*cos(q5)+w5y*w5x*sin(q5))*cos(q4)-w5z*w5x*sin(q4))*cos(q3)-(dw5x*sin(q5)-w5y*w5x*...
                cos(q5))*sin(q3))*sin(q2)+(((dw5x*cos(q5)+w5y*w5x*sin(q5))*cos(q4)-w5z*w5x*sin(q4))*...
                sin(q3)+(dw5x*sin(q5)-w5y*w5x*cos(q5))*cos(q3))*cos(q2);
    Phi(1,39) = (((-w5y*w5z*cos(q5)-w5y*w5x*sin(q5))*cos(q4)-dw5y*sin(q4))*cos(q3)-(-w5y*w5z*sin(q5)+w5y*w5x*...
                cos(q5))*sin(q3))*sin(q2)+(((-w5y*w5z*cos(q5)-w5y*w5x*sin(q5))*cos(q4)-dw5y*sin(q4))*...
                sin(q3)+(-w5y*w5z*sin(q5)+w5y*w5x*cos(q5))*cos(q3))*cos(q2);
    Phi(1,40) = ((((cos(q6)*dw6x-sin(q6)*w6z*w6x)*cos(q5)+w6y*w6x*sin(q5))*cos(q4)+(-dw6x*sin(q6)-w6z*w6x*...
                cos(q6))*sin(q4))*cos(q3)-((cos(q6)*dw6x-sin(q6)*w6z*w6x)*sin(q5)-w6y*w6x*cos(q5))*sin(q3))*...
                sin(q2)+((((cos(q6)*dw6x-sin(q6)*w6z*w6x)*cos(q5)+w6y*w6x*sin(q5))*cos(q4)+(-dw6x*sin(q6)-w6z*...
                w6x*cos(q6))*sin(q4))*sin(q3)+((cos(q6)*dw6x-sin(q6)*w6z*w6x)*sin(q5)-w6y*w6x*cos(q5))*...
                cos(q3))*cos(q2);
  % Coppia: 2
    Phi(2,1)  = -cos(q2)*ddp1x-sin(q2)*ddp1y;
    Phi(2,2)  = w2x^2-w2y^2;
    Phi(2,3)  = dw2y+w2x*w2z;
    Phi(2,4)  = -dw3x-w3y*w3z;
    Phi(2,5)  = -dw3z+w3y*w3x;
    Phi(2,6)  = 0;
    Phi(2,7)  = ddp3z*cos(q4)+r23x*(dw4z+w4x*w4y)+r12x*(sin(q3)*(cos(q4)*(-w4y^2-w4z^2)+sin(q4)*(-dw4y+w4x*...
                w4z))+cos(q3)*(dw4z+w4x*w4y));
    Phi(2,8)  = -sin(q4)*(dw4y-w4x*w4z)+(w4x^2-w4y^2)*cos(q4);
    Phi(2,9)  = -(dw4z+w4y*w4x)*sin(q4)+(dw4x-w4y*w4z)*cos(q4);
    Phi(2,10) = 0;
    Phi(2,11) = -(ddp4z*sin(q5)+r34y*(-dw5z-w5x*w5y))*sin(q4)+(-sin(q5)*ddp4x+cos(q5)*ddp4y-r34y*(cos(q5)*...
                (-w5y^2-w5z^2)-sin(q5)*(-dw5y+w5x*w5z)))*cos(q4)+r23x*(sin(q5)*(-w5y^2-w5z^2)+cos(q5)*...
                (-dw5y+w5x*w5z))+r12x*(sin(q3)*(cos(q4)*(cos(q5)*(-w5y^2-w5z^2)-sin(q5)*(-dw5y+w5x*...
                w5z))+sin(q4)*(-dw5z-w5x*w5y))+cos(q3)*(sin(q5)*(-w5y^2-w5z^2)+cos(q5)*(-dw5y+w5x*w5z)));
    Phi(2,12) = -((dw5y-w5z*w5x)*cos(q5)-(w5x^2-w5y^2)*sin(q5))*sin(q4)+(-dw5x-w5y*w5z)*cos(q4);
    Phi(2,13) = -((dw5z+w5y*w5x)*cos(q5)-(dw5x-w5y*w5z)*sin(q5))*sin(q4)+(-w5z^2+w5x^2)*cos(q4);
    Phi(2,14) = -((w5y^2-w5z^2)*cos(q5)-(dw5y+w5z*w5x)*sin(q5))*sin(q4)+(-dw5z+w5y*w5x)*cos(q4);
    Phi(2,15) = 0;
    Phi(2,16) = -(ddp5z*sin(q6)*cos(q5)-(-sin(q6)*ddp5x+cos(q6)*ddp5y)*sin(q5)+r34y*(-sin(q6)*...
                (-w6y^2-w6z^2)-cos(q6)*(dw6z+w6x*w6y)))*sin(q4)+(ddp5z*cos(q6)-r34y*(cos(q5)*(cos(q6)*...
                (-w6y^2-w6z^2)-sin(q6)*(dw6z+w6x*w6y))-sin(q5)*(-dw6y+w6x*w6z)))*cos(q4)+r23x*(sin(q5)*...
                (cos(q6)*(-w6y^2-w6z^2)-sin(q6)*(dw6z+w6x*w6y))+cos(q5)*(-dw6y+w6x*w6z))+r12x*(sin(q3)*...
                (cos(q4)*(cos(q5)*(cos(q6)*(-w6y^2-w6z^2)-sin(q6)*(dw6z+w6x*w6y))-sin(q5)*(-dw6y+w6x*...
                w6z))+sin(q4)*(-sin(q6)*(-w6y^2-w6z^2)-cos(q6)*(dw6z+w6x*w6y)))+cos(q3)*(sin(q5)*(cos(q6)*...
                (-w6y^2-w6z^2)-sin(q6)*(dw6z+w6x*w6y))+cos(q5)*(-dw6y+w6x*w6z)));
    Phi(2,17) = -(ddp5z*cos(q6)*cos(q5)-(-cos(q6)*ddp5x-sin(q6)*ddp5y)*sin(q5)+r34y*(-sin(q6)*(-dw6z+w6x*...
                w6y)-cos(q6)*(-w6z^2-w6x^2)))*sin(q4)+(-ddp5z*sin(q6)-r34y*(cos(q5)*(cos(q6)*(-dw6z+w6x*...
                w6y)-sin(q6)*(-w6z^2-w6x^2))-sin(q5)*(dw6x+w6y*w6z)))*cos(q4)+r23x*(sin(q5)*(cos(q6)*...
                (-dw6z+w6x*w6y)-sin(q6)*(-w6z^2-w6x^2))+cos(q5)*(dw6x+w6y*w6z))+r12x*(sin(q3)*(cos(q4)*...
                (cos(q5)*(cos(q6)*(-dw6z+w6x*w6y)-sin(q6)*(-w6z^2-w6x^2))-sin(q5)*(dw6x+w6y*w6z))+sin(q4)*...
                (-sin(q6)*(-dw6z+w6x*w6y)-cos(q6)*(-w6z^2-w6x^2)))+cos(q3)*(sin(q5)*(cos(q6)*(-dw6z+w6x*...
                w6y)-sin(q6)*(-w6z^2-w6x^2))+cos(q5)*(dw6x+w6y*w6z)));
    Phi(2,18) = -(((dw6y-w6z*w6x)*cos(q6)-(dw6x+w6y*w6z)*sin(q6))*cos(q5)-(w6x^2-w6y^2)*sin(q5))*...
                sin(q4)+(-(dw6y-w6z*w6x)*sin(q6)-(dw6x+w6y*w6z)*cos(q6))*cos(q4);
    Phi(2,19) = -(((dw6z+w6y*w6x)*cos(q6)-(w6z^2-w6x^2)*sin(q6))*cos(q5)-(dw6x-w6y*w6z)*sin(q5))*...
                sin(q4)+(-(dw6z+w6y*w6x)*sin(q6)-(w6z^2-w6x^2)*cos(q6))*cos(q4);
    Phi(2,20) = -(((w6y^2-w6z^2)*cos(q6)-(dw6z-w6y*w6x)*sin(q6))*cos(q5)-(dw6y+w6x*w6z)*sin(q5))*...
                sin(q4)+(-(w6y^2-w6z^2)*sin(q6)-(dw6z-w6y*w6x)*cos(q6))*cos(q4);
    Phi(2,21) = -((cos(q6)*w6y*w6z+w6x*w6z*sin(q6))*cos(q5)-dw6z*sin(q5))*sin(q4)+(-sin(q6)*w6y*w6z+w6x*w6z*...
                cos(q6))*cos(q4);
    Phi(2,22) = 0;
    Phi(2,23) = 0;
    Phi(2,24) = -sin(q2)*ddp1x+cos(q2)*ddp1y;
    Phi(2,25) = -w2y*w2x;
    Phi(2,26) = dw2x-w2y*w2z;
    Phi(2,27) = dw2z;
    Phi(2,28) = -sin(q3)*ddp2x+cos(q3)*ddp2y+r12x*(sin(q3)*(-w3y^2-w3z^2)+cos(q3)*(-dw3y+w3x*w3z));
    Phi(2,29) = -cos(q3)*ddp2x-sin(q3)*ddp2y+r12x*(sin(q3)*(dw3y+w3x*w3z)+cos(q3)*(-w3x^2-w3y^2));
    Phi(2,30) = -w3x*w3z;
    Phi(2,31) = -w3z^2+w3x^2;
    Phi(2,32) = -dw3y;
    Phi(2,33) = ddp3z*sin(q4)+r23x*(-dw4x+w4y*w4z)+r12x*(sin(q3)*(cos(q4)*(dw4y+w4x*w4z)+sin(q4)*...
                (-w4x^2-w4y^2))+cos(q3)*(-dw4x+w4y*w4z));
    Phi(2,34) = -sin(q4)*dw4x-cos(q4)*w4x*w4y;
    Phi(2,35) = w4y*(sin(q4)*w4z+w4x*cos(q4));
    Phi(2,36) = -(w4y^2-w4z^2)*sin(q4)+(dw4y+w4x*w4z)*cos(q4);
    Phi(2,37) = -(ddp4z*cos(q5)+r34y*(dw5x-w5y*w5z))*sin(q4)+(-cos(q5)*ddp4x-sin(q5)*ddp4y-r34y*(cos(q5)*...
                (dw5y+w5z*w5x)-sin(q5)*(-w5x^2-w5y^2)))*cos(q4)+r23x*(sin(q5)*(dw5y+w5z*w5x)+cos(q5)*...
                (-w5x^2-w5y^2))+r12x*(sin(q3)*(cos(q4)*(cos(q5)*(dw5y+w5z*w5x)-sin(q5)*...
                (-w5x^2-w5y^2))+sin(q4)*(dw5x-w5y*w5z))+cos(q3)*(sin(q5)*(dw5y+w5z*w5x)+cos(q5)*...
                (-w5x^2-w5y^2)));
    Phi(2,38) = -(dw5x*cos(q5)+w5y*w5x*sin(q5))*sin(q4)-w5z*w5x*cos(q4);
    Phi(2,39) = -(-w5y*w5z*cos(q5)-w5y*w5x*sin(q5))*sin(q4)-dw5y*cos(q4);
    Phi(2,40) = -((dw6x*cos(q6)-w6z*w6x*sin(q6))*cos(q5)+w6y*w6x*sin(q5))*sin(q4)+(-dw6x*sin(q6)-w6z*w6x*...
                cos(q6))*cos(q4);
  % Coppia: 3
    Phi(3,1)  = 0;
    Phi(3,2)  = 0;
    Phi(3,3)  = 0;
    Phi(3,4)  = dw3x+w3z*w3y;
    Phi(3,5)  = dw3z-w3x*w3y;
    Phi(3,6)  = -ddq3;
    Phi(3,7)  = -ddp3z*cos(q4)-r23x*(dw4z+w4y*w4x);
    Phi(3,8)  = (dw4y-w4x*w4z)*sin(q4)-(w4x^2-w4y^2)*cos(q4);
    Phi(3,9)  = (dw4z+w4y*w4x)*sin(q4)-(dw4x-w4y*w4z)*cos(q4);
    Phi(3,10) = 0;
    Phi(3,11) = (ddp4z*sin(q5)+r34y*(-dw5z-w5x*w5y))*sin(q4)-(-sin(q5)*ddp4x+cos(q5)*ddp4y-r34y*(cos(q5)*...
                (-w5y^2-w5z^2)-sin(q5)*(-dw5y+w5x*w5z)))*cos(q4)-r23x*(sin(q5)*(-w5y^2-w5z^2)+cos(q5)*...
                (-dw5y+w5x*w5z));
    Phi(3,12) = ((dw5y-w5x*w5z)*cos(q5)-(w5x^2-w5y^2)*sin(q5))*sin(q4)-(-dw5x-w5y*w5z)*cos(q4);
    Phi(3,13) = ((dw5z+w5x*w5y)*cos(q5)-(dw5x-w5y*w5z)*sin(q5))*sin(q4)-(-w5z^2+w5x^2)*cos(q4);
    Phi(3,14) = ((w5y^2-w5z^2)*cos(q5)-(dw5y+w5x*w5z)*sin(q5))*sin(q4)-(-dw5z+w5x*w5y)*cos(q4);
    Phi(3,15) = 0;
    Phi(3,16) = (ddp5z*sin(q6)*cos(q5)-(-sin(q6)*ddp5x+cos(q6)*ddp5y)*sin(q5)+r34y*(-sin(q6)*...
                (-w6y^2-w6z^2)-cos(q6)*(dw6z+w6y*w6x)))*sin(q4)-(ddp5z*cos(q6)-r34y*(cos(q5)*(cos(q6)*...
                (-w6y^2-w6z^2)-(dw6z+w6y*w6x)*sin(q6))-sin(q5)*(-dw6y+w6z*w6x)))*cos(q4)-r23x*(sin(q5)*...
                (cos(q6)*(-w6y^2-w6z^2)-(dw6z+w6y*w6x)*sin(q6))+cos(q5)*(-dw6y+w6z*w6x));
    Phi(3,17) = (ddp5z*cos(q6)*cos(q5)-(-cos(q6)*ddp5x-sin(q6)*ddp5y)*sin(q5)+r34y*(-sin(q6)*(-dw6z+w6y*...
                w6x)-cos(q6)*(-w6z^2-w6x^2)))*sin(q4)-(-ddp5z*sin(q6)-r34y*(cos(q5)*((-dw6z+w6y*w6x)*...
                cos(q6)-sin(q6)*(-w6z^2-w6x^2))-sin(q5)*(dw6x+w6z*w6y)))*cos(q4)-r23x*(sin(q5)*((-dw6z+w6y*...
                w6x)*cos(q6)-sin(q6)*(-w6z^2-w6x^2))+cos(q5)*(dw6x+w6z*w6y));
    Phi(3,18) = (((dw6y-w6z*w6x)*cos(q6)-(dw6x+w6z*w6y)*sin(q6))*cos(q5)-(w6x^2-w6y^2)*sin(q5))*...
                sin(q4)-(-(dw6y-w6z*w6x)*sin(q6)-(dw6x+w6z*w6y)*cos(q6))*cos(q4);
    Phi(3,19) = ((cos(q6)*(dw6z+w6y*w6x)-(w6z^2-w6x^2)*sin(q6))*cos(q5)-(dw6x-w6z*w6y)*sin(q5))*...
                sin(q4)-(-(dw6z+w6y*w6x)*sin(q6)-(w6z^2-w6x^2)*cos(q6))*cos(q4);
    Phi(3,20) = (((w6y^2-w6z^2)*cos(q6)-(dw6z-w6y*w6x)*sin(q6))*cos(q5)-(dw6y+w6z*w6x)*sin(q5))*...
                sin(q4)-(-(w6y^2-w6z^2)*sin(q6)-(dw6z-w6y*w6x)*cos(q6))*cos(q4);
    Phi(3,21) = ((cos(q6)*w6z*w6y+sin(q6)*w6z*w6x)*cos(q5)-dw6z*sin(q5))*sin(q4)-(-w6z*w6y*sin(q6)+w6z*w6x*...
                cos(q6))*cos(q4);
    Phi(3,22) = 0;
    Phi(3,23) = 0;
    Phi(3,24) = 0;
    Phi(3,25) = 0;
    Phi(3,26) = 0;
    Phi(3,27) = 0;
    Phi(3,28) = sin(q3)*ddp2x-cos(q3)*ddp2y;
    Phi(3,29) = cos(q3)*ddp2x+sin(q3)*ddp2y;
    Phi(3,30) = w3z*w3x;
    Phi(3,31) = w3z^2-w3x^2;
    Phi(3,32) = dw3y;
    Phi(3,33) = -ddp3z*sin(q4)-r23x*(-dw4x+w4y*w4z);
    Phi(3,34) = dw4x*sin(q4)+w4x*w4y*cos(q4);
    Phi(3,35) = -w4y*(sin(q4)*w4z+w4x*cos(q4));
    Phi(3,36) = (w4y^2-w4z^2)*sin(q4)-(dw4y+w4x*w4z)*cos(q4);
    Phi(3,37) = (ddp4z*cos(q5)+r34y*(dw5x-w5y*w5z))*sin(q4)-(-cos(q5)*ddp4x-sin(q5)*ddp4y-r34y*(cos(q5)*...
                (dw5y+w5x*w5z)-sin(q5)*(-w5x^2-w5y^2)))*cos(q4)-r23x*((dw5y+w5x*w5z)*sin(q5)+cos(q5)*...
                (-w5x^2-w5y^2));
    Phi(3,38) = (dw5x*cos(q5)+w5y*w5x*sin(q5))*sin(q4)+w5x*w5z*cos(q4);
    Phi(3,39) = (-w5y*w5z*cos(q5)-w5y*w5x*sin(q5))*sin(q4)+dw5y*cos(q4);
    Phi(3,40) = ((cos(q6)*dw6x-sin(q6)*w6z*w6x)*cos(q5)+w6y*w6x*sin(q5))*sin(q4)-(-dw6x*sin(q6)-w6z*w6x*...
                cos(q6))*cos(q4);
  % Coppia: 4
    Phi(4,1)  = 0;
    Phi(4,2)  = 0;
    Phi(4,3)  = 0;
    Phi(4,4)  = 0;
    Phi(4,5)  = 0;
    Phi(4,6)  = 0;
    Phi(4,7)  = sin(q4)*ddp3x-cos(q4)*ddp3y;
    Phi(4,8)  = -dw4x-w4y*w4z;
    Phi(4,9)  = -w4z^2+w4x^2;
    Phi(4,10) = -ddq4;
    Phi(4,11) = ddp4z*cos(q5)+k54*(-sin(q5)*ddp4x+cos(q5)*ddp4y);
    Phi(4,12) = -(dw5y-w5x*w5z)*sin(q5)-(w5x^2-w5y^2)*cos(q5)+k54*(-dw5x-w5y*w5z);
    Phi(4,13) = -(dw5z+w5x*w5y)*sin(q5)-(dw5x-w5y*w5z)*cos(q5)+k54*(-w5z^2+w5x^2);
    Phi(4,14) = -(w5y^2-w5z^2)*sin(q5)-cos(q5)*(dw5y+w5x*w5z)+k54*(-dw5z+w5x*w5y);
    Phi(4,15) = 0;
    Phi(4,16) = -ddp5z*sin(q6)*sin(q5)-(-sin(q6)*ddp5x+cos(q6)*ddp5y)*cos(q5)+k54*ddp5z*cos(q6)-k64*(-sin(q6)*...
                ddp5x+cos(q6)*ddp5y);
    Phi(4,17) = -ddp5z*cos(q6)*sin(q5)-(-cos(q6)*ddp5x-sin(q6)*ddp5y)*cos(q5)-k54*ddp5z*sin(q6)-k64*(-cos(q6)*...
                ddp5x-sin(q6)*ddp5y);
    Phi(4,18) = -((dw6y-w6z*w6x)*cos(q6)-(dw6x+w6z*w6y)*sin(q6))*sin(q5)-(w6x^2-w6y^2)*cos(q5)+k54*...
                (-(dw6y-w6z*w6x)*sin(q6)-(dw6x+w6z*w6y)*cos(q6))-k64*(w6x^2-w6y^2);
    Phi(4,19) = -(cos(q6)*(dw6z+w6y*w6x)-(w6z^2-w6x^2)*sin(q6))*sin(q5)-(dw6x-w6z*w6y)*cos(q5)+k54*...
                (-(dw6z+w6y*w6x)*sin(q6)-(w6z^2-w6x^2)*cos(q6))-k64*(dw6x-w6z*w6y);
    Phi(4,20) = -((w6y^2-w6z^2)*cos(q6)-(dw6z-w6y*w6x)*sin(q6))*sin(q5)-(dw6y+w6z*w6x)*cos(q5)+k54*...
                (-(w6y^2-w6z^2)*sin(q6)-(dw6z-w6y*w6x)*cos(q6))-k64*(dw6y+w6z*w6x);
    Phi(4,21) = -(cos(q6)*w6z*w6y+sin(q6)*w6z*w6x)*sin(q5)-dw6z*cos(q5)+k54*w6z*(-w6y*sin(q6)+w6x*...
                cos(q6))-k64*dw6z;
    Phi(4,22) = 0;
    Phi(4,23) = 0;
    Phi(4,24) = 0;
    Phi(4,25) = 0;
    Phi(4,26) = 0;
    Phi(4,27) = 0;
    Phi(4,28) = 0;
    Phi(4,29) = 0;
    Phi(4,30) = 0;
    Phi(4,31) = 0;
    Phi(4,32) = 0;
    Phi(4,33) = -cos(q4)*ddp3x-sin(q4)*ddp3y;
    Phi(4,34) = -w4x*w4z;
    Phi(4,35) = -dw4y;
    Phi(4,36) = -dw4z+w4y*w4x;
    Phi(4,37) = -ddp4z*sin(q5)+k54*(-cos(q5)*ddp4x-sin(q5)*ddp4y);
    Phi(4,38) = -dw5x*sin(q5)+w5y*w5x*cos(q5)-k54*w5x*w5z;
    Phi(4,39) = -w5y*(-w5z*sin(q5)+w5x*cos(q5))-k54*dw5y;
    Phi(4,40) = -(cos(q6)*dw6x-sin(q6)*w6z*w6x)*sin(q5)+w6y*w6x*cos(q5)+k54*(-dw6x*sin(q6)-w6z*w6x*...
                cos(q6))+k64*w6y*w6x;
  % Coppia: 5
    Phi(5,1)  = 0;
    Phi(5,2)  = 0;
    Phi(5,3)  = 0;
    Phi(5,4)  = 0;
    Phi(5,5)  = 0;
    Phi(5,6)  = 0;
    Phi(5,7)  = 0;
    Phi(5,8)  = 0;
    Phi(5,9)  = 0;
    Phi(5,10) = 0;
    Phi(5,11) = -sin(q5)*ddp4x+cos(q5)*ddp4y;
    Phi(5,12) = -dw5x-w5y*w5z;
    Phi(5,13) = -w5z^2+w5x^2;
    Phi(5,14) = -dw5z+w5x*w5y;
    Phi(5,15) = k54*ddq4+ddq5;
    Phi(5,16) = ddp5z*cos(q6)-k65*(-sin(q6)*ddp5x+cos(q6)*ddp5y);
    Phi(5,17) = -ddp5z*sin(q6)-k65*(-cos(q6)*ddp5x-sin(q6)*ddp5y);
    Phi(5,18) = -(dw6y-w6z*w6x)*sin(q6)-(dw6x+w6z*w6y)*cos(q6)-k65*(w6x^2-w6y^2);
    Phi(5,19) = -(dw6z+w6y*w6x)*sin(q6)-(w6z^2-w6x^2)*cos(q6)-k65*(dw6x-w6z*w6y);
    Phi(5,20) = -(w6y^2-w6z^2)*sin(q6)-(dw6z-w6y*w6x)*cos(q6)-k65*(dw6y+w6z*w6x);
    Phi(5,21) = w6z*(-w6y*sin(q6)+w6x*cos(q6))-k65*dw6z;
    Phi(5,22) = 0;
    Phi(5,23) = 0;
    Phi(5,24) = 0;
    Phi(5,25) = 0;
    Phi(5,26) = 0;
    Phi(5,27) = 0;
    Phi(5,28) = 0;
    Phi(5,29) = 0;
    Phi(5,30) = 0;
    Phi(5,31) = 0;
    Phi(5,32) = 0;
    Phi(5,33) = 0;
    Phi(5,34) = 0;
    Phi(5,35) = 0;
    Phi(5,36) = 0;
    Phi(5,37) = -cos(q5)*ddp4x-sin(q5)*ddp4y;
    Phi(5,38) = -w5x*w5z;
    Phi(5,39) = -dw5y;
    Phi(5,40) = -dw6x*sin(q6)-w6z*w6x*cos(q6)+k65*w6y*w6x;
  % Coppia: 6
    Phi(6,1)  = 0;
    Phi(6,2)  = 0;
    Phi(6,3)  = 0;
    Phi(6,4)  = 0;
    Phi(6,5)  = 0;
    Phi(6,6)  = 0;
    Phi(6,7)  = 0;
    Phi(6,8)  = 0;
    Phi(6,9)  = 0;
    Phi(6,10) = 0;
    Phi(6,11) = 0;
    Phi(6,12) = 0;
    Phi(6,13) = 0;
    Phi(6,14) = 0;
    Phi(6,15) = 0;
    Phi(6,16) = sin(q6)*ddp5x-cos(q6)*ddp5y;
    Phi(6,17) = cos(q6)*ddp5x+sin(q6)*ddp5y;
    Phi(6,18) = -w6x^2+w6y^2;
    Phi(6,19) = -dw6x+w6z*w6y;
    Phi(6,20) = -dw6y-w6z*w6x;
    Phi(6,21) = -dw6z;
    Phi(6,22) = (k64-k54*k65)*ddq4-k65*ddq5-ddq6;
    Phi(6,23) = 0;
    Phi(6,24) = 0;
    Phi(6,25) = 0;
    Phi(6,26) = 0;
    Phi(6,27) = 0;
    Phi(6,28) = 0;
    Phi(6,29) = 0;
    Phi(6,30) = 0;
    Phi(6,31) = 0;
    Phi(6,32) = 0;
    Phi(6,33) = 0;
    Phi(6,34) = 0;
    Phi(6,35) = 0;
    Phi(6,36) = 0;
    Phi(6,37) = 0;
    Phi(6,38) = 0;
    Phi(6,39) = 0;
    Phi(6,40) = w6y*w6x;
    
    % [n,k] = size(Phi);
    n = 6; k=40;
    
    soglia = 0.5;
    for i = 1 : n
        % attrito statico
        if abs(dqm(i)) > soglia
            % modifiche senza attrito -> moltiplicare per 0 dmq(i). 0 commento  
            Phi(i,k+1+2*(i-1)) = dqm(i)/abs(dqm(i));
        else
            % modifiche senza attrito -> moltiplicare per 0 dmq(i). 
            Phi(i,k+1+2*(i-1)) = dqm(i)/soglia;
        end % if
        % attrito viscoso
        Phi(i,k+2*i) = dqm(i);
    end 
% Contributi dovuti agli attriti
%     [n,k] = size(Phi);
%     for i = 1 : n
%       % attrito statico
%         if abs(dqm(i)) > soglia
%           Phi(i,k+1+2*(i-1)) = dqm(i)/abs(dqm(i));
%         else
%           Phi(i,k+1+2*(i-1)) = dqm(i)/soglia;
%         end % if
%       % attrito viscoso
%         Phi(i,k+2*i) = dqm(i);
%     end % for i
H = [    -1     0     0     0     0     0
          0     1     0     0     0     0
          0     0    -1     0     0     0
          0     0     0    -1     0     0
          0     0     0     0     1     0
          0     0     0     0     0    -1];
Phi = (H')^-1*Phi;