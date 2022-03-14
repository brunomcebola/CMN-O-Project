%EXE1
load fp_lin_matrices_fit3.mat;
eigen_v=eig(A);

%EXE2
CO = ctrb(A,B);
rank_CO=rank(CO);

%EXE3
%x1 e x3
OB = obsv(A,C);
rank_OB=rank(OB);
C3 = [0,0,0,0,0;0,0,1,0,0];
%Apenas x3
OB3 = obsv(A,C3);
rank_OB3=rank(OB3);

%EXE4
a = ss2tf(A,B,C,D); %duvida na funçao
b = tf(a(1,:),a(2,:));
bode(b);

%EXE5
Q=diag([10,0,1,0,0]);
R=1;
[K,S,CLP] = lqr(A,B,Q,R);
eigen_closed=eig(A-B*K);

%EXE6
% Furuta pendulum - State feedback test
%______________________________________________________________________
Qr = diag([10,0,1,0,0]); %Weight Matrix for x
Rr = 1; %Weight for the input variable
K = lqr(A, B, Qr, Rr); %Calculate feedback gain
%----------------------------------------------------------------------
% Simulate controller
x0=[0.1 0 0 0 0]';
%D=[0 0 0 0 0]';
T=2; % Time duration of the simulation
sim('statefdbk',T);
gg=plot(t,x);
set(gg,'LineWidth',1.5)
gg=xlabel('Time (s9');
set(gg,'Fontsize',14);
gg=ylabel('\beta (rad)');
set(gg,'Fontsize',14);
%----------------------------------------------------------------------
% End of file

%EXE7
G = eye(size(A)); %Gain of the process noise
Qe = eye(size(A))*10; %Variance of process errors
Re = eye(2); %Variance of measurement errors
L = lqe(A, G, C, Qe, Re); %Calculate estimator gains

%EXE8
A1=A-B*K-L*C;
B1=L;
C1=-K;










