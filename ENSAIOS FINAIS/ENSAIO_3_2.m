% EXPERIMENTAL DE SISTEMAS DE CONTROLE REALIMENTADO
% Identificação do sistema - Ensaio de identificação da planta de
% perturbação
% 
% Alunos:
% Beatriz Martins Gomes Silva           (12121EBI003)
% Júlia Miranda Brito                   (12121EBI020)
% Luiz Felipe Spinola Silva             (12121EBI001) 
%
% Professora: Gabriela Vieira Lima
%
% Data: 03/10/2024

clc; clear; close all;

%Variáveis Básicas

condIni = 26.05;                                                            %Temperatura Ambiente

temperatura = load("ENSAIO 3.2.txt").';                                     %Carregando sinal
temperatura = temperatura - 26.05;                                          %Delta de temperatura (comprimento do vetor: 2171)

tSample = 0.4;                                                              %Período de amostragem (s)
tempo = (0:tSample:(length(temperatura)-1)*tSample);                        %Vetor de tempo

%Filtro de Média Móvel

kernelSize = 5;
kernel = (1/kernelSize)*ones(1,kernelSize);

tempMediamovel = filter(kernel,1,temperatura);


%Gráfico Temperatura x Tempo

figure()
plot(tempo,temperatura, 'b')
xlabel('Tempo (s)')                                                         %Sinal sem processamento
ylabel('Temperatura (°C)')
title('Gráfico da Temperatura com Perturbação')

figure()
plot(tempo,tempMediamovel, 'b')
xlabel('Tempo (s)')                                                         %Sinal filtrado (Média Móvel 5)
ylabel('Temperatura (°C)')
title('Gráfico da Temperatura com Perturbação')

%Encontrar a função de transferência

pontoCooler = 1200;                                                         %Instante que o cooler foi ligado (8 minutos após início do ensaio = 480 segundos = 1200 pontos no vetor tempo)
finalEnsaio = 2171;                                                         %Instante que termina o ensaio

media1 = mean(tempMediamovel(pontoCooler - 1 - 150: pontoCooler - 1));      %média do 1º Regime permanente, intervalo de 150 pontos(42.6462)

media2 = mean(tempMediamovel(2171 - 150 : 2171));                           %média do 2º regime permanente, intervalo de 150 pontos (7.2353)

k = (media1 - media2) - 1.2;                                                %ganho K da função de transferência da perturbação em módulo (o -1.2 foi um ajuste no olho utilizando a figura 3 de referência)

amplitude = ((media1 - media2) * 36.8)/100;                                 %amplitude do sinal pra achar o tau pelo gráfico ( = 600.4)

hold on
yline(amplitude)                                                            %Linha horizontal auxiliar para encontrar o tau na figura 2
xline(tempo(pontoCooler))                                                   %Linha vertical para marcar o ponto onde o cooler foi ligado
yline(tempMediamovel(pontoCooler))                                          %Linha horizontal para auxiliar onde o sinal começou a cair (final do atraso de transporte)

tau = 600.4 - tempo(pontoCooler);                                           %descontando o tempo do cooler desligado

%Função de Transferência

s = tf('s');

g_ft = exp(-17.6*s)*(- k/(tau*s + 1));                                      %Função de transferência

%Ponto da dúvida, ao analisar o atraso real pela figura 2, é notável que o
%atraso terminou, ou seja, o sinal começou a decrescer, após 17.6 segundos.
%Todavia, quando se observa o atraso real pela figura 3, o sinal apenas
%começa a decrescer após cerca de 42 segundos, acredito que isso tenha
%ocorrido pois juntei gráficos gerados por funções diferentes (plot e
%step) e não consegui "sincronizar" o intervalo de amostragem das duas
%funções, acredito que o tempo correto de atraso seja de 17.6 segundos.

figure()
plot(tempMediamovel(pontoCooler:2171))                                      %plotando sinal real
hold on
step(g_ft + tempMediamovel(pontoCooler))                                    %plotando sinal "projetado" considerando nível DC
yline(tempMediamovel(pontoCooler))                                          %Linha para ver final do atraso


xlabel('Tempo (s)')                                                         
ylabel('Temperatura (°C)')

%Refazendo a identificação 1 com os dados do ensaio 3 até ponto em que se
%liga o cooler

tempEnsaio1 = temperatura(1:pontoCooler-1);                                 %Dividindo sinal (até o ponto qu ligou-se o cooler)
tempoEnsaio1 = (0:tSample:(length(tempEnsaio1)-1)*tSample);                 %Novo vetor de tempo

%Filtro de Média Móvel

tempEnsaio1medmov = filter(kernel,1,tempEnsaio1);

%Gráfico Temperatura x Tempo

figure()
plot(tempoEnsaio1,tempEnsaio1, 'b')
xlabel('Tempo (s)')                                                         %Sinal sem processamento
ylabel('Temperatura (°C)')
title('Gráfico da Temperatura sem Perturbação')

figure()
plot(tempoEnsaio1,tempEnsaio1medmov, 'b')
xlabel('Tempo (s)')                                                         %Sinal filtrado (Média Móvel 5)
ylabel('Temperatura (°C)')
title('Gráfico da Temperatura com Perturbação')

kTemp = media1;                                                             %Ganho K

hold on
yline((63.2/100) * media1);                                                 %Linha para auxiliar encontrar o tau

tauEnsaio1 = 208.6;                                                         %Armazenando valor de tau

g_t = (kTemp/(tauEnsaio1*s+1));                                             %Função de Tranferência da planta de temperatura (valores próximos aos do primeiro ensaio)

%EXTRA: Comparação de identificação utilizando função tfest

t = (0:tSample:(1071)*tSample).';                                          %Vetor de tempo
u = cat(2, zeros(1,100),255.*(ones(1,972))).';                             %Sinal de Entrada
y = tempMediamovel(1100:2171).';                                           %Sinal de Saída
y = y -y(1);
dT = 0.4000;                                                               %Tempo de Amostragem

figure()
plot(t,u,t,y)
title('Sinal Coletado');
legend('Entrada','Saída');
xlim([-20,400])

%Identificação do sistema

data = iddata(y,u,dT);
np = 1;
nz = 0;

ft_ident = tfest(data,np,nz, 17.6);

y_sim = lsim(ft_ident,u,t);

% Resultados
figure()
plot(t,y,'b',t,y_sim,'r',t,u, 'g');
legend('Dados Originais','Modelo')
ylim([-40,10])

%% Extra2: Função de transferência da planta de temperatura

timeVector = (0:tSample:(1299)*tSample).';                                  %Vetor de tempo
inputVector = cat(2, zeros(1,100),255.*(ones(1,1200))).';                   %Sinal de entrada
outputVector = cat(2, zeros(1,100), tempMediamovel(1:1200)).';              %Sinal de saída
timeSample = 0.400;                                                         %Vetor de tempo

figure()
plot(timeVector,inputVector,timeVector,outputVector)
title('Sinal Coletado');
legend('Entrada','Saída');
xlim([-20,500])
ylim([0,50])

%Identificação do sistema

data2 = iddata(outputVector,inputVector,timeSample);
np = 2;
nz = 1;

ft_ident2 = tfest(data2,np,nz, NaN);

y_sim2 = lsim(ft_ident2,inputVector,timeVector);

% Resultados
figure()
plot(timeVector,outputVector,'b',timeVector,y_sim2,'r',timeVector,inputVector, 'g');
legend('Dados Originais','Modelo')
ylim([-5,50])

%% Extra 3: Função de transferência da planta de fluxo

fluxo = load("FLUXO SCR.txt").';
outputFluxo = fluxo./0.2;                                                   %Pulsos por segundo

passoFluxo = 0.2000;                                                        %Tempo de amostragem
tempoFluxo = (0:passoFluxo:(length(fluxo)+99)*passoFluxo);                  %Vetor de tempo
inputFluxo = cat(2, zeros(1,100),255.*(ones(1,457))).';                     %Sinal de entrada
outputFluxo = cat(2, zeros(1,100), outputFluxo).';                          %(Sinal de saída)

figure()
plot(tempoFluxo,inputFluxo,tempoFluxo,outputFluxo)
title('Sinal Coletado');
legend('Entrada','Saída');
xlim([0,120])
ylim([0,80])

%Identificação do sistema

dataFluxo = iddata(outputFluxo,inputFluxo,passoFluxo);
np = 1;
nz = 0;

ft_identFluxo = tfest(dataFluxo,np,nz, NaN);

y_simFluxo = lsim(ft_identFluxo,inputFluxo,tempoFluxo);

% Resultados
figure()
plot(tempoFluxo,outputFluxo,'b',tempoFluxo,y_simFluxo,'r',tempoFluxo,inputFluxo, 'g');
legend('Dados Originais','Modelo')
ylim([-5,80])