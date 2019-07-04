clear all; close all; clc;

%% Data load
dt=0.01; T=1;
t=0:dt:T; N=length(t);

global Point; 
Point = [65, 13, 95]; % 40~140, 5~30, 60~160

HR = linspace(40,140,N);
HR0 = linspace(60,120,4); % Low Mid Walking High
% Heart rate (beat per minute):
% Normally:  60 ~ 100 beat per minute
% Walking: 110 ~ 120
% Maximum: 200 - age

RR = linspace(5,30,N);
RR0 = linspace(10,25,4);  % Low Mid pre-high High
% Respiration rate (breaths per minute):
% 12 ~ 20 : Normal
% <12 : Low, > 25: High

BP = linspace(60,160,N);
BP0 = linspace(80,140,4);  % Low Mid pre-high High
% Blood Pressure (mm Hg):
% 90/60 ~ 120/80 : Normal
% > 120/80: Pre-high, > 140/100: High

%% Membership function ( NAME_mbsfn, [Low, medium, Pre-High, High] )
[HR_mbsfn, HR_sum, sHR] = Gauss_mbs(HR,HR0,N);
[RR_mbsfn, RR_sum, sRR] = Gauss_mbs(RR,RR0,N);
[BP_mbsfn, BP_sum, sBP] = Gauss_mbs(BP,BP0,N);

[Point_HR_mbsfn, Point_HR_sum, sHR] = Gauss_mbs(Point(:,1),HR0,length(Point(:,1)));
[Point_RR_mbsfn, Point_RR_sum, sRR] = Gauss_mbs(Point(:,2),RR0,length(Point(:,2)));
[Point_BP_mbsfn, Point_BP_sum, sBP] = Gauss_mbs(Point(:,3),BP0,length(Point(:,3)));


%% [Membership function] Figure
figure('color','w')
subplot(311);
for k=1:4, plot(HR,HR_mbsfn(:,k),'b','linewidth',2); hold on; end
for k=1:4, plot(Point(1),Point_HR_mbsfn(:,k),'ro','linewidth',2); hold on; end
title('Heart rate'); ylabel('\mu_1(x)'); xlabel('bpm (beat / min)')
subplot(312);
for k=1:4, plot(RR,RR_mbsfn(:,k),'b','linewidth',2); hold on; end
for k=1:4, plot(Point(2),Point_RR_mbsfn(:,k),'ro','linewidth',2); hold on; end
title('Respiration rate'); ylabel('\mu_2(x)'); xlabel('bpm (breaths / min)')
subplot(313);
for k=1:4, plot(BP,BP_mbsfn(:,k),'b','linewidth',2); hold on; end
for k=1:4, plot(Point(3),Point_BP_mbsfn(:,k),'ro','linewidth',2); hold on; end
title('Blood presure'); ylabel('\mu_3(x)'); xlabel('mm Hg')

%% Defuzzification
% mandani with Larsen product implication method as the inference operator
% Better computing performance than max & min
mu_mandani = zeros(length(Point(:,1)),4); num = zeros(length(Point(:,1)),4);
for k=1:4, num(k) = Point_HR_mbsfn(k) * Point_RR_mbsfn(k) * Point_BP_mbsfn(k); end
sum_num=sum(num);
for k=1:4, mu_mandani(k) = num(k)/sum_num; end

mu_mandani

Point_result=[Point_HR_mbsfn; Point_RR_mbsfn; Point_BP_mbsfn]
figure('color','w');
bar(mu_mandani,'b','barwidth',0.2);
set(gca,'Xticklabel',{'Easy','Maintain','Hard','Too Hard'});
ylabel('\mu_{decision}'); title(sprintf('P: %1.2f, %1.2f, %1.2f, %1.2f',mu_mandani(1),mu_mandani(2),mu_mandani(3),mu_mandani(4)))
