%%------------------Quantizing------------------%%

function [quantized_signal,quantizied_levels]=Quantizer(signal,num_levels,peak_level,mu)

if nargin==3
    mu=0;   
end

num_bits = ceil(log2(num_levels)); 
DeltaV = (2*peak_level)/num_levels;
rep_val = -peak_level + DeltaV/2:DeltaV:peak_level; %representation levels of each value
dec_lev = -peak_level:DeltaV:peak_level; %decleration value which we compare to get the rep value
quantized_signal = zeros(1,length(signal));
quantizied_levels =[];

% Apply the mu-law compression if 'mu' is not zero 
if(mu~=0)
signal = peak_level*log(1+mu*(abs(signal)/peak_level))/log(1+mu).*sign(signal);
end

% Quantize each sample in the input signal.
for i = 1:length(signal)

            for level = 1:length(dec_lev)
                if (signal(i) >= dec_lev(level) && signal(i)< dec_lev(level+1))
                    quantized_signal(i) = rep_val(level);
                    quantizied_levels(i,:)=de2bi(level-1,num_bits,'left-msb');
                    break

                elseif (signal(i) >= dec_lev(end))
                    quantized_signal(i) = rep_val(end);
                    quantizied_levels(i,:)=de2bi(length(rep_val)-1,num_bits,'left-msb');
                    break

                elseif (signal(i) <= dec_lev(1))
                    quantized_signal(i) = rep_val(1);
                    quantizied_levels(i,:)=de2bi(0,num_bits,'left-msb');
                    break

                end 
            end
end
end