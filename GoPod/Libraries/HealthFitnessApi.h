//
//  HealthFitnessApi.h
//
//  Created by E. Philosoph on 10/18/13.
//  Copyright (c) 2013 Cambridge Silicon Radio. All rights reserved.
//
#ifndef _HEALTHFITNESSAPI_H_
#define _HEALTHFITNESSAPI_H_


/*============================================================================*
 * Defines
 *============================================================================*/

#define MAX_DEVICES                 32    // max number of supported/discovered BLE devices
#define MAX_DEVICE_NAME             64    // max name length of a BLE device
#define MAX_DATE_STRING             32    // max date string length
#define MAX_VERSION_STRING          32    // max version string length

#define MAX_SERVER_NAME             256   // max server HTTP address name
#define MAX_LTS_MSG_TO_SERVER       2048  // max message length to server
#define MAX_LTS_MSG_FROM_SERVER     128   // max message c from server
#define MAX_HTTP_MSG_TO_SERVER      MAX_LTS_MSG_TO_SERVER
#define MAX_HTTP_MSG_FROM_SERVER    MAX_LTS_MSG_FROM_SERVER

/*============================================================================*
 * Macros
 *============================================================================*/

#ifndef MEMCLR
   #define MEMCLR(a) memset(&a,0,sizeof(a))  // reset memory
#endif


/*============================================================================*
 * Enumerators
 *============================================================================*/

// Context modes
typedef enum
{
   CONTEXT_UNKNOWN,           // device state is unknown
   CONTEXT_STATIONARY,        // device is on a stationaty person
   CONTEXT_MOVING,            // device is in move state
   CONTEXT_WALKING,           // device is on a walking person
   CONTEXT_FAST_WALKING,      // device is on a fast walking person
   CONTEXT_JOGGING,           // device is on a running person
   CONTEXT_STAIRS_UP,
   CONTEXT_STAIRS_DOWN,
   CONTEXT_RAMP,
   CONTEXT_ELEVATOR_UP,
   CONTEXT_ELEVATOR_DOWN,
   CONTEXT_ESCALATOR_UP,
   CONTEXT_ESCALATOR_DOWN,
   CONTEXT_PEDESTRIAN_MASK       = 0x0F,
   CONTEXT_VEHICLE_BIT_MASK      = 0x30,
   CONTEXT_VEHICLE_DRIVING_BIT_MASK = 0xC0,
   CONTEXT_PEDESTRIAN_BIT_MASK   = 0x20

} E_FitnessContext ;


// BLE supported devices
typedef enum
{
   BLE_UNKNOWN,     // 
   BLE_RSC,         // Run, Speed & Cadence
   BLE_SENSORPOD,   // Sensor Pod
   BLE_HEARTRATE    // Heart Rate Monitor

} E_BleDeviceType ;


// BLE device mask
typedef enum
{
   BLE_MASK_SENSORPOD=1,
   BLE_MASK_HEARTRATE=2

} E_BleMask ;


// BLE connection state
typedef enum
{
   BLE_DISCONNECTED,
   BLE_CONNECTING,  
   BLE_CONNECTED,   
   BLE_DISCONNECTING

} E_BleConnectionState ;


// BLE error type
typedef enum
{
   BLE_SUCCESS,
   BLE_ERROR_DISCONNECTION,
   BLE_ERROR_CONNECTION,
   BLE_ERROR_FORCED_DISCONNECTION

} E_BleError ;


// iOS M7 confidence in generated context
typedef enum
{
   M7ConfidenceLow,
   M7ConfidenceMedium,
   M7ConfidenceHigh

} E_M7Confidence ;


// Supported technologies
typedef enum
{
   TECHNOLOGY_NATIVE,   // native sensors
   TECHNOLOGY_M7,       // M7 methods
   TECHNOLOGY_BLE       // BLE sensors

} E_Technology ;


// Supported data structure
typedef enum
{
   SUPPORT_MASK_SENSORS  = 0x01, 
   SUPPORT_MASK_CONTEXT  = 0x02,
   SUPPORT_MASK_LOCATION = 0x04,
   SUPPORT_MASK_ATTITUDE = 0x08,
   SUPPORT_MASK_SERVER   = 0x10,
   SUPPORT_MASK_BLE      = 0x20

} E_Supports ;


/*============================================================================*
 * Data Types
 *============================================================================*/

// Fitness output data structure
typedef struct
{
   E_FitnessContext  context;    // context of a person
   int               steps;      // number of steps since last reset
   float             distance;   // elapse distance since last reset in meters
   float             stride;     // stride length in meters
   float             speed;      // speed in meters/second

} M_FitnessOutput;


// Location output data structure
typedef struct
{
   float    altitude;            // altitude in meters
   double   latitude;            // latitude in degrees
   double   longitude;           // longitude in degrees
   double   speed;               // gnss speed in m/s
   double   vAccuracy;           // vertical accuracy meters
   double   hAccuracy;           // horizontal accuracy in meters

} M_LocationOutput;


// Attitude output data structure
typedef struct
{
   float    heading;             // heading in degrees between 0 to 360
   float    pitch;               // pitch in degrees between -90 to +90
   float    roll;                // roll in degrees between -180 to +180

} M_AttitudeOutput;


// MEMS Algorithm output data structure
typedef struct
{
   M_FitnessOutput   fitness;    // fitness output
   M_LocationOutput  location;   // location output
   M_AttitudeOutput  attitude;   // attitude output

} M_MemsAlgOutput;


// Sensor pod output data structure
typedef struct
{
   M_FitnessOutput   fitness;       // fitness output
   float             acceleration;  // norm acceleration in meters/second^2
   int               battery;       // battery percentage
   char              version[MAX_VERSION_STRING];  // saftware/firmware name

} M_SensPodOutput;


// Heart rate output data structure
typedef struct
{
   int   heartRate, energy, rr;     // beats per minute. energy and RR

} M_HeartRateOutput;


// BLE device measurement output
typedef struct
{
   E_BleMask         mask ;         // mask for SensorPod or Heart Rate Monitor
   M_SensPodOutput   sens ;         // SensorPod output
   M_HeartRateOutput harm ;         // HRM output

} M_BleOutput;


// iOS M7 output data structure
typedef struct
{
   M_FitnessOutput   fitness;
   char              startDate[MAX_DATE_STRING] ;  // The time at which the change in motion occurred.
   E_M7Confidence    confidence ;                  // The confidence in the assessment of the motion type.
   M_AttitudeOutput  attitude;                     // Device attitude

} M_IosM7Output;


// User parameters
typedef struct
{
   float    height;     // user height in meters
   float    weight;     // user weight in kilograms

} M_UserParameters;


// Server configuration
typedef struct
{
   char  name[MAX_SERVER_NAME] ; // HTTP address

} M_ServerConfig;


// Sensor output for debugging
typedef struct
{
   float          accX, accY, accZ ;
   float          gyrX, gyrY, gyrZ ;
   float          magX, magY, magZ ;
   int            accuracy;
   NSTimeInterval timestamp ;

} M_SensorData;


// HTTP output for debugging
typedef struct
{
   char           out[MAX_HTTP_MSG_TO_SERVER] ;
   char           in[MAX_HTTP_MSG_FROM_SERVER] ;
   unsigned char  decodedBuf[MAX_LTS_MSG_FROM_SERVER] ;
   int            size;

} M_HttpOutput;


// CCSE output for debugging
typedef struct
{
   unsigned char  uncodedBuf[MAX_LTS_MSG_TO_SERVER];
   int            size;

} M_CcseOutput;


// CCSE substructure
typedef struct
{
   M_FitnessOutput   fitness;
   M_LocationOutput  location;
   M_AttitudeOutput  attitude;

} M_CcseData;


// BLE device
typedef struct
{
   E_BleDeviceType         type;                   // device type such as SENSOR-POD/HEART-RATE
   E_BleConnectionState    state;                  // connection state
   E_BleError              error;                  // device connection/disconnection error
   int                     index;                  // internal device index
   char                    name[MAX_DEVICE_NAME];  // Device Names.

} M_DeviceData;


// BLE scan output
typedef struct
{
   int            count;               // Number of found devices.
   M_DeviceData   device[MAX_DEVICES]; // list of found devices

} M_ScanOutput;


// Health main poutput
typedef struct
{
   E_Technology      technology;    // technology type
   E_Supports        supports;      // output data type
   M_SensorData      sensor;        // for debugging - native sensor data
   M_CcseData        ccse;          // CCSE data output
   M_HttpOutput      http;          // HTTP output
   M_BleOutput       ble;           // BLE output

} M_HealthOutput;


#endif // _HEALTHFITNESSAPI_H_
