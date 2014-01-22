//
//  MHealthManager.h
//
//  Created by E. Philosoph on 11/5/13.
//  Copyright (c) 2013 Cambridge Silicon Radio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MHealthLogger.h"

#include "HealthFitnessApi.h"

#define MHEALTH_LIB_VERSION "mHealth Version 1.09"


@interface MHealthManager : NSObject

/*============================================================================*
 * API - Functions
 *============================================================================*/

// Discription : Register health output event
// Input       : Callback function that fires every time there is an update to 
//               the health output
// Output      :
-(void) registerEvent:(void(^)(M_HealthOutput))handler;

// Discription : Register BLE scan results event
// Input       : Callback function that fires every time there is an update to 
//               the BLE scan results
// Output      :
-(void) registerScanEvent:(void(^)(M_ScanOutput))handler;


// Discription : Initialize health library
// Input       :
// Output      : Health library pointer
-(MHealthManager *) init;


// Discription : Start health library
// Input       : 
// Output      : NO - for fail to start health library
-(BOOL) start;


// Discription : Stop health library
// Input       : 
// Output      : 
-(void) stop;


// Discription : Reset health library
// Input       : 
// Output      : 
-(void) reset;


// Discription : Start scan for BLE devices.
// Input       : 
// Output      : 
-(void) bleScan;


// Discription : Connect/Disconnect BLE device.
// Input       : Index id of the discovered device
// Output      : 
//                YES - for connection/disconnection attempt, 
//                NO - for similar device already connected
-(BOOL) bleConnect:(int)index;


// Discription : Gets user parameters sush as height and weight
// Input       :
// Output      : User parameters data structure
-(M_UserParameters) getUserParams;


// Discription : Sets user parameters such as height and weight
// Input       : User parameters data structure
// Output      :
-(void) setUserParams:(M_UserParameters)mUserParams;


// Discription : Gets server configuration such as HTTP address
// Input       :
// Output      : Server configuration
-(M_ServerConfig) getServerConfig;


// Discription : Sets server configuration such as HTTP address
// Input       : Server configuration
// Output      :
-(void) setServerConfig:(M_ServerConfig)mServerConfig;


// Discription : Gets location parameters
// Input       :
// Output      : Location parameters
-(M_LocationOutput) getLocation;


// Discription : Gets library version
// Input       :
// Output      : Pointer to version name
-(NSString *) getLibVersion;


// Discription : Enable logging
// Input       : YES/NO
// Output      :
-(void) enableLogging:(BOOL) logging;

@end
