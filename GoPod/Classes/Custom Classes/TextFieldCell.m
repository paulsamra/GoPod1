//
//  TextFieldUITableViewCell.m
//  GoRunMU
//
//  Created by Ryan Khalili on 1/17/14.
//  Copyright (c) 2014 Ryan Khalili. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.textField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if( [self.delegate respondsToSelector:@selector(textField:didEndEditingInCell:)] )
    {
        [self.delegate textField:textField didEndEditingInCell:self];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if( [self.delegate respondsToSelector:@selector(textField:didBeginEditingInCell:)] )
    {
        [self.delegate textField:textField didBeginEditingInCell:self];
    }
}

@end
