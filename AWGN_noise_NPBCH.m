% config NB_IoT
ngen = NBIoTDownlinkWaveformGenerator;
ngen.Config.OperationMode = 'Inband-SamePCI';
[waveform, resourceGrid, info] = ngen.generateWaveform();

% grid for subframe 0 (NPBCH)
re_NPBCH_grid = resourceGrid(:, :, 1);
maxMag = max(abs(re_NPBCH_grid(:))); 

% index NPBCH 
enb = ngen.Config;
[npbchInds, ~] = lteNPBCHIndices(enb); 
k = mod(npbchInds-1, 12) + 1; % subcarriers
l = floor((npbchInds-1)/12) + 1; % symbols

% 1. Oryginal figure
figure(1);
subplot(2,2,1);
imagesc(abs(re_NPBCH_grid(:, 1:14)));
caxis([0, maxMag]);
hold on;
title('Inband-SamePCI - NPBCH Oryginalny');
xlabel('Symbol OFDM'); ylabel('Podnośna');

% Include AWGN noise and their figure
SNR = [20, 10, 0]; % SNR types
for i = 1:length(SNR)
    noisyNPBCHGrid = awgn(re_NPBCH_grid(:, 1:14), SNR(i), 'measured');
    subplot(2,2,i+1);
    imagesc(abs(noisyNPBCHGrid));
    caxis([0, maxMag]);
    hold on;
    title(['Inband-SamePCI - NPBCH SNR = ' num2str(SNR(i)) ' dB']);
    xlabel('Symbol OFDM'); ylabel('Podnośna');
end