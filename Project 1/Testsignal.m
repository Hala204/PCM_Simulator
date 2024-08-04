seconds = 1; % 1 sec
Fm = 10; %message freq
Ts = 10000; %time instants for this duration 
t = 0:seconds/Ts:seconds - seconds/Ts;
OriginalSignal = 5*cos(2*pi*Fm*t); 
writematrix(OriginalSignal,'Signal Data')
writematrix(t,'Time Data')