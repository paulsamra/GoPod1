//
//  BLEDevice.h
//  GoPod
//
//  Created by Ryan Khalili on 1/18/14.
//  Copyright (c) 2014 CSR PLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEDevice : NSObject

@property (strong, nonatomic, readonly) NSString *type;
@property (strong, nonatomic, readonly) NSString *state;
@property (strong, nonatomic, readonly) NSString *name;

- (BLEDevice *)initWithName:(NSString *)name type:(NSString *)type state:(NSString *)state;

@end