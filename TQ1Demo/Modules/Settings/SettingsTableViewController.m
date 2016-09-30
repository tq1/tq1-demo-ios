//
//  SettingsTableViewController.m
//  TQ1Demo
//
//  Created by Taqtile Apps on 9/10/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SettingsTableViewCell.h"
#import <TQ1SDK/TQ1Geotrigger.h>
#import <CoreLocation/CoreLocation.h>

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingsTableViewCell" bundle:nil] forCellReuseIdentifier:
                                                                                                    @"SettingsOptionId"];
}

- (BOOL) retrieveUserDefaultsForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL value = [defaults boolForKey:key];
    
    if ([defaults objectForKey:key] == nil)
        value = true;

    return value;
}

- (void) updateUserDefaultsValue:(BOOL)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setBool:value forKey:key];
}

- (BOOL) isLocationAuthorized
{
    return [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] !=
                                                                                            kCLAuthorizationStatusDenied;
}

#pragma mark UITableView delegate methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number;
    
    switch (section) {
        case 0:
            number = 2;
            break;
        default:
            number = 0;
            break;
    }
    
    return number;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"SETTINGS";
            break;
        default:
            title = @"";
            break;
    }
    
    return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *title;
    
    switch (section) {
        case 0:
            title = [NSString stringWithFormat:@"%@%@", @"Turn settings off if you do not want to receive notifications",
                                @"based on your location or even if you don't want to receive any notifications at all"];
            break;
        default:
            title = @"";
            break;
    }
    
    return title;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0: {
            NSString *identifier = @"SettingsOptionId";
            SettingsTableViewCell *actionCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (actionCell == nil) {
                actionCell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                                                                                                            identifier];
            }
            if (indexPath.row == 0) {
                [actionCell.label setText:@"Geolocation"];
                if (![self isLocationAuthorized]) {
                    [actionCell.state setOn:false];
                    [actionCell.state setEnabled:false];
                } else {
                    [actionCell.state setOn:[self retrieveUserDefaultsForKey:@"Geonotifications"]];
                    [actionCell.state setEnabled:true];
                }
            } else {
                [actionCell.label setText:@"Push Notification"];
                [actionCell.state setOn:false];
                [actionCell.state setEnabled:false];
            }
            [actionCell setDelegate:self];
            cell = actionCell;
            break;
        }
        default:
            cell = nil;
            break;
    }
    
    return cell;
}

#pragma mark SettingsTableViewCellDelegate methods

- (void) cell:(SettingsTableViewCell *)cell didChangeState:(BOOL)state
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (indexPath.row) {
        case 0:
            [self updateUserDefaultsValue:state forKey:@"Geonotifications"];
            if (state == true) {
                [[TQ1Geotrigger shared] startGeotriggerService];
            } else {
                [[TQ1Geotrigger shared] stopGeotriggerService];
            }
            break;
        default:
            break;
    }
}

@end
