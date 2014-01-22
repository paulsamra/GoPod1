//
//  DevicesVC.m
//  GoPod
//
//  Created by Ryan Khalili on 1/17/14.
//  Copyright (c) 2014 CSR PLC. All rights reserved.
//

#import "PairedDevicesVC.h"
#import "BLEDevice.h"
#import "DeviceScanVC.h"

static NSString *pairCellID   = @"pairCell";
static NSString *deviceCellID = @"deviceCell";
static NSString *spSegue      = @"scanSP";
static NSString *hrmSegue     = @"scanHRM";

@interface PairedDevicesVC ()

@property (strong, nonatomic) NSArray *deviceArray;

@end

@implementation PairedDevicesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *titleImage = [UIImage imageNamed:kNavLogo];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:titleImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanFinishedWithResults:)
                                                 name:kScanDone object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)scanFinishedWithResults:(NSNotification *)notification
{
    self.deviceArray = notification.object;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DeviceScanVC *dest = segue.destinationViewController;
    if( [segue.identifier isEqualToString:spSegue] )
        dest.deviceScanType = kSensorPod;
    else if( [segue.identifier isEqualToString:hrmSegue] )
        dest.deviceScanType = kHRM;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = nil;
    
    if( indexPath.row == 0 )
        cellID = pairCellID;
    else
        cellID = deviceCellID;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if( indexPath.section == 0 )
    {
        if( indexPath.row == 0 )
        {
            cell.textLabel.text = @"Pair SensorPod";
            UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
            button.userInteractionEnabled = NO;
            cell.accessoryView = button;
            cell.imageView.image = [UIImage imageNamed:kSPicon];
        }
        
        else if( indexPath.row == 1 )
        {
            BLEDevice *connectedDevice;
            for( BLEDevice *device in self.deviceArray )
            {
                if( [device.state isEqualToString:kConnected] && [device.type isEqualToString:kSensorPod] )
                {
                    connectedDevice = device;
                }
            }
            
            if( connectedDevice )
            {
                cell.textLabel.text            = connectedDevice.name;
                cell.textLabel.textColor       = [UIColor blackColor];
                cell.detailTextLabel.text      = kConnected;
                cell.detailTextLabel.textColor = [UIColor blackColor];
                //self.batteryView.image = [self getBatteryImage];
                //[cell.contentView addSubview:self.batteryView];
                //[cell.contentView addSubview:self.batteryLabel];
            }
            
            else
            {
                cell.textLabel.text       = @"No SensorPod Connected";
                cell.textLabel.textColor  = [UIColor grayColor];
                cell.detailTextLabel.text = @"";
                //[self.batteryView removeFromSuperview];
                //[self.batteryLabel removeFromSuperview];
            }
            
            cell.userInteractionEnabled = NO;
        }
    }
    
    else if( indexPath.section == 1 )
    {
        if( indexPath.row == 0 )
        {
            cell.textLabel.text = @"Pair Heart Rate Monitor";
            UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
            button.userInteractionEnabled = NO;
            cell.accessoryView = button;
            cell.imageView.image = [UIImage imageNamed:kHRMicon];
        }
        
        else if( indexPath.row == 1 )
        {
            BLEDevice *connectedDevice;
            for( BLEDevice *device in self.deviceArray )
                if( [device.state isEqualToString:kConnected] && [device.type isEqualToString:kHRM] )
                    connectedDevice = device;
            
            if( connectedDevice )
            {
                cell.textLabel.text            = connectedDevice.name;
                cell.textLabel.textColor       = [UIColor blackColor];
                cell.detailTextLabel.text      = kConnected;
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }
            
            else
            {
                cell.textLabel.text       = @"No Heart Rate Monitor Connected";
                cell.textLabel.textColor  = [UIColor grayColor];
                cell.detailTextLabel.text = @"";
            }
            
            cell.userInteractionEnabled = NO;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == 0 )
        [self performSegueWithIdentifier:spSegue sender:nil];
    if( indexPath.section == 1 )
        [self performSegueWithIdentifier:hrmSegue sender:nil];
}

@end
