//
//  AppHealthManager.m
//  GoPod
//
//  Created by Ryan Khalili on 1/18/14.
//  Copyright (c) 2014 CSR PLC. All rights reserved.
//

#import "AppHealthManager.h"
#import "MHealthManager.h"
#import "BLEDevice.h"

@interface AppHealthManager()

@property (strong, nonatomic) NSMutableArray *deviceArray;
@property (strong, nonatomic) MHealthManager *mHealthManager;

@end

@implementation AppHealthManager

+ (id)sharedManager
{
    static AppHealthManager *sharedManager = nil;
    static dispatch_once_t once;
    dispatch_once( &once, ^{
        NSLog(@"INIT");
        sharedManager = [[AppHealthManager alloc] init];
    });
    
    return sharedManager;
}

- (AppHealthManager *)init
{
    self = [super init];
    
    if( self )
    {
        self.deviceArray = [[NSMutableArray alloc] init];
        
        self.mHealthManager = [[MHealthManager alloc] init];
        
        [self.mHealthManager registerEvent:^(M_HealthOutput mHealthOutput){
            //[self healthManagerEvent:mHealthOutput];
        }];
        [self.mHealthManager registerScanEvent:^(M_ScanOutput mScanOutput){
            [self deviceScanEvent:mScanOutput];
        }];
    }
    
    return self;
}

- (void)scanForDevices
{
    [self.mHealthManager bleScan];
}

- (BOOL)connectToDeviceAtIndex:(int)index
{
    return [self.mHealthManager bleConnect:index];
}

- (void)deviceScanEvent:(M_ScanOutput)scan
{
    [self.deviceArray removeAllObjects];
    
    for ( int i = 0; i < scan.count; i++ )
    {
        NSString *deviceName = [NSString stringWithFormat:@"%s", scan.device[i].name];
        NSString *type, *state;
        
        switch ( scan.device[i].type )
        {
            case BLE_SENSORPOD:  type = kSensorPod;     break;
            case BLE_HEARTRATE:  type = kHRM;           break;
            default           :  type = kUnknownDevice; break;
        }
        
        switch ( scan.device[i].state )
        {
            case BLE_DISCONNECTED :  state = kDisconnected;   break;
            case BLE_CONNECTING   :  state = kConnecting;     break;
            case BLE_CONNECTED    :  state = kConnected;      break;
            case BLE_DISCONNECTING:  state = kDisconnecting;  break;
        }
        
        if ( scan.device[i].type == BLE_SENSORPOD && scan.device[i].state == BLE_CONNECTED )
            self.sensorPodConnected = YES;
        if( scan.device[i].type == BLE_HEARTRATE && scan.device[i].state == BLE_CONNECTED )
            self.hrmConnected = YES;
        
        BLEDevice *device = [[BLEDevice alloc] initWithName:deviceName type:type state:state];
        
        [self.deviceArray addObject:device];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kScanDone object:[self.deviceArray copy]];
}

@end