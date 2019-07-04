clear all; close all; clc;

%% Data load
dt=0.01; T=1;
t=0:dt:T; N=length(t);
open('Membership_fn.fig')
global Point;
global while_end;
while_end = 10;
%% Fuzzifier
% Heart rate (beat per minute):
% Normally:  60 ~ 100 beat per minute
% Walking: 110 ~ 120
% Maximum: 200 - age
HR = linspace(40,140,N);
HR0 = linspace(60,120,4); % Low Mid Walking High

% Respiration rate (breaths per minute):
% 12 ~ 20 : Normal
% <12 : Low, > 25: High
RR = linspace(5,30,N);
RR0 = linspace(10,25,4);  % Low Mid pre-high High

% Blood Pressure (mm Hg):
% 90/60 ~ 120/80 : Normal
% > 120/80: Pre-high, > 140/100: High
BP = linspace(60,160,N);
BP0 = linspace(80,140,4);  % Low Mid pre-high High

% Knee Torque in stance
STtoq = linspace(-20,20,N);
STtoq0 = 0;  % Mid

% Knee Torque in swing
SWtoq = linspace(-20,20,N);
SWtoq0 = linspace(-10,10,3);  % Low Mid pre-high High


%% Membership function ( NAME_mbsfn, [Low, medium, Pre-High, High] )
[HR_mbsfn, HR_sum, sHR] = Gauss_mbs(HR,HR0,N);
[RR_mbsfn, RR_sum, sRR] = Gauss_mbs(RR,RR0,N);
[BP_mbsfn, BP_sum, sBP] = Gauss_mbs(BP,BP0,N);
[STtoq_mbsfn, STtoq_sum] = tanh_mbs(STtoq,STtoq0,2,N);
[SWtoq_mbsfn, SWtoq_sum, sSWtoq] = Gauss_mbs(SWtoq,SWtoq0,N);


while_k=1;
fileID = fopen('Datasave.txt','w');    
fprintf(fileID,'\nIteration\tStatus\tmu_mandani\tInput');    
Point=zeros(1,5);
while(while_k<=while_end)
    clear Point_HR_mbsfn Point_RR_mbsfn Point_BP_mbsfn Point_STtoq_mbsfn Point_SW_mbsfn mu_mandani num mu num_sum;
    Point(1)=randi([60 120]);
    Point(2)=randi([10 25]);
    Point(3)=randi([80 140]);
    Point(4)=randi([-10 10]);
    Point(5)=randi([-10 10]);
    
    [Point_HR_mbsfn, Point_HR_sum, sHR] = Gauss_mbs(Point(:,1),HR0,length(Point(:,1)));
    [Point_RR_mbsfn, Point_RR_sum, sRR] = Gauss_mbs(Point(:,2),RR0,length(Point(:,2)));
    [Point_BP_mbsfn, Point_BP_sum, sBP] = Gauss_mbs(Point(:,3),BP0,length(Point(:,3)));
    [Point_STtoq_mbsfn, Point_STtoq_sum] = tanh_mbs(Point(:,4),STtoq0,2,length(Point(:,4)));
    [Point_SWtoq_mbsfn, Point_SWtoq_sum, sSWtoq] = Gauss_mbs(Point(:,5),SWtoq0,length(Point(:,5)));
    
    %% [Membership function] Figure
    figure('color','w')
    
    subplot(511);
    for k=1:length(HR0), plot(HR,HR_mbsfn(:,k),'b','linewidth',2); hold on; end
    for k=1:length(HR0), plot(Point(1),Point_HR_mbsfn(:,k),'ro','linewidth',2); hold on; end
    title('Heart rate'); ylabel('\mu_1(x)'); xlabel('bpm (beat / min)')
    subplot(512);
    for k=1:length(RR0), plot(RR,RR_mbsfn(:,k),'b','linewidth',2); hold on; end
    for k=1:length(RR0), plot(Point(2),Point_RR_mbsfn(:,k),'ro','linewidth',2); hold on; end
    title('Respiration rate'); ylabel('\mu_2(x)'); xlabel('bpm (breaths / min)')
    subplot(513);
    for k=1:length(BP0), plot(BP,BP_mbsfn(:,k),'b','linewidth',2); hold on; end
    for k=1:length(BP0), plot(Point(3),Point_BP_mbsfn(:,k),'ro','linewidth',2); hold on; end
    title('Blood presure'); ylabel('\mu_3(x)'); xlabel('mm Hg')
    subplot(514);
    for k=1:length(STtoq0)+1, plot(STtoq,STtoq_mbsfn(:,k),'b','linewidth',2); hold on; end
    for k=1:length(STtoq0)+1, plot(Point(4),Point_STtoq_mbsfn(:,k),'ro','linewidth',2); hold on; end
    title('Knee torque in stance'); ylabel('\mu_4(x)'); xlabel('Nm')
    subplot(515);
    for k=1:length(SWtoq0), plot(SWtoq,SWtoq_mbsfn(:,k),'b','linewidth',2); hold on; end
    for k=1:length(SWtoq0), plot(Point(5),Point_SWtoq_mbsfn(:,k),'ro','linewidth',2); hold on; end
    title('Knee torque in swing'); ylabel('\mu_5(x)'); xlabel('Nm')
    
    hFig = figure(2*(while_k+1));
%     hFig = figure((while_k+1));
    set(hFig, 'Position', [500 100 500 800])
    set(gcf, 'renderer', 'painters');
    
    %% Fuzzy Rule
    % mandani with Larsen product implication method as the inference operator
    % Better computing performance than max & min
    [num,sum_num,mu] = fuzzyrule(Point_HR_mbsfn,Point_RR_mbsfn,Point_BP_mbsfn,Point_STtoq_mbsfn,Point_SWtoq_mbsfn);
    
    % Fuzzy Output and decision
    mu_mandani = zeros(length(Point(:,1)),4);
    mu_mandani(1) = max([mu(2) mu(3) mu(6)]);
    mu_mandani(2) = mu(5);
    mu_mandani(3) = max([mu(1) mu(4) mu(7) mu(8:12)]);
    if mu(13) > 0.9, mu_mandani(4) = mu(13); else, mu_mandani(4) = mu(13)*0.5; end
    
    %% File open and close
    fprintf(fileID,'\n%d\t',while_k);
    if max(mu_mandani) < 0.4 
        mu_mandani=zeros(1,4); mu_mandani(2)=1; 
        fprintf(fileID,'Stop\t[%1.2f %1.2f %1.2f %1.2f]\t[%d %d %d %d %d]',mu_mandani,Point);
    elseif sum_num == 0 
        mu_mandani=zeros(1,4); mu_mandani(2)=1; 
        fprintf(fileID,'NAN\t[%1.2f %1.2f %1.2f %1.2f]\t[%d %d %d %d %d]',mu_mandani,Point);
    else
        fprintf(fileID,'Cool\t[%1.2f %1.2f %1.2f %1.2f]\t[%d %d %d %d %d]',mu_mandani,Point); 
    end
    disp(while_k)
    
    %% [Fuzzy Output] Figure
    figure('color','w');
    bar(mu_mandani,'b','barwidth',0.2); hold on;
    set(gca,'Xticklabel',{'Easy','Maintain','Hard','Too Hard'});
    ylabel('\mu_{decision}'); title(sprintf('Input = [%d, %d, %d, %d, %d]\nOutput = [%1.3f, %1.3f, %1.3f, %1.3f]',Point,mu_mandani(1),mu_mandani(2),mu_mandani(3),mu_mandani(4)))
    axis([0 5 0 1])
    
    for k=1:4,
        if mu_mandani(k) == max(mu_mandani)
            if k==1,     bar(k,mu_mandani(k),'r','barwidth',0.2); legend('Reject','Decision : Easy'); fprintf(fileID,'\tEasy');
            elseif k==2, bar(k,mu_mandani(k),'r','barwidth',0.2); legend('Reject','Decision : Maintain'); fprintf(fileID,'\tMaintain');
            elseif k==3, bar(k,mu_mandani(k),'r','barwidth',0.2); legend('Reject','Decision : Hard'); fprintf(fileID,'\tHard');
            elseif k==4, bar(k,mu_mandani(k),'r','barwidth',0.2); legend('Reject','Decision : Too Hard'); fprintf(fileID,'\tToo Hard');
            end
        end
    end
%% Iteration
    while_k = while_k + 1;
end
fclose(fileID);
type('Datasave.txt')