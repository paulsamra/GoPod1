//
//  TextFieldUITableViewCell.h
//  GoRunMU
//
//  Created by Ryan Khalili on 1/17/14.
//  Copyright (c) 2014 Ryan Khalili. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextFieldCellDelegate <NSObject>

@required
- (void)textField:(UITextField *)textField didEndEditingInCell:(UITableViewCell *)cell;
- (void)textField:(UITextField *)textField didBeginEditingInCell:(UITableViewCell *)cell;

@end


@interface TextFieldCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic)   IBOutlet id<TextFieldCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end