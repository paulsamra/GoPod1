//
//  PickerViewCell.h
//  GoPod
//
//  Created by Ryan Khalili on 1/19/14.
//  Copyright (c) 2014 Swipe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueTableViewCell.h"

@interface PickerViewCell : BlueTableViewCell

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end
