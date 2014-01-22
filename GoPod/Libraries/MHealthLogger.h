//
//  MHealthLogger.h
//
//  Created by E. Philosoph on 1/17/14.
//  Copyright (c) 2013 Cambridge Silicon Radio. All rights reserved.
//

#import <Foundation/Foundation.h>

#define log MHealthLogger logFormat


@interface MHealthLogger : NSObject
{
   NSFileManager                   *fileManager;
   NSDate                          *baseTime;
   NSFileHandle                    *fileHandle;
   NSString                        *logName;
   NSInteger                        recordCount;
}

+(void)startLogging;
+(void)stopLogging;
+(void)logFormat: (NSString *) format, ...;

@end
