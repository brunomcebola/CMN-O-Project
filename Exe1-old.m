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
for valuesQr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    for valuesQr3 = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
        for valuesRr = [0.3, 0,5, 0.7, 0.8, 1]
            %EXE6
            % Furuta pendulum - State feedback test
            %______________________________________________________________________
            Qr = diag([valuesQr1,0,valuesQr3,0,0]); %Weight Matrix for x
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
            
            if score < minScore
               minScore = score;
               values = [valuesQr1, valuesQr3, valuesRr];
            end
            
            if erro_alpha < minAlpha
               minAlpha = erro_alpha;
               valuesAlpha = [valuesQr1, valuesQr3, valuesRr];
            end
            
            
            if erro_beta < minBeta
               minBeta = erro_beta;
               valuesBeta = [valuesQr1, valuesQr3, valuesRr];
            end
            
        end
    end
end


%{
figure();
gg=plot(y);
set(gg,'LineWidth',1.5)
gg=xlabel('Time (s)');
set(gg,'Fontsize',14);
gg=ylabel('\beta (rad)');
set(gg,'Fontsize',14);
legend('alpha','beta');
figure();
plot(u);
%----------------------------------------------------------------------
% End of file
%}
