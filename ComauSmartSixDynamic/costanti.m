% File costanti.m
%
% SIX - Gennaio 2005
%
% Carica alcune costanti usate per la dinamica:
% - kt_rms      : vettore 6x1 contenente le costanti di coppia motore (rms)
% - kt          : vettore 6x1 contenente le costanti di coppia motore (piccco)
% - knm2dac     : vettore 6x1 dell'inverso delle costanti di coppia
% - kr          : vettore 6x1 contenente i rapporti di trasmissione puri
% - krp5,krp6   : rapporti di trasmissione dei soli riduttori dell'asse 5 e dell'asse 6
% - k54,k64,k65 : coefficienti di influenza degli assi polso
% - Kr2         : matrice 6x6 dei rapporti di riduzione puri
% - K1          : matrice 6x6 di trasformazione di grandezze a valle dei riduttori in grandezze COMAU ai link
% - Kr          : matrice 6x6 dei rapporti di riduzione che considerano le influenze meccaniche
% - H           : matrice 6x6 di trasformazione delle ceonvenzioni COMAU in DH
% - K2          : matrice 6x6 di trasformazione di grandezze a valle dei riduttori in grandezze DH ai link
% -  i
% - r           : vettori tra l'origine della terna i-1 e origine della terna i espressi nella terna i [m]
% -  i-1,i
% - gx,gy,gz    : accelerazione di gravità (il segno è positivo dal basso verso l'alto)
% - soglia      : soglia per l'attrito statico


% ***********************************************************************************************************************
% Caricamento dei dati che definiscono le costanti del robot
% ***********************************************************************************************************************

SIX_INIT_XX001;


% ***********************************************************************************************************************
% Conversione delle correnti in coppie
% ***********************************************************************************************************************

% Costante di coppia del motore % [Kt di picco] = (Nm/Arms)/sqrt(2) 
  kt      = [data_motori(1).KTpicco
             data_motori(2).KTpicco
             data_motori(3).KTpicco
             data_motori(4).KTpicco
             data_motori(5).KTpicco
             data_motori(6).KTpicco];              
% Inverso della costante di coppia [A/Nm]
  knm2dac = [1/data_motori(1).KTpicco
             1/data_motori(2).KTpicco
             1/data_motori(3).KTpicco
             1/data_motori(4).KTpicco
             1/data_motori(5).KTpicco
             1/data_motori(6).KTpicco];              
  

% ***********************************************************************************************************************
% Conversione delle coppie e delle velocità in funzione degli organi di tramissione
% ***********************************************************************************************************************

% Rapporti di trasmissione (motore - giunto)
  kr = data_assi.kr;

% Matrice di trasformazione delle grandezze lato motore (suffisso mC) nelle grandezze a valle del riduttore ma a monte 
% delle influenze meccaniche, dette anche di attuazione (suffisso Ca)
  Kr2 = data_assi.Kr2;
  %
  %            T           .        -1   .
  % tau   = Kr2  * tau  ,  q   = Kr2   * q
  %    Ca             mC    Ca            mC
  %

% Matrice di trasformazione delle grandezze a valle del riduttore ma a monte delle influenze meccaniche nelle grandezze
% ai link in convenzione COMAU (suffisso C)
  K1 = data_assi.K1;
  %     
  %          -1          .      T   .
  % tau  = K1  * tau  ,  q  = K1  * q
  %    C            Ca    C          Ca
  %
  
% Matrice di trasformazione delle grandezze lato motore nelle grandezze ai link in convenzione COMAU
  Kr = data_assi.Kr;
  %     
  %          T           .      -1   .
  % tau  = Kr  * tau  ,  q  = Kr   * q
  %    C            mC    C           mC
  %
      
% Matrice di trasformazione delle grandezze ai link in convenzione COMAU in quelle ai link in convenzione DH (suffisso DH)
  H = data_assi.H;
  %     
  %          -T          .         .
  % tau   = H  * tau  ,  q   = H * q
  %    DH           C     DH        C
  %

% Matrice di trasformazione delle grandezze a valle del riduttore ma a monte delle influenze meccaniche nelle grandezze
% ai link in convenzione DH
  K2 = data_assi.K2;
  %     
  %           -1           .       T   .
  % tau   = K2   * tau  ,  q   = K2  * q
  %    DH             Ca    DH          Ca
  %

% Coefficienti di influenza degli assi polso
  k54 = data_assi.k54;
  k64 = data_assi.k64;
  k65 = data_assi.k65;


% ***********************************************************************************************************************
% Altro
% ***********************************************************************************************************************

%          i
% vettori r     tra l'origine della terna i-1 e origine della terna i espressi nella terna i [m]
%          i-1,i
  [a,d,alpha] = dh_table;

  % r01 = [a(1), -d(1), 0]';
    r01x =  a(1); 
    r01y = -d(1);

  % r12 = [a(2), 0, 0]';
    r12x =  a(2);

  % r23 = [a(3), 0, 0]';
    r23x =  a(3);

  % r34 = [0, d(4), 0]';
    r34y =  d(4);

  % r45 = [0, 0, 0]';

  % r56 = [0, 0, d(6)]';
    r56z =  d(6);

% accelerazione di gravità (il segno di g è positivo dal basso verso l'alto nel sistema inerziale)
  g_abs = MOD_ACC_DEC.TAB(39);
  % rotazione singola di un angolo g_gamma intorno all'asse x0
    g_gamma = MOD_ACC_DEC.TAB(82); % positivo in senso antiorario [rad]
    gx =                   0; % [m/sec^2]
    gy = -sin(g_gamma)*g_abs; % [m/sec^2]
    gz = -cos(g_gamma)*g_abs; % [m/sec^2]
  % rotazione singola di un angolo g_beta  intorno all'asse y0
    g_beta  = MOD_ACC_DEC.TAB(81); % positivo in senso antiorario [rad]
    if (g_gamma == 0)
      gx =   sin(g_beta)*g_abs; % [m/sec^2]
      gy =                   0; % [m/sec^2]
      gz =  -cos(g_beta)*g_abs; % [m/sec^2]
    else
      g_beta = 0;
    end % if (g_gamma == 0)
  % rotazione singola di un angolo g_alpha intorno all'asse z0
    g_alpha = 0; % positivo in senso antiorario [rad]
    if ((g_gamma == 0) & (g_beta == 0))
      gx =                   0; % [m/sec^2]
      gy =                   0; % [m/sec^2]
      gz =              -g_abs; % [m/sec^2]
    else
      g_alpha = 0;
    end % if ((g_gamma == 0) & (g_beta == 0))

% soglia per l'attrito statico
  soglia = DYN.VELSGL;

% gestione della molla
  if MOD_ACC_DEC.TAB(9 ) > 0
    molla_datinominali.ON   = 1                         ; % flag per indicare se la molla è presente (1) o meno (0)      {0,1} 
  else                                         
    molla_datinominali.ON   = 0                         ; % flag per indicare se la molla è presente (1) o meno (0)      {0,1} 
  end % if MOD_ACC_DEC.TAB(9 ) > 0
  molla_datinominali.nmolle = MOD_ACC_DEC.TAB(9 )       ; % numero delle molle                                           [--]  
  molla_datinominali.Fmont  = MOD_ACC_DEC.TAB(10)       ; % forza di precarico con molla montata e robot in calibrazione [N]   
  molla_datinominali.kmolla = MOD_ACC_DEC.TAB(11) * 1000; % costante elastica della molla (valore fornito dai meccanici) [N/m] 
  molla_datinominali.rr     = MOD_ACC_DEC.TAB(12) / 1000; % distanza tra il fulcro "fisso" della molla e il giunto 1     [m]   
  molla_datinominali.dd     = MOD_ACC_DEC.TAB(13) / 1000; % leva della molla                                             [m]   
