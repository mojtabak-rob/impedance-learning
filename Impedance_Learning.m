% This code optimizes joint stiffness of the drum robot to perform double
% stroke drum roll.


clear
close all

%% initializing parameters

freq1=3;         %drum roll frequency
k1=3;            %joint stiffness
kk(1)=k1;

alpha=1.04;      %learning coefficient
beta=300;        %learning coefficient

desired_hit=freq1*4;             %the desired number of hits in one trial (2 sec)
desired_period=1/(freq1*2);      %the desired time interval of rebounding strokes

%% Learning iterations

for i=1:20
    sim('Drum_Robot_Double_Stroke')     %run the model
    
    %getting the results:
    
    hit=max(ans.hit);                   %number of hits
    T=[];                               %stroke times
    Y=ans.yout1;                        %stick position
    YD=ans.ydout1;                      %stick velocity
    
    %detecting stroke times:
    [aaa,bbb]=size(Y);
    for j=1:aaa-1
        if Y(j)<-0.068 && YD(j)*YD(j+1)<0
            T=[T j];
        end
    end
    T=T*2/aaa;
    
    
    TD=diff(T);                         %time intervals
    TDD=abs(diff(TD));                  %differences between successive intervals 
    err=mean(TDD);
    hitk(i)=hit;
    erk(i)=err;
    
    %selecting learning phase:
    if abs(hit-desired_hit)<1
        k1=k1*(beta^((desired_period-err)));    %updating stiffness
    else
        k1=k1*(alpha^(desired_hit-hit));        %updating stiffness
    end
    kk(i+1)=k1;
    
    if abs(kk(i)-kk(i+1))<0.003*abs(kk(i))
        break
    end
end

%% Plot results

figure
plot(kk)
figure
plot(hitk)
figure
plot(erk)