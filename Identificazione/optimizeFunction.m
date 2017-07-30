function fun = optimizeFunction(x)


N = length(x)/18;
Wn = [];
for i = 1 : N
   Wn = [Wn; phiDH([x(i*18-17);x(i*18-16);x(i*18-15);x(i*18-14);x(i*18-13);x(i*18-12)], [x(i*18-11);x(i*18-10);x(i*18-9);x(i*18-8);x(i*18-7);x(i*18-6)], [x(i*18-5);x(i*18-4);x(i*18-3);x(i*18-2);x(i*18-1);x(i*18)])];
end
size(Wn);

singolarValues = svd(Wn);
sigmaMax = singolarValues(1);
sigmaMin = singolarValues(end);
condW = sigmaMax/sigmaMin;
lambda = [1; 1.0916e+03];


fun = lambda(1)*condW + lambda(2)*(1/sigmaMin);


end

