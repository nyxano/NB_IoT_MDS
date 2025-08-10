%sygnał NPBCH
ngen = NBIoTDownlinkWaveformGenerator;
ngen.Config.OperationMode = 'Inband-SamePCI';
ngen.Config.NCellID = 0;
ngen.Config.TotSubframes = 10;
[~, resourceGrid, ~] = ngen.generateWaveform();
% podramka 0, NPBCH, 1-14 symboli OFDM
re_NPBCH_grid = resourceGrid(:, 1:14);
maxMag = max(abs(re_NPBCH_grid(:)));
%sygnał interferujacy NPSS
ngen_interf = NBIoTDownlinkWaveformGenerator;
ngen_interf.Config.OperationMode = 'Inband-SamePCI';
ngen_interf.Config.NCellID = 1;
ngen_interf.Config.TotSubframes = 10;
[~, resourceGrid_interf, ~] = ngen_interf.generateWaveform();
% podramka 5 (indeks 6), czyli od 71 do 84 symbolu OFDM
npss_grid_interference = resourceGrid_interf(:,71:84);
%moc na gridzie
signal_power = mean(abs(re_NPBCH_grid(:)).^2);
interference_power = mean(abs(npss_grid_interference(:)).^2);
%wykresy
figure(1);
SIR_vector_dB = [20, 10, 0]; 

% wykres 1: oryginalny NPBCH
subplot(2,3,1);
imagesc(abs(re_NPBCH_grid));
caxis([0, maxMag]);
title('1. Oryginalna siatka NPBCH');
xlabel('Symbol OFDM');
ylabel('Podnośna');

%wykres 2: oryginalny NPSS
subplot(2,3,2);
imagesc(abs(npss_grid_interference));
caxis([0, maxMag]); 
title('2. Siatka zakłócająca NPSS');
xlabel('Symbol OFDM');
ylabel('Podnośna');
% pozostałe wykresy przy wplywie NPSS na NPBCH
for i = 1:length(SIR_vector_dB)
    current_SIR_dB = SIR_vector_dB(i);
    scaling_factor = sqrt(signal_power / (interference_power * 10^(current_SIR_dB/10)));
    interfered_grid = re_NPBCH_grid + npss_grid_interference * scaling_factor;
    subplot(2,3, i+3);
    imagesc(abs(interfered_grid));
    caxis([0, maxMag*1.5]);
    title(['NPBCH + NPSS, SIR = ' num2str(current_SIR_dB) ' dB']);
    xlabel('Symbol OFDM');
    ylabel('Podnośna');
end
sgtitle('Porównanie wpływu zakłócenia NPSS na sygnał NPBCH');
