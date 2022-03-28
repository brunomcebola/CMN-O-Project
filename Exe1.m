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
%b = tf(a(1,:),a(2,:));
%bode(b);

%EXE5
Q=diag([10,0,1,0,0]);
R=1;
[K,S,CLP] = lqr(A,B,Q,R);
eigen_closed=eig(A-B*K);



minScore = 10^9;
minAlpha = minScore;
minBeta = minScore;

%Values
valuesQr1 = [1,3,5,7,9,10];
valuesQr3 = 1;
valuesRr = 1;
for i = 1:length(valuesQr1)
    %EXE6
    % Furuta pendulum - State feedback test
    %______________________________________________________________________
    Qr = diag([valuesQr1(i),0,valuesQr3,0,0]); %Weight Matrix for x
    Rr = valuesRr; %Weight for the input variable
    K = lqr(A, B, Qr, Rr); %Calculate feedback gain
    %----------------------------------------------------------------------


    %EXE7
    G = eye(size(A)); %Gain of the process noise
    Qe = eye(size(A))*10; %Variance of process errors
    Re = eye(2); %Variance of measurement errors
    L = lqe(A, G, C, Qe, Re); %Calculate estimator gains

    %EXE8
    A1=A-B*K-L*C;
    B1=L;
    C1=-K;

    % Simulate controller
    x0=[0.1 0 0 0 0]';
    %D=[[0];[0]];
    %C= eye(5);

    %C2 = eye(2, 5);
    D2 = [0 0];

    T=10; % Time duration of the simulation


    sim('statefdbk_2015',T);
    %Score
    erro_alpha = rms(y.Data(:,1));
    erro_beta = rms(y.Data(:,2));

    score = erro_alpha + 20*erro_beta;


    figure(1);
    hold on;
    p = plot(y);
    set(p,'LineWidth',1.5)
    p=xlabel('Time (s)');
    set(p,'Fontsize',14);
    p=ylabel('\beta (rad)');
    set(p,'Fontsize',14);
    legend(string(valuesQr1(i)));
    figure(2);
    hold on;
    plot(u);
    legend(string(valuesQr1(i)));
    pause(5)
end

%----------------------------------------------------------------------
% End of file
%}



















