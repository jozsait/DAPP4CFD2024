clear all;
close all;
clc;

%% PARAMETERS
% interval
x0 = 1e-4;
x1 = 10;

% amplitude
A = -1;

% sample size
n = 1024;
% spacing type - 'log' or 'lin'
spacing_type = 'lin';


%% symbolic representation
% symbolic (continuous representation)
syms f x
f = 1+A*x*sin(x)^2;

mean_symb = eval( int(f,[x0,x1])/(x1-x0) );
std_symb = eval( sqrt(int((f-mean_symb)^2,[x0,x1])/(x1-x0)) );
skewness_symb = eval( int((f-mean_symb)^3,[x0,x1])/(x1-x0)/std_symb^3 );
kurtosis_symb = eval( int((f-mean_symb)^4,[x0,x1])/(x1-x0)/std_symb^4 );

disp('Symbolic mean, standard deviation, skewness, kurtosis')
disp([mean_symb, std_symb, skewness_symb, kurtosis_symb])


%% discrete representation
if strcmp(spacing_type,'log')
    x_d = logspace(log10(x0),log10(x1),n);
elseif strcmp(spacing_type,'lin')
    x_d = linspace(x0,x1,n);
else
    error('Spacing_type is not known')
end
L = x_d(2)-x_d(1);
k_sampling = 1/L;
% disp(k_sampling);
f_d = 1+A*x_d.*sin(x_d).^2;


% implementation for uniform spacing
% disp([mean(f_d), std(f_d), skewness(f_d), kurtosis(f_d)])

% generic implementation
mean_disc = trapz(x_d,f_d)/(x1-x0);
std_disc = sqrt(trapz(x_d,(f_d-mean_disc).^2)/(x1-x0));
skewness_disc = trapz(x_d,(f_d-mean_disc).^3)/(x1-x0)/std_disc^3;
kurtosis_disc = trapz(x_d,(f_d-mean_disc).^4)/(x1-x0)/std_disc^4;

disp('Discrete mean, standard deviation, skewness, kurtosis')
disp([mean_disc, std_disc, skewness_disc, kurtosis_disc])


%% plot
fplot(f,[x0,x1],'-r','LineWidth',2)
hold on
plot(x_d,f_d,'+k','LineWidth',2)