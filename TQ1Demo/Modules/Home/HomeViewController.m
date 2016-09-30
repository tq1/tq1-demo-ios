//
//  RootViewController.m
//  TQ1Demo
//
//  Created by Taqtile Apps on 8/21/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "HomeViewController.h"
#import <TQ1SDK/TQ1Inbox.h>
#import "TQGManager.h"
#import "Constants.h"

@interface HomeViewController ()

@property NSArray *sectionKeys;
@property NSArray *sectionTitles;
@property NSArray *sectionValues;
@property NSString *appKey;
@property NSString *deviceId;
@property NSString *geoTrackingId;
@property NSString *appVersion;
@property NSString *sdkVersion;
@property NSInteger qtyNotifications;

@end

@implementation HomeViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    // Configure View Controller
    [self setRefreshControl:refreshControl];
    
    [self populateTable];
}

- (void) refresh:(id)sender
{
    [self populateTable];
    [self.tableView reloadData];
    [(UIRefreshControl *)sender endRefreshing];
}

#pragma mark - Table view data source

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionTitles[section];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionKeys count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sectionKeys[section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"HomeTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    if (indexPath.section == 0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    } else if (indexPath.section == 1) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [cell.textLabel setText:_sectionKeys[indexPath.section][indexPath.row]];
    [cell.detailTextLabel setText:_sectionValues[indexPath.section][indexPath.row]];
    [cell.detailTextLabel setAdjustsFontSizeToFitWidth:true];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:@"notifications-list-segue" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"edit-settings-segue" sender:self];
                break;
            case 2:
                [self performSegueWithIdentifier:@"custom-data-segue" sender:self];
                break;
            case 3:
                [self performSegueWithIdentifier:@"add-event-segue" sender:self];
                break;
            case 4:
                [self performSegueWithIdentifier:@"show-fences-segue" sender:self];
                break;
        }
    }
}

- (void) populateTable {
    
    TQGManager *manager = [[TQGManager alloc] init];
    
    _sectionTitles = @[@"INFO", @"ACTIONS"];
    _sectionKeys = @[@[@"App Key", @"Device ID", @"GeoTracking ID", @"App Version", @"SDK Version"],
                     @[@"View Notifications", @"Settings", @"Custom Data", @"Events", @"Geo Fences"]];
    
    _appKey = TQ1_APP_KEY;
    _deviceId = [TQ1 udid];
    _geoTrackingId = manager.getDeviceId;
    _appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _sdkVersion = SDK_VERSION;
    _qtyNotifications = [[TQ1Inbox shared] getInboxMessagesCount:TQ1InboxMessageStatusAll];
    
    _sectionValues = @[@[_appKey, _deviceId, _geoTrackingId, _appVersion, _sdkVersion],
                       @[[NSString stringWithFormat:@"%ld", (long)_qtyNotifications], @"", @"", @"", @""]];
}

@end