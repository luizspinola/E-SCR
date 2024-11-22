#include <Arduino.h>
#include <math.h>    // Biblioteca para operações matemáticas (logaritmo, etc)

// Pinos
#define PWM_TEMP 14
#define PWM_COOLER 25
#define SENSOR_TEMP 26
#define SENSOR_FLUXO 27

// Variáveis
const int resolution = 4095;                                  // Resolução do conversor AD do ESP
volatile int pulsos = 0;                                      // Pulsos do sensor de fluxo
unsigned long tempoAnt_temp = 0, tempoAtual_temp = 0, dT_temp = 0;           // Variáveis para manipulação do timer
unsigned long tempoAnt_fluxo = 0, tempoAtual_fluxo = 0, dT_fluxo = 0;           // Variáveis para manipulação do timer
float temperatura = 0, resistencia = 0, vazao = 0;            // Variáveis para cálculo da temperatura e vazão
int dutycycleTemp = 0, dutycycleCooler = 0;                   // Duty Cicle do PWM do transistor e do cooler 

// Constantes do NTC e sistema
double Vs = 3.3;                                              // Tensão de referência do ESP32
double R1 = 10000;                                            // Resistor fixo de 10kΩ no divisor de tensão
double Beta = 3950;                                           // Coeficiente beta do NTC
double To = 298.15;                                           // Temperatura de referência (25°C em Kelvin)
double Ro = 10000;                                            // Resistência nominal do NTC a 25°C

//Variáveis Controlador

int cont_temp;
int cont_fluxo;

int setpoint_temp[1] = {40};
int setpoint_fluxo[1]= {0};

int ref_temp = 0;
int ref_fluxo = 0;

int i = 0;
int j = 0;

float d_temp = 0.0;
float d_fluxo = 0.0;

int pwm_max = 255;
int pwm_min = 0;

float u_temp = 0.0, ek_temp = 0.0, uk_1_temp = 0.0, ek_1_temp = 0.0, uk_2_temp = 0.0, ek_2_temp = 0.0; 
float u_fluxo = 0.0, ek_fluxo = 0.0, uk_1_fluxo = 0.0, ek_1_fluxo = 0.0;

int sampleTime_temp = 50000;
int sampleTime_fluxo = 400;

float temp1 = 24.0, temp2 = 24.0, temp3 = 24.0, mediatemp = 0.0;
float fluxo1 = 0.0, fluxo2 = 0.0, fluxo3 = 0.0, mediafluxo = 0.0;

float controle_temp(float r_temp, float y_temp);
float controle_fluxo(float r_fluxo, float y_fluxo);

//------------------------------------------------------------
// ---------- Constantes Controlador -------------------------
float a1_temp = -1.286;
float a2_temp = 0.2862;
float b0_temp = 6.395;
float b1_temp = -10.69;
float b2_temp = 5.034;

float b0_fluxo = 0.526;
float b1_fluxo = -0.1432;
// -----------------------------------------------------------
//------------------------------------------------------------

//Implementação do Controlador PID Digital
float controle_temp(float r_temp, float y_temp){

  ek_temp = r_temp-y_temp;
  u_temp = ((-1)*a1_temp*uk_1_temp) - a2_temp*uk_2_temp + b0_temp*ek_temp + b1_temp*ek_1_temp + b2_temp*ek_2_temp;    
 
  if (u_temp>255) u_temp=255;     // limitador superior
  else if (u_temp<0) u_temp=0;    // limitador inferior
  
  ek_2_temp = ek_1_temp;
  uk_2_temp = uk_1_temp;
  ek_1_temp = ek_temp;
  uk_1_temp = u_temp;


  return float(u_temp);
}

//Implementação do Controlador PI Digital
float controle_fluxo(float r_fluxo, float y_fluxo){

  ek_fluxo = r_fluxo-y_fluxo;
  u_fluxo = uk_1_fluxo + b0_fluxo*ek_fluxo + b1_fluxo*ek_1_fluxo;    
 
  if (u_fluxo>255) u_fluxo=255;     // limitador superior
  else if (u_fluxo<0) u_fluxo=0;    // limitador inferior
  
  ek_1_fluxo = ek_fluxo;
  uk_1_fluxo = u_fluxo;

  return float(u_fluxo);
}

// Rotina da interrupção que realiza leitura do sensor de fluxo
void lerFluxo(){
  pulsos++;
}

void setup() {
  Serial.begin(115200);  
  pinMode(SENSOR_TEMP, INPUT);
  pinMode(SENSOR_FLUXO, INPUT);
  pinMode(PWM_TEMP, OUTPUT);
  pinMode(PWM_COOLER, OUTPUT);

  ledcAttach(PWM_TEMP, 1000, 8);      // Configurando PWMs 
  ledcAttach(PWM_COOLER, 1000, 8);

  attachInterrupt(digitalPinToInterrupt(SENSOR_FLUXO), lerFluxo, RISING); // Interrupção para sensor de fluxo

  
}

void loop() {
  tempoAtual_temp = millis();
  dT_temp = tempoAtual_temp - tempoAnt_temp;
  tempoAtual_fluxo = millis();
  dT_fluxo = tempoAtual_fluxo - tempoAnt_fluxo;

  // TIMER TEMPERATURA -- 50 segundos
  if (dT_temp >= sampleTime_temp) {
    tempoAnt_temp = tempoAtual_temp;

    // Cálculo da vazão em L/s
    // vazao =  double((pulsos) / (120));

    // Leitura do NTC e cálculo da temperatura diretamente no loop
    int leituraADC = analogRead(SENSOR_TEMP);

    // Cálculo da temperatura com a equação Steinhart-Hart 
    double Vout = leituraADC * Vs / resolution;                 // Converte a leitura ADC para tensão
    double Rt = R1 * Vout / (Vs - Vout);                        // Calcula a resistência do NTC
    temperatura = 1 / (1 / To + log(Rt / Ro) / Beta);           // Equação de Steinhart-Hart
    temperatura = temperatura - 273.15;                         // Converte de Kelvin para Celsius

    temp1 = temp2 ;
    temp2 = temp3 ;
    temp3 = temperatura ;
    mediatemp = ( temp1 + temp2 + temp3 ) /3.0;

    // Sistema só começa após 2 s
    if(tempoAtual_temp>=2000){
      ref_temp = setpoint_temp[i];
      cont_temp++;
    }
    else{
      ref_temp= 0;
    }

    d_temp = controle_temp(ref_temp, mediatemp);
    dutycycleTemp = int(d_temp);
    
    ledcWrite(PWM_TEMP, dutycycleTemp);  // Mandando sinal PWM
  }

  //Timer Fluxo: 400ms
  if (dT_fluxo >= sampleTime_fluxo) {
    tempoAnt_fluxo = tempoAtual_fluxo;

    vazao = pulsos;
    pulsos = 0;

    fluxo1 = fluxo2 ;
    fluxo2 = fluxo3 ;
    fluxo3 = vazao ;
    mediafluxo = ( fluxo1 + fluxo2 + fluxo3 ) /3.0;

    // Sistema só começa após 2 s
    if(tempoAtual_fluxo>=2000){
      ref_fluxo = setpoint_fluxo[j];
      cont_fluxo++;
    }
    else{
      ref_fluxo= 0;
    }

    d_fluxo = controle_fluxo(ref_fluxo, mediafluxo);
    dutycycleCooler = int(d_fluxo);
    
    ledcWrite(PWM_COOLER, dutycycleCooler);
  }

    if (dT_fluxo<=3500000){
      Serial.print (tempoAtual_temp);
      Serial.print (",");
      Serial.print (mediatemp);
      Serial.print (",");
      Serial.print (mediafluxo);
      Serial.print (",");
      Serial.print (dutycycleTemp);
      Serial.print (",");
      Serial.print (dutycycleCooler);
      Serial.print (",");
      Serial.println (cont_fluxo); 
    }

  //if ((cont_fluxo>=220)&&(j<=1))
  //{ 
  //  j++;
  //  cont_fluxo = 0;
  //}
}       
