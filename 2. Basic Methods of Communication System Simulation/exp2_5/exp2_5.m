m = 200; bits = 2*m; 
sps = 10; 
iphase = 0; 
order = 5; 
bw = 0.2; 
data = zeros(1,bits); d = zeros(1,m); q = zeros(1,m);
dd = zeros(1,m); qq = zeros(1,m); theta = zeros(1,m);
thetaout = zeros(1,sps*m);
data = round(rand(1,bits));
dd = data(1:2:bits-1);
qq = data(2:2:bits);
theta(1) = iphase; 
thetaout(1:sps) = theta(1)*ones(1,sps);
for k=2:m
    if dd(k) == 1
       phi_k = (2*qq(k)-1)*pi/4;
    else
       phi_k = (2*qq(k)-1)*3*pi/4;
    end 
    theta(k) = phi_k + theta(k-1);
 for i=1:sps
     j = (k-1)*sps+i;
     thetaout(j) = theta(k);
 end
end
d = cos(thetaout);
q = sin(thetaout);
[b,a] = butter(order,bw);
df = filter(b,a,d);
qf = filter(b,a,q);
kk = 0; 

while kk == 0 
      k = menu('pi/4 DQPSK Plot Options',...
      'Unfiltered pi/4 DQPSK Signal Constellation',...
      'Unfiltered pi/4 DQPSK Eye Diagram',...
      'Filtered pi/4 DQPSK Signal Constellation',...
      'Filtered pi/4 DQPSK Eye Diagram',...
      'Unfiltered Direct and Quadrature Signals',...
      'Filtered Direct and Quadrature Signals',...
      'Exit Program');
 if k == 1
    sigcon(d,q) 
    pause
 elseif k ==2
    dqeye(d,q,4*sps) 
    pause
 elseif k == 3
    sigcon(df,qf) 
    pause
 elseif k == 4
    dqeye(df,qf,4*sps) 
    pause
 elseif k == 5
    numbsym = 10; 
    dt = d(1:numbsym*sps);
    qt = q(1:numbsym*sps); 
    dqplot(dt,qt) 
    pause
 elseif k == 6
    numbsym = 10; 
    dft=df(1:numbsym*sps); 
    qft=qf(1:numbsym*sps); 
    dqplot(dft,qft) 
    pause
 elseif k == 7
    kk = 1; 
 end
end