function decodedSignal = Decode(encodedSignal, encodingType, numLevels, maxLevel, mu)
    if nargin == 4
        mu = 0;
    end
    
    bitsPerSymbol = ceil(log2(numLevels));
    numBits = length(encodedSignal);
    
    switch encodingType
        case 1
            % Decode for Unipolar NRZ
            bufferDecoded = reshape(encodedSignal, bitsPerSymbol, []).';
            
        case 2
            % Decode for Polar NRZ
            encodedSignal(encodedSignal == -1) = 0;
            bufferDecoded = reshape(encodedSignal, bitsPerSymbol, []).';
            
        case 3
            % Decode for Manchester
            reshaped = reshape(encodedSignal, 2, []).';
            buffer = reshaped(:, 2) == 0; % 0 -> 1, 1 -> 0
            bufferDecoded = reshape(buffer, bitsPerSymbol, []).';
            
        otherwise
            error('Invalid encoding type specified');
    end

    % Dequantize the values
    deltaV = (2 * maxLevel) / numLevels;
    representationValues = linspace(-maxLevel + deltaV / 2, maxLevel - deltaV / 2, numLevels);
    
    decodedSignal = zeros(1, size(bufferDecoded, 1));
    for i = 1:size(bufferDecoded, 1)
        repLevel = bi2de(bufferDecoded(i,:), 'left-msb') + 1;
        decodedSignal(i) = representationValues(repLevel);
    end

    % Expanding the signal if mu is provided
    if mu ~= 0
        decodedSignal = maxLevel / mu * (exp(abs(decodedSignal) * log(1 + mu) / maxLevel) - 1) .* sign(decodedSignal);
    end
end