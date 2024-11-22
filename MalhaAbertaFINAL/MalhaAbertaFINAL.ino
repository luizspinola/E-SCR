#include <Arduino.h>
#include <math.h>    // Biblioteca para operações matemáticas (logaritmo)

// Pinos
//#define PWM_TEMP 34
#define PWM_COOLER 25
#define SENSOR_TEMP 27
#define SENSOR_FLUXO 14

// Variáveis
const int resolution = 4095;                                  // Resolução do conversor AD do ESP
volatile int pulsos = 0;                                      // Pulsos do sensor de fluxo
unsigned long tempoAnt = 0, tempoAtual = 0, dT = 0;           // Variáveis para manipulação do timer
float temperatura = 0, resistencia = 0, vazao = 0;            // Variáveis para cálculo da temperatura e vazão
int dutycicleTemp = 0, dutycicleCooler = 0;                   // Duty Cicle do PWM do transistor e do cooler 

// Constantes do NTC e sistema
double Vs = 3.3;                                              // Tensão de referência do ESP32
double R1 = 10000;                                            // Resistor fixo de 10kΩ no divisor de tensão
double Beta = 3950;                                           // Coeficiente beta do NTC
double To = 298.15;                                           // Temperatura de referência (25°C em Kelvin)
double Ro = 10000;                                            // Resistência nominal do NTC a 25°C

// Rotina da interrupção que realiza leitura do sensor de fluxo
void lerFluxo(){
  pulsos++;
}

void setup() {
  Serial.begin(230400);  
  pinMode(SENSOR_TEMP, INPUT);
  pinMode(SENSOR_FLUXO, INPUT);
 // pinMode(PWM_TEMP, OUTPUT);
  pinMode(PWM_COOLER, OUTPUT);

  //dutycicleTemp = 50;                 // Duty Cicle setado
  dutycicleCooler = 100;

  //ledcAttach(PWM_TEMP, 1000, 8);      // Configurando PWMs 
  ledcAttach(PWM_COOLER, 1000, 8);

  //ledcWrite(PWM_TEMP, (dutycicleTemp*255)/100);  // Mandando sinais PWM
  ledcWrite(PWM_COOLER, (dutycicleCooler*255)/100);

  attachInterrupt(digitalPinToInterrupt(SENSOR_FLUXO), lerFluxo, RISING); // Interrupção para sensor de fluxo
}

void loop() {
  tempoAtual = millis();
  dT = tempoAtual - tempoAnt;

  // Tempo de Amostragem 2000ms = 2s
  if (dT >= 2000) {
    tempoAnt = tempoAtual;

    // Cálculo da vazão em L/s
    // vazao =  double((pulsos) / (120));

    // Leitura do NTC e cálculo da temperatura diretamente no loop
    int leituraADC = analogRead(SENSOR_TEMP);

    // Cálculo da temperatura com a equação Steinhart-Hart 
    double Vout = leituraADC * Vs / resolution;  // Converte a leitura ADC para tensão
    double Rt = R1 * Vout / (Vs - Vout);         // Calcula a resistência do NTC
    temperatura = 1 / (1 / To + log(Rt / Ro) / Beta); // Equação de Steinhart-Hart
    temperatura = temperatura - 273.15;  // Converte de Kelvin para Celsius
    
    vazao = pulsos;
    pulsos = 0;

    // Exibição da vazão e temperatura no Serial
    Serial.println(">Vazao:");
    Serial.print(vazao);
    Serial.println(" Pulsos");

    Serial.println(">Temperatura:");
    Serial.print(temperatura);
    Serial.println("C");
  }
}
