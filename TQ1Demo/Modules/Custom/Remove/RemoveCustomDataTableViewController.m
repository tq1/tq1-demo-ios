//
//  RemoveCustomDataTableViewController.m
//  TQ1Demo
//
//  Created by Taqtile Apps on 9/9/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "RemoveCustomDataTableViewController.h"
#import "CustomDataKeyTableViewCell.h"

@interface RemoveCustomDataTableViewController ()

@end

@implementation RemoveCustomDataTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomDataKeyTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"CustomDataRemoveKeyId"];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number;
    
    switch (section) {
        case 0:
            number = 2;
            break;
        case 1:
            number = 1;
            break;
        default:
            number = 0;
            break;
    }
    
    return number;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0: {
            identifier = @"CustomDataRemoveKeyId";
            CustomDataKeyTableViewCell *keyCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (keyCell == nil) {
                keyCell = [[CustomDataKeyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                            reuseIdentifier:identifier];
            }
            if (indexPath.row == 0) {
                [keyCell.txtKey setText:_key];
            } else {
                [keyCell.txtKey setText:[_customData objectForKey:_key]];
            }
            [keyCell.txtKey setEnabled:false];
            cell = keyCell;

            break;
        }
        case 1: {
            identifier = @"CustomDataRemoveActionId";
            UITableViewCell *actionCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (actionCell == nil) {
                actionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier];
            }
            cell = actionCell;

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
    if (indexPath.section == 1) {
        [_customData removeObjectForKey:_key];
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Custom Data" message:[NSString stringWithFormat:
                            @"Key \"%@\" removed", _key] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
