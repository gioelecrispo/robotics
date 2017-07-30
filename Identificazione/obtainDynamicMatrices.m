function [B, Bddq, Cdq, FSta, FVist, g, Wnsym, pi_greco_stim_tot_NoAttr] = obtainDynamicMatrices(pi_greco_stim_tot)

syms q1 q2 q3 q4 q5 q6 
syms dq1 dq2 dq3 dq4 dq5 dq6
syms ddq1 ddq2 ddq3 ddq4 ddq5 ddq6
q = [q1 q2 q3 q4 q5 q6];
dq = [dq1 dq2 dq3 dq4 dq5 dq6];
ddq = [ddq1 ddq2 ddq3 ddq4 ddq5 ddq6];
Wnsym = [];

Wnsym = [Wnsym; phiDH(q,dq,ddq)];   

Wntmp = Wnsym(:, 1:40);  %No attrito
Wnsym = Wntmp;
clear Wntmp

dqNum = zeros(1,6);
ddqNum = zeros(1,6);
pi_greco_stim_tot_NoAttr = pi_greco_stim_tot(1:40);

%% Calcolo G
Gtmp = subs(Wnsym, [dq,ddq], [dqNum, ddqNum]);
g = Gtmp*pi_greco_stim_tot_NoAttr;

%% Calcolo F
FSta = pi_greco_stim_tot(41:2:51);
FVisc = pi_greco_stim_tot(42:2:52);

%% Calcolo Cdq
Ctmp = subs(Wnsym,[ddq],[ddqNum]);
Cdq = Ctmp*pi_greco_stim_tot_NoAttr - g;

%% Calcolo B*ddq
Bddq = Wnsym*pi_greco_stim_tot_NoAttr - g - C;
for i = 1:6
    for j = 1:6
        B(i,j) = diff(Bddq(i),ddq(j));
    end
end


