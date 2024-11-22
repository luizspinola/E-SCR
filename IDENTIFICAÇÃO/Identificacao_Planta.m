% Identificação 

clc;
clear;
close all;

% Carregar o arquivo com os dados
filename = 'Dados.CSV';
Dados = csvread(filename);
u = Dados(:,4);                           % Sinal de entrada
y = Dados(:,2);                           % Sinal de saída
t = Dados(:,1);                           % Vetor de Tempo
dT = t(2)-t(1);                           % Intervalor de amostragem
     
figure(1)
plot(t,u,t,y)
title('Sinal Coletado');
legend('Entrada','Saída');

% Identificação do Sistema
dados = iddata(y,u,dT);               % ordem: saída, entrada e intervalo de amostragem     
np = 2;
nz  = 2;
ft_ident = tfest(dados,np,nz,NaN);    % ordem: dados, número de polos, número de zeros, atraso
 
% Simulação da FT Identificada
y_sim = lsim(ft_ident,u,t);

% Resultados
figure(2)
plot(t,y,'b',t,y_sim,'r',t,u);
legend('Dados Originais','Modelo')