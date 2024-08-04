%%
%load Data form user
clc
clear
close all
signalpath = uigetfile('*.txt','Choose Signal');
if signalpath==0
  return
end
OriginalSignal = importdata(signalpath);
timepath = uigetfile('*.txt','Choose Time of the Signal');
if timepath==0
  return
end
t=importdata(timepath);
Fm=str2double(cell2mat(inputdlg('Enter Frequency of input:','User input',[1 40])));;
Ts=length(t);
%%
%Get Frequency sampling from user
Fs = str2double(cell2mat(inputdlg('Enter Sampling Frequency:','User input',[1 40]))); %sampling freq
%%
%Sampling the signal
[sampled,sampledzeros,sampledtime]=Sampler(OriginalSignal,t,Fs);
%%
%Qunatization
level=str2double(cell2mat(inputdlg('Enter Number of Levels:','User input',[1 40])));
mp=str2double(cell2mat(inputdlg('Enter Peak Quantization Level:','User input',[1 40])));
mue=str2double(cell2mat(inputdlg('Enter μ Value:','User input',[1 40])));
[qunatized,levels]=quantizer(sampled,level,mp);
%%
%Encoding 
type=str2double(cell2mat(inputdlg(sprintf('Enter Type of Encoding:\n 1-UniPlar NRZ\n 2-Polar NRZ\n 3-Manchester'),'User input',[1 40])));
Encoded=Encode(levels,type);
%%
%Decoding
Decoded=Decode(Encoded,type,level,mp);
%%
%Recounstruction Filter
Recounstructed=RecounstructionFilter(Decoded,Ts,Fs,Fm);
%%
%plots 
close all
figure('Name','Pulse Code Modulation Simulator', 'NumberTitle', 'off');
set(gcf,'WindowState','Maximize');
Figure = uitabgroup('Parent',gcf);
%1-source input signal and the sampled signal
CreateNewTab = uitab(Figure,'Title', 'Original Signal');
axes('Parent',CreateNewTab);
stem(sampledtime,sampled)
hold on
plot(t,OriginalSignal)
title("Plot of Original Signal vs Sampled Signal"+"with Fs="+Fs)

%2-sampled signal and the quantized signal
CreateNewTab = uitab(Figure,'Title', 'Quantized Signal');
axes('Parent',CreateNewTab);
stem(sampledtime,sampled)
hold on
stairs(sampledtime,qunatized,'red')
title('sampled signal vs the quantized signal')

%3-output waveform from the encoder
CreateNewTab = uitab(Figure,'Title', 'Encoded Signal');
axes('Parent',CreateNewTab);
stairs(Encoded,'red')
title('Encoded signal')

%4-source input and destination output
CreateNewTab = uitab(Figure,'Title', 'Received Signal');
axes('Parent',CreateNewTab);
plot(t,OriginalSignal)
hold on
plot(t,Recounstructed)
title('source input signal vs the Received signal')

%5-frequency domain of input signal , sampled signal , destination signal
CreateNewTab = uitab(Figure,'Title', 'Frequency Domain Depresentation');
axes('Parent',CreateNewTab);
title('Frequency domain representation')
freq=-Ts/2:Ts/2-1/Ts;
subplot(3,1,1)
plot(freq,abs(fftshift((fft(OriginalSignal))))/Ts)
title('FFT input signal')
xlim([-100 100])
subplot(3,1,2)
plot(freq,abs(fftshift((fft(sampledzeros)))))
title('FFT sampled signal')
xlim([-100 100])
subplot(3,1,3)
plot(freq,abs(fftshift((fft(Recounstructed))))/Ts)
title('FFT received signal')
xlim([-100 100])