close all;
clear all;
clc;

%% load data - Vel [m/s]; y [mm]
load('../HotWireData_Baseline.mat')

my_Y = flip(y+yOffset);
idx1 = 50;
idx2 = 51;


%% PROCESS DATA
my_Umean = mean(Vel);
my_Ustd = std(Vel);
my_Uskew = skewness(Vel);
my_Ukurt = kurtosis(Vel);

my_uprime = Vel - my_Umean;
S1 = my_uprime(:,idx1);
S2 = my_uprime(:,idx2);

[R,p] = corrcoef(S1,S2)


%% VISUALISE DATA
% Create a figure window with specific size in millimeters
figure;
set(gcf, 'Units', 'pixels', 'Position', [100, 100, 1600/2, 1000/2]); % Set figure size to 180mm x 100mm

% Define paper size for PDF export
% set(gcf, 'PaperUnits', 'centimeters');
set(gcf, 'PaperSize', [16 10]);    % Set paper size to 180mm x 100mm for PDF

% Use tiledlayout for more control over subplot spacing
t = tiledlayout(2, 2, 'Padding', 'compact', 'TileSpacing', 'compact');

% First subplot - Sine Wave
ax1 = nexttile;
plot(my_Umean,my_Y,'-k','LineWidth',1);
hold on;
plot(flip(U),my_Y,'or','MarkerFaceColor','r','MarkerSize',2);
ylabel('y [mm]')
xlabel('u [m/s]')
ylim([0,85])
legend(ax1, {'current','reference'}, 'Location', 'best'); % Legend

ax2 = nexttile;
plot(my_Ustd,my_Y,'-k','LineWidth',2);
hold on;
plot(Urms,my_Y,'or','MarkerFaceColor','r','MarkerSize',2);
ylabel('y [mm]')
xlabel('RMS u [m/s]')
ylim([0,85])
legend(ax1, {'current','reference'}, 'Location', 'best'); % Legend

ax3 = nexttile;
plot(my_Uskew,my_Y,'-k','LineWidth',2);
ylabel('y [mm]')
xlabel('S(u)')
ylim([0,85])

ax4 = nexttile;
plot(my_Ukurt,my_Y,'-k','LineWidth',2);
ylabel('y [mm]')
xlabel('K(u)')
ylim([0,85])


% Annotations with Relative Coordinates
annotation('textbox', [0.02, 0.97, 0.05, 0.05], 'String', '(a)', ...
           'FontSize', 10, 'EdgeColor', 'none');
annotation('textbox', [0.50, 0.97, 0.05, 0.05], 'String', '(b)', ...
           'FontSize', 10, 'EdgeColor', 'none');
annotation('textbox', [0.02, 0.50, 0.05, 0.05], 'String', '(c)', ...
           'FontSize', 10, 'EdgeColor', 'none');
annotation('textbox', [0.50, 0.50, 0.05, 0.05], 'String', '(d)', ...
           'FontSize', 10, 'EdgeColor', 'none');

% Save the figure as a PDF
print(gcf, 'statistics.pdf', '-dpdf', '-fillpage');

%% additional plots
% % histogram - to check whether the velocity signal is Gaussian
% figure(97)
% histogram(S1)
% xlabel('u [m/s]')
% ylabel('count')
% 
% % local velocity signal as a function of a time
% figure(98)
% plot(t,S1)
% xlabel('t [s]')
% ylabel('u [m/s]')
% 
% % scatter plot of velocity signal at neighbouring points
% figure(98)
% scatter(S1(1:100:end),S2(1:100:end),'.k')