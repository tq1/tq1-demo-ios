//
//  AddCustomDataTableViewController.m
//  TQ1Demo
//
//  Created by Taqtile Apps on 9/9/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "AddCustomDataTableViewController.h"
#import "CustomDataKeyTableViewCell.h"

@interface AddCustomDataTableViewController ()

@end

@implementation AddCustomDataTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomDataKeyTableViewCell" bundle:nil] forCellReuseIdentifier:
                                                                                                @"CustomDataAddKeyId"];
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
    CustomDataKeyTableViewCell *keyCell;
    UITableViewCell *actionCell;
    
    switch (indexPath.section) {
        case 0:
            identifier = @"CustomDataAddKeyId";
            keyCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (keyCell == nil) {
                keyCell = [[CustomDataKeyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                            reuseIdentifier:identifier];
            }
            if (indexPath.row == 0) {
                [keyCell.txtKey setPlaceholder:@"new key"];
            } else {
                [keyCell.txtKey setPlaceholder:@"new value"];
            }
            return keyCell;
            break;
        case 1:
            identifier = @"CustomDataAddActionId";
            actionCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (actionCell == nil) {
                actionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                            reuseIdentifier:identifier];
            }
            return actionCell;
            break;
        default:
            return nil;
            break;
    }
}

- (void) tableView:(UITableView *)tableView clearInputAtIndexPath:(NSIndexPath *)indexPath
{
    CustomDataKeyTableViewCell *cell = (CustomDataKeyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    [cell.txtKey setText:@""];
}

- (NSString *) tableView:(UITableView *)tableView retrieveInputAtIndexPath:(NSIndexPath *)indexPath
{
    CustomDataKeyTableViewCell *cell = (CustomDataKeyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *text = [[cell.txtKey text] stringByTrimmingCharactersInSet:[NSCharacterSet
                                                                                    whitespaceAndNewlineCharacterSet]];
    
    return text;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSIndexPath *keyIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *valueIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        
        NSString *key = [self tableView:tableView retrieveInputAtIndexPath:keyIndexPath];
        NSString *value = [self tableView:tableView retrieveInputAtIndexPath:valueIndexPath];
        
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        if (![key isEqualToString:@""] && ![value isEqualToString:@""]) {
            [_customData addEntriesFromDictionary:@{key: value}];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Custom Data" message:[NSString stringWithFormat:
                                @"Key \"%@\" added", key] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            [self tableView:tableView clearInputAtIndexPath:keyIndexPath];
            [self tableView:tableView clearInputAtIndexPath:valueIndexPath];
        }
    }
}

@end
