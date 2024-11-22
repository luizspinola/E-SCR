% ENSAIO  TEMPERATURA
clear;
clc;
close all;

% Carregar o arquivo txt
temp = load("TEMP SCR.txt").';

% Subtraindo temperatura ambiente
temperatura = temp - 26.05; % temp(0) = 26,05

% Definir o intervalo de tempo (em segundos)
% 400 ms
passo = 0.4; 

% Criar o vetor de tempo
tempo = (0:passo:(length(temperatura)-1)*passo); 

% Exibir os primeiros 10 valores de tempo e temperatura 
%disp('Tempo (s)  Temperatura (°C):');
%disp([tempo(1:10), temperatura(1:10)]);

% Gráficos Tempo x Temperatura
figure(1);
plot(tempo, temperatura, 'b');
xlabel('Tempo (s)');
ylabel('Temperatura (°C)');
title('Gráfico de Temperatura');

% disp(length(temperatura));
% tamanho do vetor temperatura = 1168
% Encontrar função de transferência Gt(s)


media = mean(temperatura(900:1168));
% media = 38.4865 
disp(media);

% Valor do ganho K 
k = 38.4865;

% Valor da constante Tau
Amplitude = (38.4865 * 63.2)/100;
disp(Amplitude); % 24.3235


hold on

yline(Amplitude)

Tau = 212;

% Função de transferência de 1° Ordem
s=tf('s');

G_T = k/(Tau*s + 1);
G_T

%% Parte 2: Fluxo

clc; clear;

fluxo = load("FLUXO SCR.txt").';
fluxo = fluxo./0.2;

%Período de amostragem (s)
passoFluxo = 0.2;

%Vetor de tempo

tempoFluxo = (0:passoFluxo:(length(fluxo)-1)*passoFluxo);

% Gráficos Tempo x Fluxo
figure();
plot(tempoFluxo, fluxo, 'b');
xlabel('Tempo (s)');
ylabel('Fluxo (pulsos)');
title('Gráfico de Fluxo de ar');

xlim([0 15])
%% Parte 3: Resfriamento

clc; clear; close all;

% Temperatura atingir regime permanente: temp_amb + temp_perm = 26.05 + 38.4865
% 64.5365

pertub1 = load("PERTURBAÇÃO SCR.txt").';

% Subtraindo temperatura ambiente
pertub = pertub1 - 26.05; % temp(0) = 26.05C

% Tamanho do vetor pertubação
disp(length(pertub));
% tamanho do vetor fluxo = 2870

% Período de amostragem (s)
passoPertub = 0.4;

% Vetor de tempo
tempoPertub = (0:passoPertub:(length(pertub)-1)*passoPertub);

% Gráficos Tempo x Fluxo
figure(1);
plot(tempoPertub, pertub, 'b');
xlabel('Tempo (s)');
ylabel('Temperatura');
title('Gráfico da Temperatura com Perturbação');



% Encontrar função de transferência Gft(s)

% Média
media1 = mean(pertub(1375:1550));
% media =  42.6619
media1

media2 = mean(pertub(2375:2870));
% media = 6.7112
media2

% Valor do ganho K
k = media1 - media2;

% Valor da constante Tau
Amplitude = ( (media1 - media2) * 36.8)/100;
Amplitude; % 13.2299


hold on
yline(Amplitude)

Tau = 732.8 - 620;


% Função de transferência de 1° Ordem
s=tf('s');

G_FT = - k/(Tau*s + 1);

figure(2)
plot(pertub(1550:2870));

hold on
x = step(G_FT + media1); 



