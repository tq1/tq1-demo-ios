//
//  CustomDataTableViewController.m
//  TQ1Demo
//
//  Created by Taqtile Apps on 9/4/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "CustomDataTableViewController.h"
#import "AddCustomDataTableViewController.h"
#import "RemoveCustomDataTableViewController.h"
#import <TQ1SDK/TQ1Analytics.h>

@interface CustomDataTableViewController ()

@property NSArray *sectionTitles;

@end

@implementation CustomDataTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _sectionTitles = @[@"CUSTOM DATA", @""];
    _customData = [[NSMutableDictionary alloc] initWithDictionary:@{@"key1": @"value1",
                                                                    @"key2": @"value2",
                                                                    @"key3": @"value3"}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows;
    
    switch (section) {
        case 0:
            numberOfRows = [[_customData allKeys] count] + 1;
            break;
        case 1:
            numberOfRows = 1;
            break;
        default:
            numberOfRows = 0;
            break;
    }
    
    return numberOfRows;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionTitles[section];
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *identifier;
    
    switch (indexPath.section) {
        case 0: {
            NSArray *sectionKeys = [_customData allKeys];
            NSArray *sectionValues = [_customData allValues];

            if (indexPath.row == [sectionKeys count]) {
                identifier = @"CustomDataListAddId";
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                }
            } else {
                identifier = @"CustomDataListId";
                cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                }
                [cell.textLabel setText:sectionKeys[indexPath.row]];
                [cell.detailTextLabel setText:sectionValues[indexPath.row]];
            }
            break;
        }
        case 1: {
            identifier = @"CustomDataListSendId";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            break;
        }
        default:
            cell = nil;
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == [[_customData allKeys] count]) {
                [self performSegueWithIdentifier:@"add-custom-data-segue" sender:self];
            } else {
                [self performSegueWithIdentifier:@"remove-custom-data-segue" sender:self];
            }
            break;
        }
        case 1: {
            [[TQ1Analytics shared] addCustomData:_customData keysToIgnore:@[] completion:^(BOOL success) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Custom Data" message:@"Pairs sent to server"
                                                            delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }];
            break;
        }
        default:
            break;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqual:@"remove-custom-data-segue"]) {
        RemoveCustomDataTableViewController *ctrl = (RemoveCustomDataTableViewController *)segue.destinationViewController;
        ctrl.customData = _customData;
        ctrl.key = [_customData allKeys][indexPath.row];
    } else if ([segue.identifier isEqual:@"add-custom-data-segue"]) {
        AddCustomDataTableViewController *ctrl = (AddCustomDataTableViewController *)segue.destinationViewController;
        ctrl.customData = _customData;
    }
}

@end
