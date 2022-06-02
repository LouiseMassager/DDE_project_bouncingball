%{
Code to extract the initial ball height and the coefficient of restitution
from the experimental data collected through computer vision.

(!) This code use the optimisation toolbox: MPT (!)
%}
%% functions
y_th=@(v0,g,t) v0.*t -0.5.*g*t.^2;
rho=@(n,h0,v0,g) (v0/sqrt(2*h0*g))^(1/n);
h0_real=@(h0,g) (9.81/g)*h0;

%% inputs
%bond 1 => 25:48
%bond 2 => 50:64
is=50;
ie=64;
n=2;

%% data treatment
maxy= max(y);
H_exp= maxy- y(is:ie) ;
T_exp= t(is:ie)-t(is);
h0=maxy-y(2)

Hs=maxy-y(is);He=maxy-y(ie);Ts=0;Te=t(ie)-t(is); %to remove offset when ball approach/go further away from the camera
ligne=((T_exp-Ts).*((He-Hs)/(Te-Ts)))+Hs;
H_exp= H_exp-ligne;

%% optimisation

x= sdpvar(2,1, 'full'); %define x=[v0;g]

F= [x(1)>=0 x(2)>=0]

H_th=y_th(x(1),x(2),T_exp)
E=H_exp-H_th

c=E'*E %define cost
optimize(F,c) %launch optimization
optimalValue=double(x) %retrieve optimal value

%% outputs
v0=optimalValue(1)  
g=optimalValue(2)   

rho=rho(n,h0,v0,g)      
%n=1 => 0.7733           (if no offset : 0.7818)
%n=2 => 0.7215          (if no offset: 0.7691)

h0_real=h0_real(h0,g)   
%n=1 =>  1.8456         (if no offset: 1.8392)
%n=2 =>  1.5598         (if no offset: 1.1816)

%% display

plot(T_exp+t(is),maxy- y(is:ie) ,'-ob')     %original experience
hold on

plot(T_exp+t(is),H_exp ,'-og')              %experience with offset
hold on

plot(T_exp+t(is), y_th(v0,g,T_exp),'r')   %theorical
xlabel 'Time [s]';
title("Theorical and experimental graphs of the ball's trajectory at its second rebound") 
ylabel 'Height [pixels]'
legend('original experimental data','experimental data with ground offset','theorical formulation')
grid on
