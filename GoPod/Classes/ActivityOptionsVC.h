//
//  ActivityOptionsVC.h
//  GoPod
//
//  Created by Ryan Khalili on 1/20/14.
//  Copyright (c) 2014 Swipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface ActivityOptionsVC : UITableViewController <SWRevealViewControllerDelegate>

@property (strong, nonatomic) NSArray   *tableData;
@property (strong, nonatomic) NSString  *dataType;

@end