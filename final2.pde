#include <WaspSensorGas_v20.h>
#include "Wasp3G.h"

int8_t answer;

// Step 2. Variables declaration

char  CONNECTOR_A[3] = "CA";      
char  CONNECTOR_B[3] = "CB";    
char  CONNECTOR_C[3] = "CC";
char  CONNECTOR_D[3] = "CD";
char  CONNECTOR_E[3] = "CE";
char  CONNECTOR_F[3] = "CF";

long  sequenceNumber = 0;   
                                               
char  nodeID[10] = "MY_MOTE";   

char* sleepTime = "00:00:00:05";           

char data[100];     

float connectorAFloatValue; 
float connectorBFloatValue;  
float connectorCFloatValue;    
float connectorDFloatValue;   
float connectorEFloatValue;
float connectorFFloatValue;

int connectorAIntValue;
int connectorBIntValue;
int connectorCIntValue;
int connectorDIntValue;
int connectorEIntValue;
int connectorFIntValue;

char  connectorAString[10];  
char  connectorBString[10];   
char  connectorCString[10];
char  connectorDString[10];
char  connectorEString[10];
char  connectorFString[10];



void setup() 
{

  USB.ON();
  USB.println(F("USB ok!"));

 answer = _3G.ON();
    if (answer == 1){ USB.println(F("phase 1 ok!"));} else USB.println(F("phase 1 error!"));
    if ((answer == 1) || (answer == -3))
    {
        USB.println(F("3G module ready..."));
        
        // Sets pin code:
        USB.println(F("Setting PIN code..."));
        // **** must be substituted by the SIM code
        if (_3G.setPIN("4045") == 1) 
        {
            USB.println(F("PIN code accepted"));
        }
        else
        {
            USB.println(F("PIN code incorrect"));
        }
        
        // Waits for connection to the network
        answer = _3G.check(60);    
        if (answer == 1)
        { 
            USB.println(F("3G module connected to the network..."));
            // ********* should be replaced by the desired tlfn number
            answer = _3G.sendSMS(connectorAString,"0735688234");
            if ( answer == 1) 
            {
                USB.println(F("SMS Sent OK")); 
            }
            else if (answer == 0)
            {
                USB.println(F("Error sending sms"));
            }
            else
            {
                USB.println(F("Error sending sms")); 
                USB.print(F("CMS error code:")); 
                USB.println(answer, DEC);
                USB.print(F("CMS error code: "));
                USB.println(_3G.CME_CMS_code, DEC);
            }
        }
        else
        {
            USB.println(F("3G module cannot connect to the network..."));
        }
    }
    else
    {
        // Problem with the communication with the 3G module
        USB.println(F("3G module not started"));
    }
    
    _3G.OFF();
// Step 3. Communication module initialization

// Step 4. Communication module to ON

    USB.ON();

// Step 5. Initial message composition

  //  sprintf(data,"Hello, this is Waspmote Plug & Sense!\r\n");

// Step 6. Initial message transmission

    USB.println(data);


// Step 7. Communication module to OFF

    USB.OFF();


}

void loop()
{
// Step 8. Turn on the Sensor Board

    //Turn on the sensor board
    SensorGasv20.ON();
    //Turn on the RTC
    RTC.ON();
    //supply stabilization delay
    delay(100);

// Step 9. Turn on the sensors

// Step 10. Read the sensors

    //First dummy reading for analog-to-digital converter channel selection
    SensorGasv20.readValue(SENS_TEMPERATURE);
    //Sensor temperature reading
    connectorAFloatValue = SensorGasv20.readValue(SENS_TEMPERATURE);
    //Conversion into a string
    Utils.float2String(connectorAFloatValue, connectorAString, 2);
    
     answer = _3G.ON();
    if (answer == 1){ USB.println(F("phase 1 ok!"));} else USB.println(F("phase 1 error!"));
    if ((answer == 1) || (answer == -3))
    {
        USB.println(F("3G module ready..."));
        
        // Sets pin code:
        USB.println(F("Setting PIN code..."));
        // **** must be substituted by the SIM code
        if (_3G.setPIN("4045") == 1) 
        {
            USB.println(F("PIN code accepted"));
        }
        else
        {
            USB.println(F("PIN code incorrect"));
        }
        
        // Waits for connection to the network
        answer = _3G.check(60);    
        if (answer == 1)
        { 
            USB.println(F("3G module connected to the network..."));
            // ********* should be replaced by the desired tlfn number
            answer = _3G.sendSMS(connectorAString,"0735688234");
            if ( answer == 1) 
            {
                USB.println(F("SMS Sent OK")); 
            }
            else if (answer == 0)
            {
                USB.println(F("Error sending sms"));
            }
            else
            {
                USB.println(F("Error sending sms")); 
                USB.print(F("CMS error code:")); 
                USB.println(answer, DEC);
                USB.print(F("CMS error code: "));
                USB.println(_3G.CME_CMS_code, DEC);
            }
        }
        else
        {
            USB.println(F("3G module cannot connect to the network..."));
        }
    }
    else
    {
        // Problem with the communication with the 3G module
        USB.println(F("3G module not started"));
    }
    
    _3G.OFF();

// Step 11. Turn off the sensors

// Step 12. Message composition

    //Data payload composition
    sprintf(data,"I:%s#N:%li#%s:%s\r\n",
	nodeID ,
	sequenceNumber,
	CONNECTOR_A , connectorAString);

// Step 13. Communication module to ON

    USB.ON();

// Step 14. Message transmission

    USB.println(data);

// Step 15. Communication module to OFF

    USB.OFF();

// Step 16. Entering Sleep Mode

    PWR.deepSleep(sleepTime,RTC_OFFSET,RTC_ALM1_MODE1,ALL_OFF);
    //Increase the sequence number after wake up
    sequenceNumber++;


}
