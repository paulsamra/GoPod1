//
//  CSVMaker.h
//  GoRunTest
//
//  Created by Ryan Khalili on 11/17/13.
//  Copyright (c) 2013 Swipe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HEIGHT_KEY @"Height"
#define WEIGHT_KEY @"Weight"
#define AGE_KEY @"Age"
#define GENDER_KEY @"Gender"
#define LOCATION_KEY @"Location"
#define MALE @"Male"
#define FEMALE @"Female"
#define INDOOR @"Indoor"
#define OUTDOOR @"Outdoor"

#define ACTIVITY_KEY @"Activity Type"
#define PLACEMENT_KEY @"Phone Placement"
#define INIT_STEP_COUNT_KEY @"Initial Step Count"

#define DISTANCE_KEY @"Distance"
#define DURATION_KEY @"Duration"
#define FINAL_STEP_COUNT_KEY @"Final Step Count"
#define STEP_RATE_KEY @"Avg Step Rate"
#define AVG_SPEED_KEY @"Avg Speed"
#define AVG_STRIDE_LENGTH_KEY @"Avg Stride Length"

#define STEP_COUNT @"Step Count"
#define SPEED_KEY @"Speed"
#define STRIDE_KEY @"Stride Length"
#define ACTIVITY_COUNT_KEY @"Activity Count"

#define CONTEXT_KEY @"Context"

@interface CSVMaker : NSObject

@property (strong, nonatomic) NSMutableDictionary *bioDict;
@property (strong, nonatomic) NSMutableDictionary *activityDict;
@property (strong, nonatomic) NSMutableDictionary *referenceDataDict;
@property (strong, nonatomic) NSMutableDictionary *libDict;

@property (strong, nonatomic) NSString *logFilePath;
@property (nonatomic) NSTimeInterval testTime;
@property (strong, nonatomic) NSString *csvFilePath;
@property (strong, nonatomic) NSString *hrmFilePath;
@property (strong, nonatomic) NSDate *generatedDate;
@property (nonatomic) BOOL generated;
@property (nonatomic) int recordCount;
@property (strong, nonatomic) NSString *hrmData;

@property (strong, nonatomic) NSString *libVersion;

- (void)generateCSVwithHRM:(BOOL)hrmConnected;
- (void)deleteCSVFile;
- (NSString *)resultsSummaryWithTitle:(NSString *)title;
+ (NSString *)getPhoneModel;

@end
