function encodedSignal = Encoder(levels, encodingType)
    % Convert levels to binary code stream
    binaryStream = reshape(levels', 1, []);

    switch encodingType
        case 1
            % Unipolar NRZ signaling
            encodedSignal = binaryStream;

        case 2
            % Polar NRZ signaling
            encodedSignal = binaryStream;
            encodedSignal(encodedSignal == 0) = -1;

        case 3
            % Manchester signaling
            encodedSignal = zeros(1, 2 * length(binaryStream)); % Preallocate
            for i = 1:length(binaryStream)
                if binaryStream(i) == 0
                    encodedSignal(2*i-1:2*i) = [0 1];
                else
                    encodedSignal(2*i-1:2*i) = [1 0];
                end
            end

        otherwise
            error('Invalid encoding type specified');
    end
end
