function [num,sum_num,mu] = fuzzyrule(a,b,c,d,e)

num = zeros(1,13);

num(1) = a(1) * b(1) * c(1) * d(2) * e(1) ;  % s,s,s,s,s   = Hard
num(2) = a(1) * b(1) * c(1) * d(2) * e(3) ;  % s,s,s,s,L   = Easy
num(3) = a(1) * b(1) * c(1) * d(2) * e(2) ;  % s,s,s,s,m   = Easy
num(4) = a(1) * b(1) * c(1) * d(1)                         ;  % s,s,s,L,N/A = Hard

num(5) = a(2) * b(2) * c(2) * d(2) * e(2) ;  % m,m,m,s,m   = Maintain
num(6) = a(2) * b(2) * c(2) * d(2) * e(3) ;  % m,m,m,s,m   = Easy
num(7) = a(2) * b(2) * c(2) * d(2) * e(1) ;  % m,m,m,s,m   = Hard
num(8) = a(2) * b(2) * c(2) * d(1)                         ;  % m,m,m,s,N/A = Hard

num(9)  = a(3) * b(3) * c(3) * d(2) * e(2) ;  % L,L,L,s,m   = Hard
num(10) = a(3) * b(3) * c(3) * d(2) * e(3) ;  % L,L,L,s,m   = Hard
num(11) = a(3) * b(3) * c(3) * d(2) * e(1) ;  % L,L,L,s,m   = Hard
num(12) = a(3) * b(3) * c(3) * d(1)                         ;  % L,L,L,s,N/A = Hard

num(13) = a(3) * b(3) * c(3)                                                 ;  % TL, TL, TL, N/A, N/A = Stop

sum_num=sum(num); 
mu = num/sum_num;