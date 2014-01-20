//
//  CSVMaker.m
//  GoRunTest
//
//  Created by Ryan Khalili on 11/17/13.
//  Copyright (c) 2013 Swipe. All rights reserved.
//

#import "CSVMaker.h"
#import <sys/utsname.h>

@interface CSVMaker ()

@property (strong, nonatomic) NSDictionary *accDict;

@end

@implementation CSVMaker

- (CSVMaker *)init
{
    self = [super init];
    
    if( self )
    {
        self.bioDict = [[NSMutableDictionary alloc] initWithDictionary:
                        @{ kHeight : @"", kAge : @"", kWeight : @"", kGender : kMale, kLocation : kIndoor }];
        
        self.activityDict = [[NSMutableDictionary alloc] initWithDictionary:
                             @{ kActivityType : @"", kPlacement : @"", kInitStepCount : @"" } ];
        
        self.libDict = [[NSMutableDictionary alloc] initWithDictionary: @{ ACTIVITY_COUNT_KEY : @0,
                                                                           kSpeed : @0, kStride : @0,
                                                                           kStepCount : @0, kDistance : @0 }];
        
        self.referenceDataDict = [[NSMutableDictionary alloc] initWithDictionary:
                                  @{ kDistance : @0,
                                     kDuration: @0,
                                     kFinalSteps : @0,
                                     kStepRate : @0,
                                     kAvgSpeed : @0,
                                     kAvgStride : @0 }];
    }
    
    return self;
}

- (void)generateCSVwithHRM:(BOOL)hrmConnected
{
    int initialStepCount = 0;
    int finalStepCount = 0;
    int totalStepCount = 0;
    
    NSArray *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *filePath = [documentsDirectory[0] stringByAppendingPathComponent:[self generateFileName]];
    
    self.csvFilePath = filePath;
    
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    NSString *stringToWrite;
    for( id key in self.bioDict )
    {
        if( [kHeight isEqualToString:key] )
        {
            NSString *height = [self.bioDict valueForKey:key];
            height = [height stringByReplacingOccurrencesOfString:@"'" withString:@"ft"];
            height = [height stringByReplacingOccurrencesOfString:@"\"" withString:@"in"];
            stringToWrite = [NSString stringWithFormat:@"%@,%@\n", key, height];
        }
        else
        {
            stringToWrite = [NSString stringWithFormat:@"%@,%@\n", key, [self.bioDict valueForKey:key]];
        }
        [fileHandle writeData:[stringToWrite dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    for( id key in self.activityDict )
    {
        if( [kInitStepCount isEqualToString:key] )
        {
            initialStepCount = [[self.activityDict valueForKey:key] intValue];
            continue;
        }
        stringToWrite = [NSString stringWithFormat:@"%@,%@\n", key, [self.activityDict valueForKey:key]];
        [fileHandle writeData:[stringToWrite dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSString *deviceType = [NSString stringWithFormat:@"Device Type,%@\n", [CSVMaker getPhoneModel]];
    
    [fileHandle writeData:[deviceType dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *osVersion = [NSString stringWithFormat:@"Device OS Version,iOS %@\n", [[UIDevice currentDevice] systemVersion]];
    
    [fileHandle writeData:[osVersion dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *contextLibVersion = [NSString stringWithFormat:@"Context Lib Version,%@\n", self.libVersion];
    
    [fileHandle writeData:[contextLibVersion dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *testWithHRM = [NSString stringWithFormat:@"HRM Data,%@\n", hrmConnected ? @"Yes" : @"No"];
    
    [fileHandle writeData:[testWithHRM dataUsingEncoding:NSUTF8StringEncoding]];
    
    [fileHandle writeData:[@"\nInfo From Reference Device\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    finalStepCount = [[self.referenceDataDict valueForKey:kFinalSteps] intValue];
    totalStepCount = finalStepCount - initialStepCount;

    for( id key in self.referenceDataDict )
    {
        if( [kFinalSteps isEqualToString:key] )
        {
            stringToWrite = [NSString stringWithFormat:@"%@,%d\n", kStepCount, totalStepCount];
        }
        else if( [kStepRate isEqualToString:key] )
        {
            double stepsTaken = totalStepCount;
            double stepRate = stepsTaken / self.testTime;
            stringToWrite = [NSString stringWithFormat:@"%@,%.2f\n", key, stepRate];
        }
        else if( [kAvgSpeed isEqualToString:key] )
        {
            stringToWrite = [NSString stringWithFormat:@"%@ (m/s),%.2f\n", key,
                             [[self.referenceDataDict valueForKey:kAvgSpeed] doubleValue]];
        }
        else if( [kAvgStride isEqualToString:key] )
        {
            stringToWrite = [NSString stringWithFormat:@"%@ (m),%.2f\n", key,
                             [[self.referenceDataDict valueForKey:kAvgStride] doubleValue]];
        }
        else if( [kDistance isEqualToString:key] )
        {
            stringToWrite = [NSString stringWithFormat:@"%@ (m),%d\n", key,
                             [[self.referenceDataDict valueForKey:kDistance] intValue]];
        }
        else if( [kDuration isEqualToString:key] )
        {
            NSInteger ti = (NSInteger)self.testTime;
            NSInteger seconds = ti % 60;
            NSInteger minutes = (ti / 60) % 60;
            stringToWrite = [NSString stringWithFormat:@"%@,%i min %i sec\n", key, minutes, seconds];
        }
        else
        {
            stringToWrite = [NSString stringWithFormat:@"%@,%@\n", key, [self.referenceDataDict valueForKey:key]];
        }
        
        [fileHandle writeData:[stringToWrite dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [fileHandle writeData:[@"\nInfo From Phone\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [fileHandle writeData:[@"Count,Timestamp,Context,Step Count,Speed (m/s),Stride Length (m),Distance (m), Latitude, Longitude\n"
                           dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *logData = [[NSFileManager defaultManager] contentsAtPath:self.logFilePath];
        
    [fileHandle writeData:logData];
    
    [fileHandle writeData:[[self averageString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [fileHandle writeData:[[self accuracyString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [fileHandle closeFile];
    
    if( hrmConnected )
        [self generateHRMLog];
    
    self.generated = YES;
}

+ (NSString *)getPhoneModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *modelString = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    
    if( [modelString isEqualToString:@"iPhone4,1"] )
    {
        return @"iPhone4S";
    }
    
    if( [modelString isEqualToString:@"iPhone5,1"] || [modelString isEqualToString:@"iPhone5,2"] )
    {
        return @"iPhone5";
    }
    
    if( [modelString isEqualToString:@"iPhone6,1"] || [modelString isEqualToString:@"iPhone6,2"] )
    {
        return @"iPhone5S";
    }
    
    if( [modelString isEqualToString:@"iPhone5,3"] || [modelString isEqualToString:@"iPhone5,4"] )
    {
        return @"iPhone5C";
    }
    
    if( [modelString isEqualToString:@"i386"] || [modelString isEqualToString:@"x86_64"] )
    {
        return @"Simulator";
    }
    
    return modelString;
}

- (NSString *)generateFileName
{
    NSString *activity = [self.activityDict valueForKey:kActivityType];
    
    NSString *placement = [self.activityDict valueForKey:kPlacement];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MM-dd-yyyy_HH-mm-ss"];
    
    self.generatedDate = [NSDate date];
    NSString *dateString = [dateFormatter stringFromDate:self.generatedDate];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    return [NSString stringWithFormat:@"SensorPod_%@_%@_%@_v%@.csv", activity, placement, dateString, appVersion];
}

- (NSString *)averageString
{
    double speedAvg = [[self.libDict valueForKey:kSpeed] doubleValue] / self.recordCount;
    double strideAvg = [[self.libDict valueForKey:kStride] doubleValue] / self.recordCount;
    
    return [NSString stringWithFormat:@",,,,Average: %.2f,Average: %.2f\n", speedAvg, strideAvg];
}

- (NSString *)accuracyString
{
    NSLog(@"CSV MAKER RECORD COUNT: %d", self.recordCount);
    int totalStepCount = [[self.referenceDataDict valueForKey:kFinalSteps] intValue] -
                         [[self.activityDict valueForKey:kInitStepCount] intValue];
    
    NSLog(@"context lib value: %f", [[self.libDict valueForKey:ACTIVITY_COUNT_KEY] doubleValue]);
    double contextAcc = ( [[self.libDict valueForKey:ACTIVITY_COUNT_KEY] doubleValue] / self.recordCount ) * 100;
    NSLog(@"Acc: %f", contextAcc);
    double stepCountAcc = ( [[self.libDict valueForKey:kStepCount] doubleValue] / totalStepCount ) * 100;
    double speedAcc = ( ( [[self.libDict valueForKey:kSpeed] doubleValue] / self.recordCount ) /
                       [[self.referenceDataDict valueForKey:kAvgSpeed] doubleValue] ) * 100;
    double strideAcc = ( ( [[self.libDict valueForKey:kStride] doubleValue] / self.recordCount ) /
                        [[self.referenceDataDict valueForKey:kAvgStride] doubleValue] ) * 100;
    double distanceAcc = ( [[self.libDict valueForKey:kDistance] doubleValue] /
                          [[self.referenceDataDict valueForKey:kDistance] doubleValue] ) * 100;
    
    if( speedAcc != speedAcc )
        speedAcc = 100;
    if( stepCountAcc != stepCountAcc )
        stepCountAcc = 100;
    if( strideAcc != strideAcc )
        strideAcc = 100;
    if( distanceAcc != distanceAcc )
        distanceAcc = 100;
    if( stepCountAcc == INFINITY )
        stepCountAcc = 0;
    if( distanceAcc == INFINITY )
        distanceAcc = 0;
    if( speedAcc == INFINITY )
        speedAcc = 0;
    if( strideAcc == INFINITY )
        strideAcc = 0;
    
    self.accDict = @{ kContext : [NSNumber numberWithDouble:contextAcc],
                      kSpeed : [NSNumber numberWithDouble:speedAcc],
                      kStepCount : [NSNumber numberWithDouble:stepCountAcc],
                      kStride : [NSNumber numberWithDouble:strideAcc],
                      kDistance : [NSNumber numberWithDouble:distanceAcc] };
    
    NSString *contextString = [NSString stringWithFormat:@"Accuracy: %.1f%%", contextAcc];
    NSString *stepCountString = [NSString stringWithFormat:@"Accuracy: %.1f%%", stepCountAcc];
    NSString *speedString = [NSString stringWithFormat:@"Accuracy: %.1f%%", speedAcc];
    NSString *strideString = [NSString stringWithFormat:@"Accuracy: %.1f%%", strideAcc];
    NSString *distanceString = [NSString stringWithFormat:@"Accuracy: %.1f%%", distanceAcc];
    
    return [NSString stringWithFormat:@",,%@,%@,%@,%@,%@", contextString, stepCountString, speedString, strideString, distanceString];
}

- (NSString *)resultsSummaryWithTitle:(NSString *)title
{
    NSString *contextString = [NSString stringWithFormat:@"Context Accuracy: %.1f%%",
                               [[self.accDict valueForKey:kContext] doubleValue]];
    NSString *stepCountString = [NSString stringWithFormat:@"Step Count Accuracy: %.1f%%",
                                 [[self.accDict valueForKey:kStepCount] doubleValue]];
    NSString *speedString = [NSString stringWithFormat:@"Speed Accuracy: %.1f%%",
                             [[self.accDict valueForKey:kSpeed] doubleValue]];
    NSString *strideString = [NSString stringWithFormat:@"Stride Length Accuracy: %.1f%%",
                              [[self.accDict valueForKey:kStride] doubleValue]];
    NSString *distanceString = [NSString stringWithFormat:@"Distance Accuracy: %.1f%%",
                                [[self.accDict valueForKey:kDistance] doubleValue]];
    
    return [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@", title, contextString, stepCountString, speedString, strideString, distanceString];
}

- (void)deleteCSVFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if( [fileManager fileExistsAtPath:self.csvFilePath] ) {
        [fileManager removeItemAtPath:self.csvFilePath error:nil];
    }
}

- (void)generateHRMLog
{
    NSArray *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *filePath = [documentsDirectory[0] stringByAppendingPathComponent:kHRMLog];
        
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:[self.hrmData dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

@end
