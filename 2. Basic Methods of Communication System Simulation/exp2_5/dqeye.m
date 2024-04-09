function [] = dqeye(xd,xq,m)
lx = length(xd); 
kcol = floor(lx/m); 
xda = [0,xd]; xqa = [0,xq]; 
for j = 1:kcol 
for i = 1:(m+1) 
    kk = (j-1)*m+i; 
    y1(i,j) = xda(kk);
    y2(i,j) = xqa(kk);
 end
end
subplot(211) 
plot(y1);
title('D/Q EYE DIAGRAM');
xlabel('Sample Index');
ylabel('Direct');
subplot(212) 
plot(y2);
xlabel('Sample Index');
ylabel('Quadratute');
subplot(111) 
% End of function file.