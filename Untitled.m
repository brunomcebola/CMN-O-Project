hold all
x=0:0.01:2*pi;
b=zeros(5);
figure(1)
for a=1:5
   
   hold on;
   b(a) = plot(x,sin(a*x));
   legend(b(1:a));
   pause(1)
end