function reconstructed = RecounstructionFilter(decoded, Ts, Fs, Fm)
    % Initialize the signal with zeros
    signal = zeros(1, Ts);

    % Determine the sampling size
    SamplingInterval = ceil(Ts / ceil((Fs)));
    idx = 1;

    % Assign decoded values to the signal at intervals
    for pos = 1:SamplingInterval:Ts
        signal(pos) = decoded(idx);
        idx = idx + 1;
    end

    % Create the frequency filter
    filterLength = 2 * Fm + 1;
    halfPad = round(0.5 * (Ts - filterLength));
    freqFilter = [zeros(1, halfPad), ones(1, filterLength), zeros(1, floor(0.5 * (Ts - filterLength)))];

    % Apply the filter in the frequency domain
    spectrum = fft(signal) * Ts / Fs;
    filteredSpectrum = fftshift(freqFilter) .* fftshift(spectrum);

    % Perform the inverse FFT to get the reconstructed signal
    reconstructed = ifft(filteredSpectrum);
end