function bi = calcolaBSegnato()

addpath(genpath('./'));
limiti_giunto_inf = [-2.9671   -1.4835   -2.9671   -3.6652   -2.2689  -47.1239];
limiti_giunto_sup = [ 2.9671    2.7053         0    3.6652    2.2689   47.1239];


%%%%% CALCOLO INERZIA MEDIA
% Pel calcolo dell'inerzia media ? necessario considerare gli elementi
% della diagonale della matrice B, cio? B(i,i), dopo un'operazione di media
% sui limiti di giunto.
% In particolare, non ? necessario considerare, al fine della valutazione
% dell'inerzia media del giunto i, il contributo dei giunti a monte e cio?
% dei giunti 1, 2, ..., i-1, ma solo quelli a valle, cio? i+1, i+2, ..., n
% e il contributo del giunto stesso. Il contributo del giunto i su s?
% stesso va considerato solo se ? un giunto prismatico. Dal momento che
% tutti i giunti del manipolatore Comau Smart Six sono rotoidaili, ?
% possibile escludere tale contributo.
% Per i giunti della base, quali il giunto 1, 2 e 3, i contributi forniti
% dai giunti di polso sono minimi od inesistenti.

%%% INIZIALIZZAZIONE
dim = 6;                  % dimensioni matrice di inerzia
passo1 = 0.01;            % passo con cui campionare il range dei limiti di giunto
passo2 = 0.02;            % passo con cui campionare il range dei limiti di giunto (pi? velocemente)
passo5 = 0.05;            % passo con cui campionare il range dei limiti di giunto (molto pi? velocemente)
passo10 = 0.1;            % passo con cui campionare il range dei limiti di giunto (estremamente pi? velocemente)
passo20 = 0.2;            % passo con cui campionare il range dei limiti di giunto (estremamente pi? velocemente)
% giuntiIndiff: quando il contributo di un giunto ? indifferente uso un
% valore casuale della sua escursione, per non toccare casi limite
for i = 1 : dim
    giuntiIndiff(i) = limiti_giunto_inf(i) + (limiti_giunto_sup(i)-limiti_giunto_inf(i))*rand(1,1);
end


% giuntiIndiff = (limiti_giunto_inf + limiti_giunto_sup)/2; 

%%% GIUNTO 1:
% Per le considerazioni fatte precedentemente ? necessario considerare
% unicamente i contributi dei giunti 2 e 3, dal momento che i giunti 4 e 5
% incidono minimamente e il giunto 6 non ha alcuna influenza sull'inerzia
% media.
% IMPIEGA CIRCA 5 MINUTI (120000 ITERAZIONI)
Btot = zeros(dim);         % Azzero la matrice che dovr? mediare
cnt = 1;                    % Azzero il counter
for i = limiti_giunto_inf(2) : passo1 : limiti_giunto_sup(2) 
    for j = limiti_giunto_inf(3) : passo1 : limiti_giunto_sup(3) 
        Btot = Btot + MatriceInerzia([giuntiIndiff(1), i, j, giuntiIndiff(4), giuntiIndiff(5), giuntiIndiff(6)]);
        cnt = cnt + 1;
    end
end
Bmed = Btot/cnt; 
bi(1) = Bmed(1,1);
% bi(1) = 28.2971;


%%% GIUNTO 2:
% Per le considerazioni fatte precedentemente ? necessario considerare
% unicamente i contributi del giunto 3, dal momento che i giunti 4 e 5
% incidono minimamente e il giunto 6 non ha alcuna influenza sull'inerzia
% media.
% ISTANTANEO (297 ITERAZIONI)
Btot = zeros(dim);          % Azzero la matrice che dovr? mediare
cnt = 1;                    % Azzero il counter
for i = limiti_giunto_inf(3) : passo1 : limiti_giunto_sup(3) 
    Btot = Btot + MatriceInerzia([giuntiIndiff(1), giuntiIndiff(2), i, giuntiIndiff(4), giuntiIndiff(5), giuntiIndiff(6)]);
    cnt = cnt + 1;
end
Bmed = Btot/cnt; 
bi(2) = Bmed(2,2);
% bi(2) = 35.9938;


%%% GIUNTO 3:
% Per le considerazioni fatte precedentemente ? necessario considerare
% unicamente i contributi dei giunti 4 e 5, anche se incidono minimamente,
% mentre il giunto 6 non ha alcuna influenza sull'inerzia media.
% IMPIEGA CIRCA 8 MINUTI (166618 ITERAZIONI)
Btot = zeros(dim);          % Azzero la matrice che dovr? mediare
cnt = 1;                    % Azzero il counter
for i = limiti_giunto_inf(4) : passo2 : limiti_giunto_sup(4) 
    for j = limiti_giunto_inf(5) : passo2 : limiti_giunto_sup(5) 
        Btot = Btot + MatriceInerzia([giuntiIndiff(1), giuntiIndiff(2), giuntiIndiff(3), i, j, giuntiIndiff(6)]);
        cnt = cnt + 1;
    end
end
Bmed = Btot/cnt; 
bi(3) = Bmed(3,3);
% bi(3) = 12.4568;



%%% GIUNTO 4:
% Per le considerazioni fatte precedentemente ? necessario considerare
% unicamente i contributi dei giunti 5 e 6, anche se incidono minimamente.
% IMPIEGA CIRCA 15 MINUTI (214288 ITERAZIONI)
Btot = zeros(dim);          % Azzero la matrice che dovr? mediare
cnt = 1;                    % Azzero il counter
for i = limiti_giunto_inf(5) : passo1 : limiti_giunto_sup(5) 
    for j = limiti_giunto_inf(6) : passo20 : limiti_giunto_sup(6) 
        Btot = Btot + MatriceInerzia([giuntiIndiff(1), giuntiIndiff(2), giuntiIndiff(3), giuntiIndiff(4), i, j]);
        cnt = cnt + 1;
    end
end
Bmed = Btot/cnt; 
bi(4) = Bmed(4,4);
% bi(4) = 0.2032;



%%% GIUNTO 5:
% Per le considerazioni fatte precedentemente ? necessario considerare
% unicamente i contributi dal giunto 6, anche se incide minimamente.
% ISTANTANEO (1885 ITERAZIONI)
Btot = zeros(dim);          % Azzero la matrice che dovro' mediare
cnt = 1;                    % Azzero il counter
for i = limiti_giunto_inf(6) : passo5 : limiti_giunto_sup(6) 
    Btot = Btot + MatriceInerzia([giuntiIndiff(1), giuntiIndiff(2), giuntiIndiff(3), giuntiIndiff(4), giuntiIndiff(5), i]);
    cnt = cnt + 1;
end
Bmed = Btot/cnt; 
bi(5) = Bmed(5,5);
% bi(5) = 0.2742;



%%% GIUNTO 6:
% Per le considerazioni fatte precedentemente nessun giunto incide sul 
% giunto 6.
% ISTANTANEO (1 ITERAZIONE)
Bmed = MatriceInerzia(giuntiIndiff, carico);
bi(6) = Bmed(6,6);
% bi(6) = 0.1051;
