function [w,dw,ddp] = ricforw(q,dq,ddq)
%
% SIX - Gennaio 2005
%
% [w,dw,ddp] = ricforw(q,dq,ddq)
%
% Calcola, in numerico, le velocit� e le accelerazioni delle terne
%
% Ingressi:
%   q, dq, ddq : vettori 6x1 contenenti le posizioni (in deg), le velocit� (in deg/sec) e le accelerazioni (in deg/sec^2)
%                ai giunti in convenzione COMAU 
% Uscite:
%   matrici 3x6 con i vettori in colonna
%     w   = [w1x   w2x   w3x   w4x   w5x   w6x 
%            w1y   w2y   w3y   w4y   w5y   w6y 
%            w1z   w2z   w3z   w4z   w5z   w6z  ]
%         velocit� angolari delle terne in rad/sec in convenzione DH
%     dw  = [dw1x  dw2x  dw3x  dw4x  dw5x  dw6x 
%            dw1y  dw2y  dw3y  dw4y  dw5y  dw6y 
%            dw1z  dw2z  dw3z  dw4z  dw5z  dw6z ]   
%         accelerazioni angolari delle terne in rad/sec^2 in convenzione DH
%     ddp = [ddp1x ddp2x ddp3x ddp4x ddp5x ddp6x
%            ddp1y ddp2y ddp3y ddp4y ddp5y ddp6y
%            ddp1z ddp2z ddp3z ddp4z ddp5z ddp6z]
%         accelerazioni lineari delle terne in m/sec^2 in convenzione DH
% File letti:
%   costanti.m : definzione delle costanti per la dinamica


%************************************************************************************************************************
% Legge i dati contenuti nel file "costanti.m"
%************************************************************************************************************************

  costanti;


%************************************************************************************************************************
% Conversione delle grandezze
%************************************************************************************************************************

% Posizioni ai giunti
  % converte posizioni comau in gradi in posizioni dh in gradi
    qdh_deg  = comau2dh(q);
  % converte posizioni dh in gradi in posizioni dh in radianti
    qdh  = qdh_deg * (pi/180);
    
     
  % rinomina le variabili delle posizioni: le variabili qi saranno le posizioni dh in radianti
    q1 = qdh(1); q2 = qdh(2); q3 = qdh(3); q4 = qdh(4); q5 = qdh(5); q6 = qdh(6);
% Velocit� ai giunti
  % converte velocit� comau in deg/sec in velocit� dh in deg/sec
    dqdh_deg = comau2dh_vel(dq);
  % converte velocit� dh in deg/sec in velocit� dh in rad/sec
    dqdh = dqdh_deg * (pi/180);
     
  % rinomina le variabili delle velocit�: le variabili dqi saranno le velocit� dh in rad/sec
    dq1 = dqdh(1); dq2 = dqdh(2); dq3 = dqdh(3); dq4 = dqdh(4); dq5 = dqdh(5); dq6 = dqdh(6);
% Accelerazioni ai giunti
  % converte accelerazioni comau in deg/sec^2 in accelerazioni dh in deg/sec^2 
    ddqdh_deg = comau2dh_vel(ddq);
  % converte accelerazioni dh in deg/sec^2 in accelerazioni dh in rad/sec^2
    ddqdh = ddqdh_deg * (pi/180);
    
  % rinomina le variabili delle accelerazioni: le variabili ddqi saranno le accelerazioni dh in rad/sec^2
    ddq1  = ddqdh(1); ddq2  = ddqdh(2); ddq3  = ddqdh(3); ddq4  = ddqdh(4); ddq5  = ddqdh(5); ddq6  = ddqdh(6);

    
   
    
    
%************************************************************************************************************************
% Cinematica diretta (codice presente in "cinematica.txt")
%************************************************************************************************************************

% Velocit� angolari w delle terne
 
 w0x   = 0;
 w0y   = 0;
 w0z   = 0;
 
 w1x   = 0;
 w1y   = -dq1;
 w1z   = 0;
 
 w2x   = -sin(q2)*dq1;
 w2y   = -cos(q2)*dq1;
 w2z   = dq2;
 
 w3x   = -dq1*sin(q3+q2);
 w3y   = -dq2-dq3;
 w3z   = -dq1*cos(q3+q2);
 
 w4x   = -cos(q4)*dq1*sin(q3+q2)+sin(q4)*(-dq2-dq3);
 w4y   = -dq1*cos(q3+q2)+dq4;
 w4z   = -sin(q4)*dq1*sin(q3+q2)-cos(q4)*(-dq2-dq3);
 
 w5x   = cos(q5)*(-cos(q4)*dq1*sin(q3+q2)+sin(q4)*(-dq2-dq3))+sin(q5)*(-dq1*cos(q3+q2)+dq4);
 w5y   = sin(q4)*dq1*sin(q3+q2)+cos(q4)*(-dq2-dq3)-dq5;
 w5z   = -sin(q5)*(-cos(q4)*dq1*sin(q3+q2)+sin(q4)*(-dq2-dq3))+cos(q5)*(-dq1*cos(q3+q2)+dq4);
 
 w6x   = cos(q6)*(cos(q5)*(-cos(q4)*dq1*sin(q3+q2)+sin(q4)*(-dq2-dq3))+sin(q5)*(-dq1*cos(q3+q2)+dq4))+sin(q6)*...
         (sin(q4)*dq1*sin(q3+q2)+cos(q4)*(-dq2-dq3)-dq5);
 w6y   = -sin(q6)*(cos(q5)*(-cos(q4)*dq1*sin(q3+q2)+sin(q4)*(-dq2-dq3))+sin(q5)*(-dq1*...
         cos(q3+q2)+dq4))+cos(q6)*(sin(q4)*dq1*sin(q3+q2)+cos(q4)*(-dq2-dq3)-dq5);
 w6z   = -sin(q5)*(-cos(q4)*dq1*sin(q3+q2)+sin(q4)*(-dq2-dq3))+cos(q5)*(-dq1*cos(q3+q2)+dq4)+dq6;
 
 
% Accelerazioni angolari dw delle terne
 
 dw0x  = 0;
 dw0y  = 0;
 dw0z  = 0;
 
 dw1x  = 0;
 dw1y  = -ddq1;
 dw1z  = 0;
 
 dw2x  = cos(q2)*dq2*w1y-sin(q2)*ddq1;
 dw2y  = -sin(q2)*dq2*w1y-cos(q2)*ddq1;
 dw2z  = ddq2;
 
 dw3x  = dq2*w1y*cos(q3+q2)-ddq1*sin(q3+q2)+cos(q3)*dq3*w2y-sin(q3)*dq3*w2x;
 dw3y  = -ddq2-ddq3;
 dw3z  = -dq2*w1y*sin(q3+q2)-ddq1*cos(q3+q2)-sin(q3)*dq3*w2y-cos(q3)*dq3*w2x;
 
 dw4x  = cos(q4)*(dq2*w1y*cos(q3+q2)-ddq1*sin(q3+q2)+cos(q3)*dq3*w2y-sin(q3)*dq3*w2x+dq4*w3y)+sin(q4)*...
         (-ddq2-ddq3-dq4*w3x);
 dw4y  = -dq2*w1y*sin(q3+q2)-ddq1*cos(q3+q2)-sin(q3)*dq3*w2y-cos(q3)*dq3*w2x+ddq4;
 dw4z  = sin(q4)*(dq2*w1y*cos(q3+q2)-ddq1*sin(q3+q2)+cos(q3)*dq3*w2y-sin(q3)*dq3*w2x+dq4*w3y)-cos(q4)*...
         (-ddq2-ddq3-dq4*w3x);
 
 dw5x  = cos(q5)*(cos(q4)*(dq2*w1y*cos(q3+q2)-ddq1*sin(q3+q2)+cos(q3)*dq3*w2y-sin(q3)*dq3*w2x+dq4*...
         w3y)+sin(q4)*(-ddq2-ddq3-dq4*w3x)+dq5*w4y)+sin(q5)*(-dq2*w1y*sin(q3+q2)-ddq1*cos(q3+q2)-sin(q3)*dq3*...
         w2y-cos(q3)*dq3*w2x+ddq4-dq5*w4x);
 dw5y  = -sin(q4)*(dq2*w1y*cos(q3+q2)-ddq1*sin(q3+q2)+cos(q3)*dq3*w2y-sin(q3)*dq3*w2x+dq4*w3y)+cos(q4)*...
         (-ddq2-ddq3-dq4*w3x)-ddq5;
 dw5z  = -sin(q5)*(cos(q4)*(dq2*w1y*cos(q3+q2)-ddq1*sin(q3+q2)+cos(q3)*dq3*w2y-sin(q3)*dq3*w2x+dq4*...
         w3y)+sin(q4)*(-ddq2-ddq3-dq4*w3x)+dq5*w4y)+cos(q5)*(-dq2*w1y*sin(q3+q2)-ddq1*cos(q3+q2)-sin(q3)*dq3*...
         w2y-cos(q3)*dq3*w2x+ddq4-dq5*w4x);
 
 dw6x  = cos(q6)*(cos(q5)*(cos(q4)*(dq2*w1y*cos(q3+q2)-ddq1*sin(q3+q2)+cos(q3)*dq3*w2y-sin(q3)*dq3*w2x+dq4*...
         w3y)+sin(q4)*(-ddq2-ddq3-dq4*w3x)+dq5*w4y)+sin(q5)*(-dq2*w1y*sin(q3+q2)-ddq1*cos(q3+q2)-sin(q3)*dq3*...
         w2y-cos(q3)*dq3*w2x+ddq4-dq5*w4x)+dq6*w5y)+sin(q6)*(-sin(q4)*(dq2*w1y*cos(q3+q2)-ddq1*...
         sin(q3+q2)+cos(q3)*dq3*w2y-sin(q3)*dq3*w2x+dq4*w3y)+cos(q4)*(-ddq2-ddq3-dq4*w3x)-ddq5-dq6*w5x);
 dw6y  = -sin(q6)*(cos(q5)*(cos(q4)*(dq2*w1y*cos(q3+q2)-ddq1*sin(q3+q2)+cos(q3)*dq3*w2y-sin(q3)*dq3*w2x+dq4*...
         w3y)+sin(q4)*(-ddq2-ddq3-dq4*w3x)+dq5*w4y)+sin(q5)*(-dq2*w1y*sin(q3+q2)-ddq1*cos(q3+q2)-sin(q3)*dq3*...
         w2y-cos(q3)*dq3*w2x+ddq4-dq5*w4x)+dq6*w5y)+cos(q6)*(-sin(q4)*(dq2*w1y*cos(q3+q2)-ddq1*...
         sin(q3+q2)+cos(q3)*dq3*w2y-sin(q3)*dq3*w2x+dq4*w3y)+cos(q4)*(-ddq2-ddq3-dq4*w3x)-ddq5-dq6*w5x);
 dw6z  = -sin(q5)*(cos(q4)*(dq2*w1y*cos(q3+q2)-ddq1*sin(q3+q2)+cos(q3)*dq3*w2y-sin(q3)*dq3*w2x+dq4*...
         w3y)+sin(q4)*(-ddq2-ddq3-dq4*w3x)+dq5*w4y)+cos(q5)*(-dq2*w1y*sin(q3+q2)-ddq1*cos(q3+q2)-sin(q3)*dq3*...
         w2y-cos(q3)*dq3*w2x+ddq4-dq5*w4x)+ddq6;
 
 
% Accelerazioni lineari ddp delle terne
 
 ddp0x = -gx;
 ddp0y = -gy;
 ddp0z = -gz;
 
 ddp1x = -cos(q1)*gx-sin(q1)*gy-w1y^2*r01x;
 ddp1y = gz;
 ddp1z = sin(q1)*gx-cos(q1)*gy-dw1y*r01x;
 
 ddp2x = cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*r12x;
 ddp2y = -sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x;
 ddp2z = sin(q1)*gx-cos(q1)*gy-dw1y*r01x-dw2y*r12x+w2x*w2z*r12x;
  
 ddp3x = cos(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*r12x)+sin(q3)*...
         (-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-w3y^2*r23x-w3z^2*...
         r23x;
 ddp3y = -sin(q1)*gx+cos(q1)*gy+dw1y*r01x+dw2y*r12x-w2x*w2z*r12x+dw3z*r23x+w3x*w3y*r23x;
 ddp3z = -sin(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*r12x)+cos(q3)*...
         (-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-dw3y*r23x+w3x*w3z*...
         r23x;
 
 ddp4x = cos(q4)*(cos(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*...
         r12x)+sin(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-w3y^2*...
         r23x-w3z^2*r23x)+sin(q4)*(-sin(q1)*gx+cos(q1)*gy+dw1y*r01x+dw2y*r12x-w2x*w2z*r12x+dw3z*r23x+w3x*w3y*...
         r23x)-dw4z*r34y+w4y*w4x*r34y;
 ddp4y = -sin(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*r12x)+cos(q3)*...
         (-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-dw3y*r23x+w3x*w3z*...
         r23x-w4z^2*r34y-w4x^2*r34y;
 ddp4z = sin(q4)*(cos(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*...
         r12x)+sin(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-w3y^2*...
         r23x-w3z^2*r23x)-cos(q4)*(-sin(q1)*gx+cos(q1)*gy+dw1y*r01x+dw2y*r12x-w2x*w2z*r12x+dw3z*r23x+w3x*w3y*...
         r23x)+dw4x*r34y+w4y*w4z*r34y;
 
 ddp5x = cos(q5)*(cos(q4)*(cos(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*...
         r12x)+sin(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-w3y^2*...
         r23x-w3z^2*r23x)+sin(q4)*(-sin(q1)*gx+cos(q1)*gy+dw1y*r01x+dw2y*r12x-w2x*w2z*r12x+dw3z*r23x+w3x*w3y*...
         r23x)-dw4z*r34y+w4y*w4x*r34y)+sin(q5)*(-sin(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*...
         gz-w2y^2*r12x-w2z^2*r12x)+cos(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*...
         r12x+w2x*w2y*r12x)-dw3y*r23x+w3x*w3z*r23x-w4z^2*r34y-w4x^2*r34y);
 ddp5y = -sin(q4)*(cos(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*...
         r12x)+sin(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-w3y^2*...
         r23x-w3z^2*r23x)+cos(q4)*(-sin(q1)*gx+cos(q1)*gy+dw1y*r01x+dw2y*r12x-w2x*w2z*r12x+dw3z*r23x+w3x*w3y*...
         r23x)-dw4x*r34y-w4y*w4z*r34y;
 ddp5z = -sin(q5)*(cos(q4)*(cos(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*...
         r12x)+sin(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-w3y^2*...
         r23x-w3z^2*r23x)+sin(q4)*(-sin(q1)*gx+cos(q1)*gy+dw1y*r01x+dw2y*r12x-w2x*w2z*r12x+dw3z*r23x+w3x*w3y*...
         r23x)-dw4z*r34y+w4y*w4x*r34y)+cos(q5)*(-sin(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*...
         gz-w2y^2*r12x-w2z^2*r12x)+cos(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*...
         r12x+w2x*w2y*r12x)-dw3y*r23x+w3x*w3z*r23x-w4z^2*r34y-w4x^2*r34y);
 
 ddp6x = cos(q6)*(cos(q5)*(cos(q4)*(cos(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*...
         r12x-w2z^2*r12x)+sin(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*...
         r12x)-w3y^2*r23x-w3z^2*r23x)+sin(q4)*(-sin(q1)*gx+cos(q1)*gy+dw1y*r01x+dw2y*r12x-w2x*w2z*r12x+dw3z*...
         r23x+w3x*w3y*r23x)-dw4z*r34y+w4y*w4x*r34y)+sin(q5)*(-sin(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*...
         r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*r12x)+cos(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*...
         r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-dw3y*r23x+w3x*w3z*r23x-w4z^2*r34y-w4x^2*r34y))+sin(q6)*...
         (-sin(q4)*(cos(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*...
         r12x)+sin(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-w3y^2*...
         r23x-w3z^2*r23x)+cos(q4)*(-sin(q1)*gx+cos(q1)*gy+dw1y*r01x+dw2y*r12x-w2x*w2z*r12x+dw3z*r23x+w3x*w3y*...
         r23x)-dw4x*r34y-w4y*w4z*r34y)+dw6y*r56z+w6z*w6x*r56z;
 ddp6y = -sin(q6)*(cos(q5)*(cos(q4)*(cos(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*...
         r12x-w2z^2*r12x)+sin(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*...
         r12x)-w3y^2*r23x-w3z^2*r23x)+sin(q4)*(-sin(q1)*gx+cos(q1)*gy+dw1y*r01x+dw2y*r12x-w2x*w2z*r12x+dw3z*...
         r23x+w3x*w3y*r23x)-dw4z*r34y+w4y*w4x*r34y)+sin(q5)*(-sin(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*...
         r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*r12x)+cos(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*...
         r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-dw3y*r23x+w3x*w3z*r23x-w4z^2*r34y-w4x^2*r34y))+cos(q6)*...
         (-sin(q4)*(cos(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*...
         r12x)+sin(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-w3y^2*...
         r23x-w3z^2*r23x)+cos(q4)*(-sin(q1)*gx+cos(q1)*gy+dw1y*r01x+dw2y*r12x-w2x*w2z*r12x+dw3z*r23x+w3x*w3y*...
         r23x)-dw4x*r34y-w4y*w4z*r34y)-dw6x*r56z+w6z*w6y*r56z;
 ddp6z = -sin(q5)*(cos(q4)*(cos(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*gz-w2y^2*r12x-w2z^2*...
         r12x)+sin(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*r12x+w2x*w2y*r12x)-w3y^2*...
         r23x-w3z^2*r23x)+sin(q4)*(-sin(q1)*gx+cos(q1)*gy+dw1y*r01x+dw2y*r12x-w2x*w2z*r12x+dw3z*r23x+w3x*w3y*...
         r23x)-dw4z*r34y+w4y*w4x*r34y)+cos(q5)*(-sin(q3)*(cos(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+sin(q2)*...
         gz-w2y^2*r12x-w2z^2*r12x)+cos(q3)*(-sin(q2)*(-cos(q1)*gx-sin(q1)*gy-w1y^2*r01x)+cos(q2)*gz+dw2z*...
         r12x+w2x*w2y*r12x)-dw3y*r23x+w3x*w3z*r23x-w4z^2*r34y-w4x^2*r34y)-w6x^2*r56z-w6y^2*r56z;


%************************************************************************************************************************
% Raggruppamento della variabili in uscita
%************************************************************************************************************************

w   = [w1x   w2x   w3x   w4x   w5x   w6x 
       w1y   w2y   w3y   w4y   w5y   w6y 
       w1z   w2z   w3z   w4z   w5z   w6z  ];

dw  = [dw1x  dw2x  dw3x  dw4x  dw5x  dw6x 
       dw1y  dw2y  dw3y  dw4y  dw5y  dw6y 
       dw1z  dw2z  dw3z  dw4z  dw5z  dw6z ];

ddp = [ddp1x ddp2x ddp3x ddp4x ddp5x ddp6x
       ddp1y ddp2y ddp3y ddp4y ddp5y ddp6y
       ddp1z ddp2z ddp3z ddp4z ddp5z ddp6z];
