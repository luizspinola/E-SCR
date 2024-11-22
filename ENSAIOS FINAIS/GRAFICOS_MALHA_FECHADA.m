% EXPERIMENTAL DE SISTEMAS DE CONTROLE REALIMENTADO
% Exibição gráfica dos resultados de projeto  
% 
% Alunos:
% Beatriz Martins Gomes Silva           (12121EBI003)
% Júlia Miranda Brito                   (12121EBI020)
% Luiz Felipe Spinola Silva             (12121EBI001) 
%
% Professora: Gabriela Vieira Lima
%
% Data: 18/10/2024

clc; clear; close all

%-----------------------------ENSAIO 1-------------------------------------

dataEnsaio1 = readtable("ENSAIO1SABADO.csv");
dataEnsaio1 = table2array(dataEnsaio1);

time = dataEnsaio1(:,1);
temperature = dataEnsaio1(:,2);
pwm = dataEnsaio1(:,4);

figure(1)

templot = plot(time,temperature);

hold on

title('Ensaio I - Gráfico da Temperatura');

set(templot, 'LineStyle','-', 'Color', [7, 153, 146]/255, 'LineWidth', 2);

%Configuração dos Textos do gráfico
set(gca, 'FontSize', 14, 'FontName', 'Times New Roman');
xlabel('Tempo (ms)')
ylabel('Temperatura (°C)')

%Configuração dos Eixos
set(gca, 'TickLength', [.02 .02], 'XminorTick', 'on', 'YMinorTick', 'on', 'LineWidth', 1);
set(gcf, 'color', 'w');
yline(40, '--', 'setpoint', 'LabelHorizontalAlignment', 'left', 'LabelVerticalAlignment', 'middle', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [204, 0, 0]/255)
yline(38, '--', 'ts5%', 'LabelHorizontalAlignment', 'left', 'LabelVerticalAlignment', 'middle', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [204, 0, 0]/255)
yline(42, '--', 'ts5%', 'LabelHorizontalAlignment', 'left', 'LabelVerticalAlignment', 'middle','FontSize', 12, 'FontName', 'Times New Roman', 'Color', [204, 0, 0]/255)
ylim([0 50])
xlim([0 2601000])
hold off

figure(2)

pwmplot = plot(time,pwm);

hold on

title('Ensaio I - Gráfico de Duty Cycle');

ylim([0 260]);

set(pwmplot, 'LineStyle','-', 'Color', [255, 128, 0]/255, 'LineWidth', 2);

%Configuração dos Textos do gráfico
set(gca, 'FontSize', 14, 'FontName', 'Times New Roman');
xlabel('Tempo (ms)')
ylabel('Duty Cycle (8 bits)')
yline(mean(pwm(:)), '--', '|PWM|', 'LabelHorizontalAlignment', 'right', 'LabelVerticalAlignment', 'bottom', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [7, 153, 146]/255)

%Configuração dos Eixos
set(gca, 'TickLength', [.02 .02], 'XminorTick', 'on', 'YMinorTick', 'on', 'LineWidth', 1);
set(gcf, 'color', 'w');
ylim([0 255])
xlim([0 2601000])

hold off
%% ---------------------------Ensaio 2-------------------------------------

dataEnsaio2 = readtable("ENSAIO2SABADO.csv");
dataEnsaio2 = table2array(dataEnsaio2);

time2 = dataEnsaio2(:,1);
temperature2 = dataEnsaio2(:,2);
pwm2 = dataEnsaio2(:,4);

figure(3)

templot2 = plot(time2,temperature2);

hold on

title('Ensaio II - Gráfico da Temperatura');

set(templot2, 'LineStyle','-', 'Color', [7, 153, 146]/255, 'LineWidth', 2);

%Configuração dos Textos do gráfico
set(gca, 'FontSize', 14, 'FontName', 'Times New Roman');
xlabel('Tempo (ms)')
ylabel('Temperatura (°C)')

%Configuração dos Eixos
set(gca, 'TickLength', [.02 .02], 'XminorTick', 'on', 'YMinorTick', 'on', 'LineWidth', 1);
set(gcf, 'color', 'w');
yline(30, '--', '1º setpoint', 'LabelHorizontalAlignment', 'left', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [204, 0, 0]/255)
yline(50, '--', '2º setpoint', 'LabelHorizontalAlignment', 'left', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [204, 0, 0]/255)
yline(40, '--', '3º setpoint', 'LabelHorizontalAlignment', 'left', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [204, 0, 0]/255)
xline(2001000, '--', '1º Mudança', 'LabelHorizontalAlignment', 'left', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [204, 0, 0]/255, 'LabelOrientation','horizontal')
xline(4002000, '--', '2º Mudança', 'LabelHorizontalAlignment', 'right', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [204, 0, 0]/255, 'LabelOrientation','horizontal')
hold off

figure(4)

pwmplot2 = plot(time2, pwm2);

hold on

title('Ensaio II - Gráfico da Duty Cycle');

set(pwmplot2, 'LineStyle','-', 'Color', [255, 128, 0]/255, 'LineWidth', 2);

%Configuração dos Textos do gráfico
set(gca, 'FontSize', 14, 'FontName', 'Times New Roman');
xlabel('Tempo (ms)')
ylabel('Duty Cycle (8 bits)')

%Configuração dos Eixos
set(gca, 'TickLength', [.02 .02], 'XminorTick', 'on', 'YMinorTick', 'on', 'LineWidth', 1);
set(gcf, 'color', 'w');
xline(2001000, '--', '1º Mudança', 'LabelHorizontalAlignment', 'left', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [7, 153, 146]/255, 'LabelOrientation','horizontal')
xline(4002000, '--', '2º Mudança', 'LabelHorizontalAlignment', 'right', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [7, 153, 146]/255, 'LabelOrientation','horizontal')

hold off


%-------------------------------ENSAIO 3-----------------------------------

dataEnsaio3 = readtable("ENSAIO3SEGUNDA.csv");
dataEnsaio3 = table2array(dataEnsaio3);

time3 = dataEnsaio3(:,1);
temperature3 = dataEnsaio3(:,2);
flow3 = dataEnsaio3(:,3);
pwmTemperature3 = dataEnsaio3(:,4);
pwmFlow3 = dataEnsaio3(:,5);

figure(5)

templot3 = plot(time3,temperature3);

hold on

title('Ensaio III - Gráfico da Temperatura');

set(templot3, 'LineStyle','-', 'Color', [7, 153, 146]/255, 'LineWidth', 2);

%Configuração dos Textos do gráfico
set(gca, 'FontSize', 14, 'FontName', 'Times New Roman');
xlabel('Tempo (ms)')
ylabel('Temperatura (°C)')

%Configuração dos Eixos
set(gca, 'TickLength', [.02 .02], 'XminorTick', 'on', 'YMinorTick', 'on', 'LineWidth', 1);
set(gcf, 'color', 'w');
yline(45, '--', 'setpoint', 'LabelHorizontalAlignment', 'right', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [204, 0, 0]/255, 'LabelVerticalAlignment','bottom')
xline(2001000, '--', 'Mudança', 'LabelHorizontalAlignment', 'left', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [204, 0, 0]/255, 'LabelOrientation','horizontal')
hold off

ylim([0 55]);

figure (6)

fluxplot = plot(time3, flow3);

hold on

title('Ensaio III - Gráfico da Vazão'); 

set(fluxplot, 'LineStyle','-', 'Color', [7, 153, 146]/255, 'LineWidth', 1)

%Configuração dos Textos do gráfico
set(gca, 'FontSize', 14, 'FontName', 'Times New Roman');
xlabel('Tempo (ms)')
ylabel('Vazão de ar (Pulsos)')

%Configuração dos Eixos
set(gca, 'TickLength', [.02 .02], 'XminorTick', 'on', 'YMinorTick', 'on', 'LineWidth', 1);
set(gcf, 'color', 'w');
yline(12, '--', 'setpoint', 'LabelHorizontalAlignment', 'left', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [204, 0, 0]/255)
xline(2001000, '--', 'Mudança', 'LabelHorizontalAlignment', 'left', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [204, 0, 0]/255)
ylim([0 25])
hold off

figure (7)

pwmtempplot = plot(time3, pwmTemperature3);

hold on

title('Ensaio III - Gráfico de Duty Cycle de Temperatura');

set(pwmtempplot, 'LineStyle','-', 'Color', [255, 128, 0]/255, 'LineWidth', 2)

%Configuração dos Textos do gráfico
set(gca, 'FontSize', 14, 'FontName', 'Times New Roman');
xlabel('Tempo (ms)')
ylabel('Vazão de ar (Pulsos)')

%Configuração dos Eixos
set(gca, 'TickLength', [.02 .02], 'XminorTick', 'on', 'YMinorTick', 'on', 'LineWidth', 1);
set(gcf, 'color', 'w');
xline(2001000, '--', 'Mudança', 'LabelHorizontalAlignment', 'left', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [7, 153, 146]/255)

hold off

figure (8)

pwmflowplot = plot(time3, pwmFlow3);

hold on

title('Ensaio III - Gráfico de Duty Cycle de Fluxo');

set(pwmflowplot, 'LineStyle','-', 'Color', [255, 128, 0]/255, 'LineWidth', 2)

%Configuração dos Textos do gráfico
set(gca, 'FontSize', 14, 'FontName', 'Times New Roman');
xlabel('Tempo (ms)')
ylabel('Vazão de ar (Pulsos)')

%Configuração dos Eixos
set(gca, 'TickLength', [.02 .02], 'XminorTick', 'on', 'YMinorTick', 'on', 'LineWidth', 1);
set(gcf, 'color', 'w');
xline(2001000, '--', 'Mudança', 'LabelHorizontalAlignment', 'left', 'FontSize', 12, 'FontName', 'Times New Roman', 'Color', [7, 153, 146]/255)
ylim([0 200])