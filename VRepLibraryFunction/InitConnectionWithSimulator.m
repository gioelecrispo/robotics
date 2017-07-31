%% InitConnectionWithSimulator
% Launch this file to start the communication with v-rep

global vrep client robot Mode
IP = '127.0.0.1';           % IP of the machine on which vrep runs
Port = 19998;               % Port on which V-REP runs
Timeout = 5000;             % timeout for response (ms)
SampleTimeComm = 10;        % ms sample time for communication with vrep 



vrep = remApi('remoteApi');
client = vrep.simxStart(IP, Port, true, true, Timeout, SampleTimeComm);
Mode = vrep.simx_opmode_oneshot; %communication mode (see manual remote API)



%%%%% HANDLING ROBOTS 
% Read from simulator the pointers to joints
pause(0.2);

[err, robot(1).JointHandle(1)] = vrep.simxGetObjectHandle(client, ['JointTrackSx'],  vrep.simx_opmode_oneshot_wait);
if(err)
   error(['Err reading pointer to prismatic joint ']);
end


for i=1:6
    [err, robot(1).JointHandle(i+1)] = vrep.simxGetObjectHandle(client, ['Joint', num2str(i), 'Sx'],  vrep.simx_opmode_oneshot_wait);
   if(err)
       error(['Err reading pointer to revolute joint ', num2str(2)]);
   end
end



[err, robot(2).JointHandle(1)] = vrep.simxGetObjectHandle(client, ['JointTrackDx'],  vrep.simx_opmode_oneshot_wait);
if(err)
   error(['Err reading pointer to prismatic joint ']);
end


for i=1:6
    [err, robot(2).JointHandle(i+1)] = vrep.simxGetObjectHandle(client, ['Joint', num2str(i), 'Dx'],  vrep.simx_opmode_oneshot_wait);
   if(err)
       error(['Err reading pointer to revolute joint ', num2str(2)]);
   end
end

%[temp, ForceSensorId] = vrep.simxGetObjectHandle(['ForceSensor'],  vrep.simx_opmode_oneshot_wait);
%[temp, EndEffectorId] = vrep.simxGetObjectHandle(client, ['EESx'],  vrep.simx_opmode_oneshot_wait);


err=vrep.simxStartSimulation(client, vrep.simx_opmode_oneshot_wait);
if(err>1)
    error(['Err starting simulation']);
end

 
