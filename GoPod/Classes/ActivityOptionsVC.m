//
//  ActivityOptionsVC.m
//  GoPod
//
//  Created by Ryan Khalili on 1/20/14.
//  Copyright (c) 2014 Swipe. All rights reserved.
//

#import "ActivityOptionsVC.h"
#import "ProfileVC.h"

static NSString* kActivities = @"Activities";
static NSString* kDevPlace   = @"Device Placements";

@interface ActivityOptionsVC ()

@property (strong, nonatomic) NSIndexPath *selectedActivity;
@property (strong, nonatomic) NSIndexPath *selectedPlacement;

@end

@implementation ActivityOptionsVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    if( self.dataType == kActivityType )
        [self.tableView selectRowAtIndexPath:self.selectedActivity animated:NO scrollPosition:UITableViewScrollPositionNone];
    else if( self.dataType == kPlacement )
        [self.tableView selectRowAtIndexPath:self.selectedPlacement animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    self.revealViewController.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.revealViewController.navigationController.navigationBar.frame.size.height + 46;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if( self.dataType == kActivityType )
        return kActivities;
    else
        return kDevPlace;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.tableData[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileVC *frontView = (ProfileVC *)self.revealViewController.frontViewController;
    NSString *selectedValue = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    if( self.dataType == kActivityType )
    {
        [frontView.csvMaker.activityDict setValue:selectedValue forKey:kActivityType];
        self.selectedActivity = indexPath;
    }
    else
    {
        [frontView.csvMaker.activityDict setValue:selectedValue forKey:kPlacement];
        self.selectedPlacement = indexPath;
    }
    
    [frontView.tableView reloadData];
    
    [[self.revealViewController.frontViewController.view viewWithTag:1000] removeFromSuperview];
    [self.revealViewController revealToggle:self];
}

- (void)frontViewTapped
{
    [[self.revealViewController.frontViewController.view viewWithTag:1000] removeFromSuperview];
    [self.revealViewController revealToggle:self];
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if ( position == 2 )
    {
        UIView *lockingView = [[UIView alloc] initWithFrame:revealController.frontViewController.view.frame];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frontViewTapped)];
        [lockingView addGestureRecognizer:tap];
        [lockingView setTag:1000];
        [revealController.frontViewController.view addSubview:lockingView];
    }
}

@end
