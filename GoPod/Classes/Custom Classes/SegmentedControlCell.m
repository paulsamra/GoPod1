//
//  SegmentedControlCell.m
//  GoPod
//
//  Created by Ryan Khalili on 1/19/14.
//  Copyright (c) 2014 Swipe. All rights reserved.
//

#import "SegmentedControlCell.h"

@implementation SegmentedControlCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIColor *blue = [UIColor colorWithRed:0.17f green:0.35f blue:0.78f alpha:1.0f];
    self.segmentedControl.tintColor = blue;
    
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
