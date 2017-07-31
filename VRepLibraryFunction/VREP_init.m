%% MAIN_InitScript
%%%%% SET PATH 
% restoredefaultpath
addpath('/usr/local/src/vrep/programming/remoteApiBindings/matlab/matlab');
addpath('/usr/local/src/vrep/programming/remoteApi');
addpath('/usr/local/src/vrep/programming/remoteApiBindings/lib/lib');
% OGNUNO DI VOI DOVRA' METTERE IL PATH ALLA CARTELLA PROGRAMMING NELLA
% DIRECTORY DI INSTALLAZIONE DI VREP
% addpath(genpath('C:\Program Files (x86)\V-REP3\V-REP_PRO_EDU\programming'));
addpath(genpath('/Applications/V-REP_PRO_EDU_V3_3_2_Mac/programming'));
addpath(genpath('./')); %aggiungo il path corrente al path di matlab in modo che le funzioni nelle sottodirectory possano viste dal Matlab
savepath;
%%%%% PULIZIA INIZIALIZZAZIONE
clc;
warning off;
StopVrepSimulation(); % pre precauzione
delete vrep
clear client


%%%%% INIZIALIZZAZIONE CONNESSIONE
InitConnectionWithSimulator(); % initialize the communication with the Simulator