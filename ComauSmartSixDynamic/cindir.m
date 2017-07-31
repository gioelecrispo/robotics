function [out J] = cindir(qDHn)
%Calcola la cinematica diretta dello SmartSix
%Input:
%      qDH; variabili di giunti in convenzione DH e in rad
%Output:
%       x:     posizione x organo terminale
%       y:     posizione y organo terminale
%       z:     posizione z organo terminale
%       phi:   orientamento phi organo terminale
%       theta: orientamento theta organo terminale
%       psi:   orientamento psi organo terminale
if(size(qDHn, 1) ==1 || size(qDHn, 2) ==1)
    temp = qDHn; qDHn = []; qDHn(1,:) = temp;
    
end

[a, d, alpha] = dh_table;

for i=1:size(qDHn,1)
    qDH = qDHn(i, :);
ctheta = cos(qDH);
stheta = sin(qDH);
calpha = cos(alpha);
salpha = sin(alpha);

T = 1;
for j=1:length(qDH)
    T =T*[ctheta(j) -stheta(j)*calpha(j) stheta(j)*salpha(j) a(j)*ctheta(j);
          stheta(j)  ctheta(j)*calpha(j) -ctheta(j)*salpha(j) a(j)*stheta(j);
             0           salpha(j)             calpha(j)            d(j);
             0                0                  0                    1];
end

x = T(1, 4);
y = T(2, 4);
z = T(3, 4);
[phi, theta, psi] = R2ZYZ(T(1:3, 1:3));

out(i, :) = [x y z phi theta psi]';


for k=1:6
    if i>1
        if abs(out(i, k)-out(i-1, k))>0.5
            out(i,k) = out(i, k)+sign(out(i-1, k)-out(i, k))*round(abs(out(i, k)-out(i-1, k))/(pi))*(pi);
        end
    end
end

end   
