//
//  CSVMaker.h
//  GoRunTest
//
//  Created by Ryan Khalili on 11/17/13.
//  Copyright (c) 2013 Swipe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ACTIVITY_COUNT_KEY @"Activity Count"

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
