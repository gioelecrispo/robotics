## robotics
Repository including some robotics functions (Matlab), such as inverse kinematics, trapezoidal profile and so on. 

## ControlloIndipendenteAiGiunti
This is the folder containing the simulink scheme of the entire system (Control and Dynamic). There are also some files:
  - progettoMotori.m that includes the infomations of the motors;
  - calcolaBSegnato.m for the calculus of the average inertia;
  - caclolaDisturbo.m for the calculus of the disturb in the simulink scheme.
  
## Identificazione
This is the folder containing the function for the identification of the dynamic parameters:
  - geneticAlgorithm uses the optimizeFunction to generate some points of interest (the ones needed to do the identification);
  - optimizeFunction.m is the fitness function of the ga;
  - seqPointsSplines_grade5.m is the function that uses the 5th order spline to interpolate the points. Due to the fact that the trajectory could not respect the joint limits, other functions was developed to improve this situation. 
  - makeTrajectory uses seqPointsSplines_grade5.m to
  - addPointsToTrajectory.m adds some points in order to force the trajectory to pass for that point;
  - changePoints.m modifies the values of position, velocity or acceleration of the POI;
  - shakePoints.m is an algorithm that swap two or more points in order to optimize the trajectory, making it in compliance with the joint limits;
  - changeTime.m modify the temporal interval between two POI;
  - grafici.m is an utility function that draw the trajectory for one or more joints;
  - graficiInterval.m do the same of grafici.m but only in the temporal interval specified in input;
  - calcoloParametriDinamici.m calculates the dynamic parameters;
  - identificationTotal.m calculates the dynamic parameters considering the POI of the trajectory;
  - identificationTotal.m calculates the dynamic parameters considering the all points of the trajectory; 
  - obtainDynamicMatrices.m calculater the dynamic matrices (B, C, F and g) of the dynamic model of the robot.
