//
//  BLEDevice.m
//  GoPod
//
//  Created by Ryan Khalili on 1/18/14.
//  Copyright (c) 2014 CSR PLC. All rights reserved.
//

#import "BLEDevice.h"

@interface BLEDevice()

@property (strong, nonatomic, readwrite) NSString *type;
@property (strong, nonatomic, readwrite) NSString *state;
@property (strong, nonatomic, readwrite) NSString *name;

@end


@implementation BLEDevice

- (BLEDevice *)initWithName:(NSString *)name type:(NSString *)type state:(NSString *)state
{
    self = [super init];
    
    if( self )
    {
        self.name = name;
        self.type = type;
        self.state = state;
    }
    
    return self;
}

@end