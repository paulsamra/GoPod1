//
//  BlueTableViewCell.m
//  CSR Wellness Validator
//
//  Created by Ryan Khalili on 1/17/14.
//  Copyright (c) 2014 CSR PLC. All rights reserved.
//

#import "BlueTableViewCell.h"

@implementation BlueTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.highlightedTextColor = [UIColor whiteColor];
    self.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if( selected )
    {
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:(61.0/255.0)
                                                      green:(107.0/255.0)
                                                       blue:(205.0/255.0)
                                                      alpha:1.0];
        self.selectedBackgroundView = bgColorView;
    }
}

@end