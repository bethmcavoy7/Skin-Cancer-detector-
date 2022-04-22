import serial
## change this to whatever it says in the arduino ide 
arduino_port = "COM4" 

baud = 9600 

ser = serial.Serial(arduino_port, baud)
print("Connected to Arduino port:" + arduino_port)
data=''

while not (data =="goodbye"):
    x=input('Test name? or press q to quit \n')
    if x=='q':
        break
    fileName = x + "_data.txt" 
    
    file = open(fileName, "a") 
    print("Created file")
    
    while True:
        data = ser.readline()[:-2] 
        if data:
            data=(data.decode("utf-8"))
            print(data)
            file.write(data+'\n') 
            if (data=="goodbye"):
                break 
            if (data=="Frequency sweep complete!"):
                break
    
    print("recording stopped")
    file.close()

ser.close()
print('done')