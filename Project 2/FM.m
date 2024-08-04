%% Clear Workspace
clear;
clc;
close all;

%% Parameters
samplingFrequency = 2000;        % Sampling frequency in Hz
timeStep = 1 / samplingFrequency; % Time step
timeVector = 0:timeStep:1-timeStep; % Time vector
carrierAmplitude = 1.5;          % Amplitude of carrier
messageFrequency = 20;           % Frequency of message signal in Hz
carrierFrequency = 200;          % Frequency of carrier signal in Hz
frequencyDeviation = 50;         % Frequency deviation
modulationIndex = frequencyDeviation / messageFrequency; % Modulation index

%% Generate Message Signal
messageSignal = cos(2*pi*messageFrequency*timeVector);

%% Frequency Modulation
integralMessageSignal = cumsum(messageSignal) * timeStep; % Integral of the message signal
modulatedSignal = carrierAmplitude * cos(2*pi*carrierFrequency*timeVector + modulationIndex * 2*pi * integralMessageSignal); % Modulated signal

%% Plot Message and Modulated Signals
figure;
plot(timeVector, modulatedSignal, 'r');
hold on;
plot(timeVector, messageSignal, 'b');
ylim([-2 2]);
xlabel('Time (s)');
ylabel('Amplitude');
title('Message and Modulated Signal');
legend('Modulated Signal', 'Message Signal');
grid on;

%% Frequency Domain Representation
frequencyVector = -samplingFrequency/2:samplingFrequency/2-1;
fftMessageSignal = fftshift(fft(messageSignal));
fftModulatedSignal = fftshift(fft(modulatedSignal));

figure;
plot(frequencyVector, abs(fftMessageSignal)/samplingFrequency, 'b');
hold on;
plot(frequencyVector, abs(fftModulatedSignal)/samplingFrequency, 'r');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Domain Representation of the Signals');
legend('FFT of Message Signal', 'FFT of Modulated Signal');
grid on;

%% Add Noise to the Signal
noisySignal = awgn(modulatedSignal, 30);

%% Frequency Demodulation
differentiatedSignal = diff([0 noisySignal]); % Derivative of the noisy signal
mixedSignal = differentiatedSignal .* cos(2*pi*carrierFrequency*timeVector); % Mixing with the local oscillator
[filterB, filterA] = butter(10, 2*carrierFrequency/samplingFrequency); % Low-pass filter design
filteredSignal = filter(filterB, filterA, mixedSignal); % Filtering

%% Frequency Domain Representation of the Demodulated Signal
fftFilteredSignal = fftshift(fft(filteredSignal));

figure;
plot(frequencyVector, abs(fftFilteredSignal)/samplingFrequency, 'g');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Domain Representation of the Demodulated Signal');
grid on;

%% Plot Demodulated Signal
figure;
plot(timeVector, filteredSignal, 'g');
xlabel('Time (s)');
ylabel('Amplitude');
title('Demodulated Signal');
grid on;
