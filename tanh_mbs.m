function [mbsfn, mbsfn_sum] = tanh_mbs(x,c,s,N)

mbsfn = zeros(N,2); % 1: Large, 2: Small
mbsfn_sum=zeros(N,1);

mbsfn(:,1) = 0.5*(tanh(s*(x(:)-c))+1);
mbsfn(:,2) = 1- mbsfn(:,1);
for k=1:N, mbsfn_sum(k) = sum(mbsfn(k,:)); end
