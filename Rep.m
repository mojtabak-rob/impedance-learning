clear
close all
freq1=3;
% for freq1=3:6
clear -freq1
k1=3;
kk(1)=k1;
alpha=1.04;
beta=300;
desired_hit=freq1*4;
desired_period=1/(freq1*2);
for i=1:20
    sim('Copy_of_alter_drum')
    hit=max(ans.hit);
    T=[];
    Y=ans.yout1;
    YD=ans.ydout1;
    [aaa,bbb]=size(Y);
    for j=1:aaa-1
        if Y(j)<-0.068 && YD(j)*YD(j+1)<0
            T=[T j];
        end
    end
    T=T*2/aaa;
    TD=diff(T);
    TDD=abs(diff(TD));
    err=mean(TDD);
%     err=max(ans.err);
    hitk(i)=hit;
    erk(i)=err;
    if abs(hit-desired_hit)<1
        k1=k1*(beta^((desired_period-err)));
    else
        k1=k1*(alpha^(desired_hit-hit));
    end
    kk(i+1)=k1;
    if abs(kk(i)-kk(i+1))<0.003*abs(kk(i))
        break
    end
end
figure
plot(kk)
figure
plot(hitk)
figure
plot(erk)
% end