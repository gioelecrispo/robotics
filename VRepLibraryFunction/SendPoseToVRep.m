function [err] = SendPoseToVRep(robot, qDH)
% Invia a vrep la posizione ai giunti del manipolatore.
% Da usare in simulink. Il vettore "in" e' costituito da [time JointDH] (dimensione [7,1])
% Il primo valore si riferisce alla slitta, gli altri ai giunti rotoidali 
% in ordine [1 2 3 4 5 6].

global vrep client  Mode

err(1:7) = 0;
for i = 1:7
    err(i) = vrep.simxSetJointPosition(client, robot.JointHandle(i), qDH(i), Mode);
end
