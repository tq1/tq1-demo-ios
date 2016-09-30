//
//  EventsTableViewController.m
//  TQ1Demo
//
//  Created by Taqtile Apps on 9/11/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "EventsTableViewController.h"
#import "EventInputTableViewCell.h"
#import <TQ1SDK/TQ1Analytics.h>

@interface EventsTableViewController ()

@end

@implementation EventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"EventInputTableViewCell" bundle:nil] forCellReuseIdentifier:
                                                                                                        @"EventInputId"];
}

#pragma mark UITableView delegate methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number;
    
    switch (section) {
        case 0:
            number = 4;
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

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0: {
            EventInputTableViewCell *inputCell = (EventInputTableViewCell *)[tableView dequeueReusableCellWithIdentifier:
                                                                                                        @"EventInputId"];
            if (inputCell == nil) {
                inputCell = [[EventInputTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                                                                                                        @"EventInputId"];
            }
            switch (indexPath.row) {
                case 0:
                    [inputCell.input setPlaceholder:@"event name"];
                    break;
                case 1:
                    [inputCell.input setPlaceholder:@"count"];
                    break;
                case 2:
                    [inputCell.input setPlaceholder:@"segmentation key"];
                    break;
                case 3:
                    [inputCell.input setPlaceholder:@"segmentation value"];
                    break;
                default:
                    break;
            }
            cell = inputCell;
            break;
        }
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"EventActionId"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:
                                                                                                        @"EventActionId"];
            }
            break;
        }
        default:
            cell = nil;
            break;
    }
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView retrieveInputAtIndexPath:(NSIndexPath *)indexPath
{
    EventInputTableViewCell *cell = (EventInputTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *text = [[cell.input text] stringByTrimmingCharactersInSet:[NSCharacterSet
                                                                                    whitespaceAndNewlineCharacterSet]];
    
    return text;
}

- (BOOL) isValidInputArray:(NSArray *)array
{
    return ![(NSString *)[array objectAtIndex:0] isEqualToString:@""]
    && [(NSString *)[array objectAtIndex:1] intValue] != 0
    && ![(NSString *)[array objectAtIndex:2] isEqualToString:@""]
    && ![(NSString *)[array objectAtIndex:3] isEqualToString:@""];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSIndexPath *nameIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *countIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath *keyIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath *valueIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        
        NSString *eventName = [self tableView:tableView retrieveInputAtIndexPath:nameIndexPath];
        NSString *eventCount = [self tableView:tableView retrieveInputAtIndexPath:countIndexPath];
        NSString *segmentationKey = [self tableView:tableView retrieveInputAtIndexPath:keyIndexPath];
        NSString *segmentationValue = [self tableView:tableView retrieveInputAtIndexPath:valueIndexPath];
        
        if ([self isValidInputArray:@[eventName, eventCount, segmentationKey, segmentationValue]]) {
            NSDictionary *segmentation = [NSDictionary dictionaryWithObject:segmentationValue forKey:segmentationKey];
            [[TQ1Analytics shared] recordEvent:eventName segmentation:segmentation count:[eventCount intValue]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Events" message:[NSString stringWithFormat:
                    @"Event \"%@\" sent to server", eventName] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    }
}


@end
