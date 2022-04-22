

#include <Wire.h>
#include "AD5933.h"
#include <Adafruit_RGBLCDShield.h>
#include <utility/Adafruit_MCP23017.h>

Adafruit_RGBLCDShield lcd = Adafruit_RGBLCDShield();

//Define(s) for AD5933
#define START_FREQ  (1000)
#define FREQ_INCR   (1000)
#define NUM_INCR    (100)
#define REF_RESIST  (10000)

// Defines for LED Backlighting Display
#define RED 0x1
#define YELLOW 0x3
#define GREEN 0x2
#define TEAL 0x6
#define BLUE 0x4
#define VIOLET 0x5
#define WHITE 0x7

//Define Addresses for respective I2C Ports
#define AD59333_add (0x0D)
#define display_add (0x20)

double gain[NUM_INCR+1];
int phase[NUM_INCR+1];
int calibration_flag = 0;

void setup(void)
{
  // Begin I2C
  Wire.begin();

  // Begin serial at 9600 baud for output
  Serial.begin(9600);

  //Testing LCD  
  lcd.begin(16, 2);
  int time = millis();
  lcd.setCursor(0, 0);
  lcd.print("AD5933 Test");
  lcd.setCursor(0, 1);
  lcd.print("Select to Start");
  Serial.println("AD5933 Test Started!");

  // Perform initial configuration. Fail if any one of these fail.
  if (!(AD5933::reset() &&
        AD5933::setInternalClock(true) &&
        AD5933::setStartFrequency(START_FREQ) &&
        AD5933::setIncrementFrequency(FREQ_INCR) &&
        AD5933::setNumberIncrements(NUM_INCR) &&
        AD5933::setPGAGain(PGA_GAIN_X1)))
        {
            Serial.println("FAILED in initialization!");
            lcd.print("FAILED in initialization!");
            while (true) ;
        }       

}

void loop(void)
{  
  main_function();
}

void main_function(){
  uint8_t buttons = lcd.readButtons();
  switch (buttons){
    case BUTTON_SELECT:
      if (!calibration_flag){
        lcd.clear();
        lcd.print("Up to Calibrate");
        
        //removed below to simplify logic & fix it jumping straight into calibration without waiting for the button press
        //-> remove comment/commented-out-code once read  <3
        /*buttons = lcd.readButtons();
        if (buttons && BUTTON_UP) {
          lcd.setCursor(0,1);
          lcd.print("Calibrating ");
          calibrate_function();
          break;
        }*/
        break;
      }
    case BUTTON_DOWN:
      if (calibration_flag){
        lcd.setCursor(0,0);
        lcd.clear();
        lcd.print("Measuring");
        frequencySweepEasy();
        lcd.clear();
        lcd.print("Sweep Done");
        delay(2000);
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("Down to Measure");
        lcd.setCursor(0,1);
        lcd.print("Up to Calibrate");
        break;
      }
    case BUTTON_UP:
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("Calibrating ");
        calibrate_function();
        break;
    case BUTTON_RIGHT:
        lcd.clear();
        lcd.setCursor(0,0);
        lcd.print("goodbye ");
        Serial.println("goodbye");
        break;
  }
}

void calibrate_function(){
  // Perform calibration sweep
  if (AD5933::calibrate(gain, phase, REF_RESIST, NUM_INCR+1))
  {
    calibration_flag = 1;
    Serial.println("Calibrated!");
    lcd.setCursor(0,0);
    lcd.clear();
    lcd.print("Calibrated!");
    lcd.setCursor(0,1);
    lcd.print("Down to Measure");
  }
  else
  {
    lcd.setCursor(0,0);
    lcd.clear();
    Serial.println("Calibration failed...");
    lcd.print("Calibration failed!");

  }
}

void frequencySweepEasy() {
    // Create arrays to hold the data
    int real[NUM_INCR+1], imag[NUM_INCR+1];

    // Perform the frequency sweep
    if (AD5933::frequencySweep(real, imag, NUM_INCR+1)) {
      // Print the frequency data
      float cfreq = START_FREQ;
      for (int i = 0; i < NUM_INCR+1; i++, cfreq += FREQ_INCR) {
        // Print raw frequency data
        Serial.print(cfreq);
        Serial.print(": R=");
        Serial.print(real[i]);
        Serial.print("/I=");
        Serial.print(imag[i]);

        // Compute impedance
        double magnitude = sqrt(pow(real[i], 2) + pow(imag[i], 2));
        double impedance = 1/(magnitude*gain[i]);
        Serial.print("  |Z|=");
        Serial.println(impedance);
      }
      Serial.println("Frequency sweep complete!");
      
    } else {
      lcd.setCursor(0,0);
      lcd.clear();
      Serial.println("Frequency sweep failed...");
      lcd.print("Sweep failed!");
    }
}
