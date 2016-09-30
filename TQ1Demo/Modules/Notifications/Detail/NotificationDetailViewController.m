//
//  NotificationDetailViewController.m
//  TQ1Demo
//
//  Created by Taqtile on 8/24/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "NotificationDetailViewController.h"
#import "ContentViewController.h"
#import "ContentWebViewController.h"
#import <TQ1SDK/TQ1Inbox.h>
#import <TQ1SDK/TQ1Analytics.h>

#define DATE_FORMAT @"dd/MM/yyyy hh:mm aa"

@interface NotificationDetailViewController ()

@property NSArray *sectionTitles;
@property NSArray *sectionKeys;
@property NSArray *sectionButtons;
@property NSString *selectedContent;
@property NSString *selectedTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@end

@implementation NotificationDetailViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _sectionTitles = @[@"NOTIFICATION", @"", @""];
    
    _sectionKeys = @[@"Message", @"Date Sent", @"Date Opened", @"Status sent", @"Custom Action", @"Content Type", @"Content"];
    
    _sectionButtons = @[@"Open Notification Content", @"Send Custom Status"];
    
    [self populateTable];
}

- (void) populateTable
{
    _notification = [[TQ1Inbox shared] getInboxMessage:_notification.id ];
    if (!_notification.complete) {
        [[TQ1Inbox shared] retrieveCustomContent:_notification.id completion:^(BOOL success, TQ1InboxMessage *noty) {
            if (success) {
                _loadingView.hidden = true;
                [[TQ1Inbox shared] markAsRead: _notification.id];
                _notification = noty;
                [self.tableView reloadData];
            }
        }];
    }
    else {
        _loadingView.hidden = true;
        [[TQ1Inbox shared] markAsRead: _notification.id];
        [self.tableView reloadData];
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _sectionTitles[section];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTitles count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return [_sectionKeys count];
    }
    else {
        return 1;
    }
}

- (NSString *) formatTime:(NSInteger)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat: DATE_FORMAT];
    
    return [formatter stringFromDate:date];
    
}

- (NSString *) clipStringWithLength:(NSString*)text
{
    const int clipLength = 13;
    NSString *origString;
    
    if ([text length] > clipLength) {
        origString = [NSString stringWithFormat:@"%@...",[text substringToIndex:clipLength]];
        return origString;
    }
    else {
        return text;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"NotificationDetailTableViewCell";
    UITableViewCell *cell;
    NSString *text;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.textLabel setText:_sectionKeys[indexPath.row]];
        [cell.detailTextLabel setAdjustsFontSizeToFitWidth:true];
        
        switch (indexPath.row) {
                
            case 0:
                text = [self clipStringWithLength:_notification.alert];
                [cell.detailTextLabel setText:text];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
            case 1:
                [cell.detailTextLabel setText:[self formatTime:(NSInteger)_notification.scheduled]];
                break;
            case 2:
                [cell.detailTextLabel setText:[self formatTime:(NSInteger)_notification.timestamp]];
                break;
            case 3:
                text = [self clipStringWithLength:_notification.customSentStatus];
                [cell.detailTextLabel setText:text];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
            case 4:
                text = [self clipStringWithLength:_notification.customAction];
                [cell.detailTextLabel setText:text];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
            case 5:
                switch (_notification.type) {
                    case 0:
                        [cell.detailTextLabel setText:@"Push"];
                        break;
                    case 1:
                        [cell.detailTextLabel setText:@"HTML"];
                        break;
                    case 2:
                        [cell.detailTextLabel setText:@"Link"];
                        break;
                    case 3:
                        [cell.detailTextLabel setText:@"Tag"];
                        break;
                    default:
                        break;
                }
                break;
            case 6:
                if (_notification.type == TQ1InboxMessageTypeTag)
                    text = [self clipStringWithLength:@"<dictionary>"];
                else
                    text = [self clipStringWithLength:_notification.content];
                [cell.detailTextLabel setText:text];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
            default:
                break;
        }}
    else {
        NSString *identifierButton = @"blueButtonView";
        
        cell = [tableView dequeueReusableCellWithIdentifier:identifierButton forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierButton];
        }
        [cell.textLabel setText:_sectionButtons[indexPath.section - 1]];
    }
    
    return cell;
}

- (NSString *) stringFromDictionary:(NSDictionary *)dictionary
{
    NSString *string = @"{";

    for (NSString *key in dictionary) {
        string = [string stringByAppendingString:[NSString stringWithFormat:@"\n\t%@:%@", key, dictionary[key]]];
    }
    string = [string stringByAppendingString:@"\n}"];

    return string;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedTitle = _sectionKeys[indexPath.row];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                _selectedContent = _notification.alert;
                break;
            case 3:
                _selectedContent = _notification.customSentStatus;
                break;
            case 4:
                _selectedContent = _notification.customAction;
                break;
            case 6:
                if (_notification.type == TQ1InboxMessageTypeTag) {
                    _selectedContent = [self stringFromDictionary:_notification.content];
                } else {
                    _selectedContent = _notification.content;
                }
                break;
            default:
                break;
        }
        
        if (indexPath.row == 6 || indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4) {
            [self performSegueWithIdentifier:@"content-segue" sender:self];
        }
    } else if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        switch (_notification.type) {
            case TQ1InboxMessageTypeHtml:
            case TQ1InboxMessageTypeLink:
                [self performSegueWithIdentifier:@"show-content-web-segue" sender:self];
                break;
            case TQ1InboxMessageTypeTag:
                if ([_notification.content objectForKey:@"Settings"])
                    [self performSegueWithIdentifier:@"show-content-tag-segue" sender:self];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:true];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send custom status" message:@"" delegate:self
                                                                cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"content-segue"]) {
        ContentViewController *destViewController = (ContentViewController *) segue.destinationViewController;
        destViewController.titleText = _selectedTitle;
        destViewController.content = _selectedContent;
    } else if ([segue.identifier isEqualToString:@"show-content-web-segue"]) {
        ContentWebViewController *destinationViewController = (ContentWebViewController *) segue.destinationViewController;
        destinationViewController.notification = _notification;
    }
}

#pragma mark UIAlertViewDelegate methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *status = [[alertView textFieldAtIndex:0] text];
        status = [status stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (![status isEqualToString:@""]) {
            [[TQ1Analytics shared] updateStatus:_notification.id status:status completion:^(BOOL success) {
                if (success) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Custom Status" message:[NSString
                            stringWithFormat:@"Status \"%@\" sent to server", status] delegate:nil cancelButtonTitle:
                                                                                            @"OK"otherButtonTitles:nil];
                    [alert show];
                    [self populateTable];
                }
            }];
        }
    }
}

@end
