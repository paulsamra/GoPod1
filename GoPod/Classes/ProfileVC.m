//
//  ProfileVC.m
//  GoPod
//
//  Created by Ryan Khalili on 1/19/14.
//  Copyright (c) 2014 Swipe. All rights reserved.
//

#import "ProfileVC.h"
#import "TextFieldCell.h"
#import "SegmentedControlCell.h"
#import "PickerViewCell.h"
#import "ActivityOptionsVC.h"

static NSString *heightCellID   = @"heightCell";
static NSString *pickerCellID   = @"pickerCell";
static NSString *textCellID     = @"textFieldCell";
static NSString *segmentCellID  = @"segmentCell";
static NSString *otherCellID    = @"otherCell";

@interface ProfileVC () <TextFieldCellDelegate>

@property (strong, nonatomic) NSIndexPath   *pickerIndexPath;

@property (strong, nonatomic) NSArray       *firstSection;
@property (strong, nonatomic) NSArray       *secondSection;

@property (strong, nonatomic) UITextField   *currentEditingField;
@property (strong, nonatomic) UIToolbar     *keyboardToolbar;

@end

@implementation ProfileVC
{
    int feetHeight;
    int inchHeight;
}

static NSArray  *feetHeights;
static NSArray  *inchHeights;
static NSArray  *activities;
static NSArray  *placements;

+ (void)initialize
{
    if( !inchHeights)
        inchHeights = @[ @"0\"", @"1\"", @"2\"", @"3\"", @"4\"", @"5\"",
                         @"6\"", @"7\"", @"8\"", @"9\"", @"10\"", @"11\"" ];
    
    if( !feetHeights )
        feetHeights = @[ @"3'", @"4'", @"5'", @"6'", @"7'" ];
    
    if( !activities )
        activities = @[ @"Stationary", @"Walking", @"Fast Walking", @"Running", @"Vehicle" ];
    
    if( !placements )
        placements = @[ @"Pants Pocket", @"Holster", @"Armband", @"Shirt Pocket" ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *titleImage = [UIImage imageNamed:kNavLogo];
    self.revealViewController.navigationItem.titleView = [[UIImageView alloc] initWithImage:titleImage];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-9, 0, 0, 0);
    
    self.firstSection = @[kHeight, kWeight, kAge, kGender];
    self.secondSection = @[kActivityType, kPlacement, kLocation, kInitStepCount];
    
    feetHeight = [feetHeights[2] intValue];
    inchHeight = [inchHeights[5] intValue];
    
    // Create toolbar for number pad.
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    
    // Setup buttons on picker toolbar.
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped)];
    [toolbar setItems:[NSArray arrayWithObjects:flexButton, doneButton, nil]];
    self.keyboardToolbar = toolbar;
    
    if( !self.csvMaker )
        self.csvMaker = [[CSVMaker alloc] init];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.currentEditingField resignFirstResponder];
}

- (void)doneButtonTapped
{
    [self.currentEditingField resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( [self hasInlinePicker] && section == 0 )
        return 5;
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [self cellIDForIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSInteger actualRow = indexPath.row;
    if( self.pickerIndexPath != nil && self.pickerIndexPath.row < indexPath.row )
        actualRow--;
    
    if( cellID == heightCellID )
    {
        cell.textLabel.text = self.firstSection[0];
        NSString *heightString = [self.csvMaker.bioDict objectForKey:kHeight];
        if( [heightString isEqualToString:@""] )
        {
            cell.detailTextLabel.text = @"Enter Height";
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
        else
        {
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.text = heightString;
        }
    }
    
    else if( cellID == textCellID )
    {
        TextFieldCell *textCell = (TextFieldCell *)cell;
        textCell.selectionStyle = UITableViewCellSelectionStyleNone;
        textCell.textField.inputAccessoryView = self.keyboardToolbar;
        
        if( indexPath.section == 0 )
        {
            textCell.textLabel.text = self.firstSection[actualRow];
            
            if( actualRow == 1 )
            {
                textCell.textField.placeholder = @"Enter Weight";
                textCell.textField.text = [self.csvMaker.bioDict objectForKey:kWeight];
            }
            
            else if( actualRow == 2 )
            {
                textCell.textField.placeholder = @"Enter Age";
                textCell.textField.text = [self.csvMaker.bioDict objectForKey:kAge];
            }
        }
        
        else if( indexPath.section == 1 )
        {
            textCell.textLabel.text = self.secondSection[actualRow];
            textCell.textField.placeholder = @"Enter Value";
            textCell.textField.text = [[self.csvMaker.activityDict objectForKey:kInitStepCount] description];
        }
        
        cell = textCell;
    }
    
    else if( cellID == segmentCellID )
    {
        SegmentedControlCell *segmentCell = (SegmentedControlCell *)cell;
        
        if( indexPath.section == 0 )
        {
            segmentCell.textLabel.text = self.firstSection[actualRow];
            [segmentCell.segmentedControl setTitle:kMale forSegmentAtIndex:0];
            [segmentCell.segmentedControl setTitle:kFemale forSegmentAtIndex:1];
            [segmentCell.segmentedControl addTarget:self action:@selector(genderPicked:) forControlEvents:UIControlEventValueChanged];
        }
        
        else
        {
            segmentCell.textLabel.text = self.secondSection[actualRow];
            [segmentCell.segmentedControl setTitle:kIndoor forSegmentAtIndex:0];
            [segmentCell.segmentedControl setTitle:kOutdoor forSegmentAtIndex:1];
            [segmentCell.segmentedControl addTarget:self action:@selector(locationPicked:) forControlEvents:UIControlEventValueChanged];
        }
    }
    
    else if( cellID == otherCellID )
    {
        cell.textLabel.text = self.secondSection[actualRow];
        
        if( indexPath.row == 0 )
        {
            NSString *detailString = [self.csvMaker.activityDict objectForKey:kActivityType];
            cell.detailTextLabel.text = detailString;
        }
        else if( indexPath.row == 1 )
        {
            NSString *detailString = [self.csvMaker.activityDict objectForKey:kPlacement];
            cell.detailTextLabel.text = detailString;
        }
    }
    
    return cell;
}

- (NSString *)cellIDForIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = nil;
    
    if ( [self indexPathHasPicker:indexPath] )
        cellID = pickerCellID;
    
    else if ( indexPath.row == 0 && indexPath.section == 0 )
        cellID = heightCellID;
    
    else
    {
        if( indexPath.section == 0 )
        {
            switch( indexPath.row )
            {
                case 1: cellID = textCellID;    break;
                case 2: cellID = textCellID;    break;
                case 3: cellID = segmentCellID; break;
            }
        }
        
        else if( indexPath.section == 1 )
        {
            switch( indexPath.row )
            {
                case 0: cellID = otherCellID;   break;
                case 1: cellID = otherCellID;   break;
                case 2: cellID = segmentCellID; break;
                case 3: cellID = textCellID;    break;
            }
        }
    }
    
    return cellID;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if( section == 0 )
        return kProfile;
    else
        return kActivityOpt;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ( [self indexPathHasPicker:indexPath] ? 162 : self.tableView.rowHeight);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if( cell.reuseIdentifier == heightCellID )
        [self displayPickerAtIndexPath:indexPath];
    
    else if( cell.reuseIdentifier == otherCellID )
    {
        ActivityOptionsVC *optionsView = (ActivityOptionsVC *)self.revealViewController.rightViewController;
        
        if( indexPath.row == 0 )
        {
            optionsView.tableData = activities;
            optionsView.dataType  = kActivityType;
        }
        else if( indexPath.row == 1 )
        {
            optionsView.tableData = placements;
            optionsView.dataType  = kPlacement;
        }
        
        [optionsView.tableView reloadData];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        self.revealViewController.rightViewRevealWidth = 180;
        self.revealViewController.rightViewRevealOverdraw = 0;
        [self.revealViewController rightRevealToggleAnimated:YES];
    }
    
    else
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)togglePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    if ( [self hasPickerForIndexPath:indexPath] )
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    else
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
    [self.tableView endUpdates];
}

- (void)displayPickerAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    BOOL before = NO;
    if ( [self hasInlinePicker] )
        before = self.pickerIndexPath.row < indexPath.row;
    
    BOOL sameCellClicked = (self.pickerIndexPath.row - 1 == indexPath.row);
    
    if ( [self hasInlinePicker] )
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.pickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.pickerIndexPath = nil;
    }
    
    if ( !sameCellClicked )
    {
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self togglePickerForSelectedIndexPath:indexPathToReveal];
        self.pickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    [self updateHeightPicker];
}

- (void)updateHeightPicker
{
    if ( self.pickerIndexPath != nil )
    {
        PickerViewCell *associatedPickerCell = (PickerViewCell *)[self.tableView cellForRowAtIndexPath:self.pickerIndexPath];
        
        UIPickerView *targetedPicker = associatedPickerCell.pickerView;
        
        if (targetedPicker != nil)
        {
            [targetedPicker selectRow:feetHeight-3 inComponent:0 animated:NO];
            [targetedPicker.delegate pickerView:targetedPicker didSelectRow:feetHeight-3 inComponent:0];
            [targetedPicker selectRow:inchHeight inComponent:1 animated:NO];
            [targetedPicker.delegate pickerView:targetedPicker didSelectRow:inchHeight inComponent:1];
        }
    }
}



- (BOOL)hasInlinePicker
{
    return ( self.pickerIndexPath != nil );
}

- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ( [self hasInlinePicker] && self.pickerIndexPath.row == indexPath.row && indexPath.section == 0 );
}

- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasPicker = NO;
    
    NSInteger targetedRow = indexPath.row + 1;
    
    UITableViewCell *checkPickerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    
    hasPicker = ( checkPickerCell.reuseIdentifier == pickerCellID );
    return hasPicker;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if( component == 0 )
        return [feetHeights count];
    else
        return [inchHeights count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if( component == 0 )
        return feetHeights[row];
    else
        return inchHeights[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if( component == 0 )
        feetHeight = [feetHeights[row] intValue];
    else
        inchHeight = [inchHeights[row] intValue];
    
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ( [self hasInlinePicker] )
    {
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.pickerIndexPath.row - 1 inSection:0];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    
    NSString *newHeight = [NSString stringWithFormat:@"%d' %d\"", feetHeight, inchHeight];
    [self.csvMaker.bioDict setValue:newHeight forKey:kHeight];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.text = newHeight;
}

- (void)textField:(UITextField *)textField didBeginEditingInCell:(UITableViewCell *)cell
{
    self.currentEditingField = textField;
    
    if( [self hasInlinePicker] )
        [self displayPickerAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)textField:(UITextField *)textField didEndEditingInCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if( indexPath.section == 0 )
    {
        if( indexPath.row == 1 )
            [self.csvMaker.bioDict setObject:textField.text forKey:kWeight];
        
        else if( indexPath.row == 2 )
            [self.csvMaker.bioDict setObject:textField.text forKey:kAge];
    }
    
    else
    {
        [self.csvMaker.activityDict setObject:textField.text forKey:kInitStepCount];
    }
}

- (void)genderPicked:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    
    [self.csvMaker.bioDict setObject:[segment titleForSegmentAtIndex:segment.selectedSegmentIndex] forKey:kGender];
}

- (void)locationPicked:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    
    [self.csvMaker.activityDict setObject:[segment titleForSegmentAtIndex:segment.selectedSegmentIndex] forKey:kLocation];
}

@end
