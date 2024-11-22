import serial
import csv
from serial import SerialException

arduino_port = "COM12"       # serial port of Arduino
baud = 115200 
fileName=input("Digite o nome do arquivo: ") + ".csv"

ser = serial.Serial(arduino_port, baud)
sensor_data = [] #store data

while True:
    try:
        getData=ser.readline()
        dataString = getData.decode('utf-8')
        data=dataString[0:][:-2]
       
        readings = data.split(",")
        print(readings)

        sensor_data.append(readings)    
       
    except SerialException as e:
            break
    except:
            pass        

with open(fileName, 'a', encoding='UTF8', newline='') as f:
    writer = csv.writer(f)
    #sensor_data.pop(0)
    writer.writerows(sensor_data)

print("Data collection complete!")