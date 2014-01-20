//
//  ActivityOptionsVC.m
//  GoPod
//
//  Created by Ryan Khalili on 1/20/14.
//  Copyright (c) 2014 Swipe. All rights reserved.
//

#import "ActivityOptionsVC.h"

@interface ActivityOptionsVC ()

@property (strong, nonatomic) NSIndexPath *selectedIndex;

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
        [self.tableView selectRowAtIndexPath:self.selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    else if( self.dataType == kPlacement )
        [self.tableView selectRowAtIndexPath:self.selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
    
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
    return self.revealViewController.navigationController.navigationBar.frame.size.height + 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if( self.dataType == kActivityType )
        return @"Activities";
    else
        return @"Device Placements";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.tableData[indexPath.row];
    
    return cell;
}

- (void)frontViewTapped
{
    [[self.revealViewController.frontViewController.view viewWithTag:1000] removeFromSuperview];
    [self.revealViewController revealToggle:self];
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if ( position == 2 ) {
        UIView *lockingView = [[UIView alloc] initWithFrame:revealController.frontViewController.view.frame];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frontViewTapped)];
        [lockingView addGestureRecognizer:tap];
        [lockingView setTag:1000];
        [revealController.frontViewController.view addSubview:lockingView];
    }
}

@end
