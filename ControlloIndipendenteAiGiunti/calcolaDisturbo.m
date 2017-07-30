function disturbo = calcolaDisturbo(u) 
% Calcola il disturbo.
% La formula e':
%     d = Kr^(-1)*deltaB*Kr^(-1)*ddqm + Kr^(-1)*C*Kr^(-1)*dqm + Kr^(-1)*g
% dove: dmq e ddqm sono le velocita' e accelerazioni lato motore.
% Dal momento che gli ingressi di tale funzione sono lato giunti,
% ricordando le relazioni q = Kr^(-1)*qm, dq = Kr^(-1)*dqm, ddq = Kr^(-1)*ddqm, 
% la formula diventa:
%     d = Kr^(-1)*deltaB*ddq + Kr^(-1)*C*dq + Kr^(-1)*g
%
% E' inoltre importante ricordare che la funzione CCentrifugoCoriolis
% restituisce gia' il prodotto C*dq. 
%
% PARAMETRI
% In ingresso:
      % u, che contiene:
      %    - q: vettore delle posizioni lato giunti 
      %    - dq: vettore delle velocita' lato giunti 
      %    - ddq: vettore delle accelerazioni lato giunti 
% In uscita:
      % distubo : vettore 6x1 
     
      
% Scompatto il vettore di ingresso.
q   = u(1:6);
dq  = u(7:12);
ddq = u(13:18);

% Ottengo le matrici Kr e Bsegn
kr = [-147.8019; 153.0000; 141.0000; -51.4170; 81.0000; 50.0000];
Kr = diag(kr); 
Kr(6,5) = -1;

bi = [28.2971; 35.9938; 12.4568; 0.2032; 0.2742; 0.1051];
Bsegn = diag(bi);
deltaB = MatriceInerzia(q) - Bsegn;

% Calcolo il disturbo
disturbo = Kr^(-1)*deltaB*ddq + Kr^(-1)*CCentrifugoCoriolis(q,dq) + Kr^(-1)*CGravita(q);
       
