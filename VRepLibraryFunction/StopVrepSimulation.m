%% STOP VREP SIMULATION
% Launch this fle to stop the communication with vrep
if (exist('vrep', 'var') && exist('client', 'var')) 
    if ~isempty(vrep) && ~ isempty(client)
        vrep.simxStopSimulation(client, vrep.simx_opmode_oneshot_wait);
        vrep.simxFinish(client);
        clear vrep;
        % Distruttore di vrep
        delete vrep;
        clear client;
        delete client;
    end
end;


