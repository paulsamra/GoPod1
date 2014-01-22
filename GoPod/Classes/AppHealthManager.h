//
//  AppHealthManager.h
//  GoPod
//
//  Created by Ryan Khalili on 1/18/14.
//  Copyright (c) 2014 CSR PLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHealthManager : NSObject

@property (nonatomic) BOOL sensorPodConnected;
@property (nonatomic) BOOL hrmConnected;

+ (id)sharedManager;

- (void)scanForDevices;
- (BOOL)connectToDeviceAtIndex:(int)index;

@end
