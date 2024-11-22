function [f_d_SiSi,S_hat_d_SiSi] = SiSiFT(t_d,S_d)
% Single Sided spectrum computation for a 1D function
% provide time array t_d and signal array S_d as input

    % Sampling period
    T = t_d(2)-t_d(1);
    % Sampling frequency
    Fs = 1/T;
    % number of samples (signal length)
    L = length(S_d);
    % frequency array
    f_d = Fs/L*(-L/2:L/2-1);  
    
    % single sided spectrum
    f_d_SiSi = Fs/L*(0:(L/2));
    S_FFT_abs = abs(fft(S_d)/L);
    S_hat_d_SiSi = S_FFT_abs(1:L/2+1);
    S_hat_d_SiSi(2:end-1) = 2*S_hat_d_SiSi(2:end-1);
end