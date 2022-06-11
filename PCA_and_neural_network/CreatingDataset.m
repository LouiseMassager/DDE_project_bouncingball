clear all;

% Mercury: 0.38 g.
% Venus: 0.9 g.
% Moon: 0.17 g.
% Mars: 0.38 g.
% Jupiter: 2.53 g.
% Saturn: 1.07 g.
% Uranus: 0.89 g.
% Neptune: 1.14 g.

n = 1000; %maximum number of bounces 
% ex = 6; %number of experiment 
H_limit = 0.001; %limit of minimum height
value = 5; %the number of hights and velocities

% v0 = 5*rand(1,value); %initial speed of the ball
v0 = randi([-10 10],1,value); %initial speed of the ball considering the negative value 
h0 = 50*rand(1,value); %initila hieght

g = [9.8100 3.7278 8.8290 1.6677 3.7278 24.8193 10.4967 8.7309 11.1834]; %Earth, Mercury, Venus, Moon, Mars, Jupiter, Saturn, Uranus, Neptune
e = [0.858 0.712 0.603 0.597 0.658 0.688]; %golf, tennis, billiard, wooden, steel, glass, plastic ball

h = [];
t = [];
tt = 0;
str2 = ["golf" "tennis" "billiard" "wooden" "steel" "glass"];

cnt = 1;
baseFileName = 'DATASET2.xlsx';

for ex=1:length (e) % different e 
    for e1=1:value %different h
        for e2=1:value %different v0
            for e3=1:length (g) %different g
               
                v1 = sqrt(2*g(e3)*h0(e1)+v0(e2)^2);
                t0 = (v1-v0(e2))/g(e3);

                for m = 1:n
                    h(m) = (((e(ex)^m)*v1)^2)/2/g(e3);%+0.01*rad() or round the number
                    h(m) = 0.1*rand(1)*h(m)+h(m);

                    t(m) = ((e(ex)^m)*v1)/g(e3);
                    t(m) = 0.1*rand(1)*t(m)+t(m);

                    tt = tt+t(m);
                        if h(m)<H_limit
                          break
                        end
                end

                cnt=cnt+1
              
               C=[round(h(1:4),3),m,round(tt+t0,3),str2(ex)];%fetures 

                tt = 0;
                str = num2str(cnt,'A%d');
                writematrix(C,baseFileName,'Sheet',1,'Range',str)

            end % end of different g
        end % end of different v0
    end % end of different h
end % end of different e
%
%
