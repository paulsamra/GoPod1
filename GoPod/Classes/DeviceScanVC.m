//
//  DeviceScanVC.m
//  GoPod
//
//  Created by Ryan Khalili on 1/19/14.
//  Copyright (c) 2014 CSR PLC. All rights reserved.
//

#import "DeviceScanVC.h"
#import "BLEDevice.h"

@interface DeviceScanVC ()

@property (strong, nonatomic) NSMutableArray            *deviceList;
@property (strong, nonatomic) NSArray                   *foundDevices;

@property (strong, nonatomic) UIActivityIndicatorView   *scanningIndicator;
@property (strong, nonatomic) UIBarButtonItem           *scanButton;

@end

@implementation DeviceScanVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *titleImage = [UIImage imageNamed:kNavLogo];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:titleImage];
    
    self.scanningIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.scanningIndicator.hidesWhenStopped = YES;
    
    self.scanButton = [[UIBarButtonItem alloc] initWithTitle:@"Scan" style:UIBarButtonItemStyleDone target:self action:@selector(scanButtonPressed)];
    self.navigationItem.rightBarButtonItem = self.scanButton;
    
    self.deviceList = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanFinishedWithResults:)
                                                 name:kScanDone object:nil];
}

- (void)scanButtonPressed
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.scanningIndicator];
    [self.scanningIndicator startAnimating];
    
    [[AppHealthManager sharedManager] scanForDevices];
}

- (void)scanFinishedWithResults:(NSNotification *)notification
{
    self.foundDevices = notification.object;
    [self.deviceList removeAllObjects];
    for( BLEDevice *device in notification.object )
    {
        if( [device.type isEqualToString:kSensorPod] && [self.deviceScanType isEqualToString:kSensorPod] )
            [self.deviceList addObject:device];
        else if( [device.type isEqualToString:kHRM] && [self.deviceScanType isEqualToString:kHRM] )
            [self.deviceList addObject:device];
    }
    
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem = self.scanButton;
    [self.scanningIndicator stopAnimating];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( [self.deviceList count] )
        return [self.deviceList count];
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if( [self.deviceList count] == 0 )
    {
        cell.textLabel.text         = @"No Devices Found";
        cell.detailTextLabel.text   = @"";
        cell.selectionStyle         = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
    }
    
    else
    {
        BLEDevice *device           = [self.deviceList objectAtIndex:indexPath.row];
        cell.textLabel.text         = device.name;
        cell.detailTextLabel.text   = [NSString stringWithFormat:@"%@, %@", device.type, device.state];
        cell.selectionStyle         = UITableViewCellSelectionStyleDefault;
        cell.userInteractionEnabled = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [self.foundDevices indexOfObject:[self.deviceList objectAtIndex:indexPath.row]];
    [[AppHealthManager sharedManager] connectToDeviceAtIndex:index];
}

@end
