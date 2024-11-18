clear all;
close all;
clc;

%% discrete samples
n = 32;
t = linspace(0,2*pi,n);
f = sin(t);

%% polynomial reconstruction
p_order = 5;
coeff = polyfit(t,f,p_order);
f_rec =polyval(coeff,t);

t_ext = linspace(0,10,101);
f_rec_ext = polyval(coeff,t_ext);

%% plotting
plot(t,f,'or','LineWidth',2,'MarkerFaceColor','r')
hold on;
plot(t,f_rec,'-k','LineWidth',2)
plot(t_ext,f_rec_ext,'--b','LineWidth',2)
