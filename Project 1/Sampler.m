%%------------------Sampling------------------%%

function [sampled_signal, sampled_signal_with_zeros, sampled_time] = Sampler(input_signal, input_time, sampling_frequency)
    
    Total_samples = length(input_time);
    Num_seconds = (input_time(end) - input_time(1));
    sampling_Size = ceil(length(input_signal) / ceil((sampling_frequency) * Num_seconds));
    buffer = zeros(1, length(input_signal));
    
    for i = 1:sampling_Size:length(input_signal)
        buffer(i) = input_signal(i);
    end
    
    valid_indexes = (buffer ~= 0);
    sampled_signal = buffer(valid_indexes);
    sampled_signal_with_zeros = buffer;
    sampled_time = input_time(valid_indexes);
end