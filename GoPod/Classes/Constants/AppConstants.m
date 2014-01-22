//
//  AppConstants.m
//  GoPod
//
//  Created by Ryan Khalili on 1/19/14.
//  Copyright (c) 2014 Swipe. All rights reserved.
//

// BLE device types
NSString* const kSensorPod      = @"SensorPod";
NSString* const kHRM            = @"Heart Rate Monitor";
NSString* const kUnknownDevice  = @"Unknown";

// BLE connection states
NSString* const kConnected      = @"Connected";
NSString* const kDisconnected   = @"Disconnected";
NSString* const kConnecting     = @"Connecting...";
NSString* const kDisconnecting  = @"Disconnecting...";

// Profile options
NSString* const kProfile        = @"Profile";
NSString* const kHeight         = @"Height";
NSString* const kWeight         = @"Weight";
NSString* const kAge            = @"Age";
NSString* const kGender         = @"Gender";
NSString* const kMale           = @"Male";
NSString* const kFemale         = @"Female";

// Activity Options
NSString* const kActivityOpt    = @"Activity Options";
NSString* const kActivityType   = @"Activity Type";
NSString* const kLocation       = @"Location";
NSString* const kPlacement      = @"Device Placement";
NSString* const kInitStepCount  = @"Initial Step Count";
NSString* const kIndoor         = @"Indoor";
NSString* const kOutdoor        = @"Outdoor";

// Test data
NSString* const kDistance       = @"Distance";
NSString* const kDuration       = @"Duration";
NSString* const kStepCount      = @"Step Count";
NSString* const kSpeed          = @"Speed";
NSString* const kStride         = @"Stride Length";
NSString* const kContext        = @"Context";

// Reference data
NSString* const kFinalSteps     = @"Final Step Count";
NSString* const kAvgSpeed       = @"Avg Speed";
NSString* const kAvgStride      = @"Avg Stride Length";
NSString* const kStepRate       = @"Avg Step Rate";

// NSNotificationCenter keys
NSString* const kScanDone       = @"Scan Done";

// Filenames
NSString* const kHRMLog         = @"hrm.csv";

// Image filenames
NSString* const kNavLogo        = @"Nav_Logo";
NSString* const kSPicon         = @"sensorpod";
NSString* const kHRMicon        = @"hrm";