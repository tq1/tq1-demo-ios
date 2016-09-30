//
//  NotificationsViewController.m
//  TQ1Demo
//
//  Created by Taqtile Apps on 8/24/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationDetailViewController.h"
#import "NotificationsTableViewCell.h"
#import <TQ1SDK/TQ1Inbox.h>


@interface NotificationsViewController ()

@property NSMutableArray *notifications;
@property TQ1InboxMessage *selectedMessage;

@end

@implementation NotificationsViewController

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

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_notifications count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"NotificationsTableViewCell";

    NotificationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[NotificationsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    TQ1InboxMessage *notification = _notifications[indexPath.row];
    
    [cell setAlert:notification.alert];
    [cell setTime:notification.timestamp];
    
    if (notification.status == TQ1InboxMessageStatusRead) {
        [cell setRead:true];
    } else {
        [cell setRead:false];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedMessage = _notifications[indexPath.row];
    [self performSegueWithIdentifier:@"notification-detail-segue" sender: self];
}

- (void) populateTable {
    
    _notifications = [[[TQ1Inbox shared] getInboxMessages:TQ1InboxMessageStatusRead] mutableCopy];
    [self.tableView registerNib:[UINib nibWithNibName:@"NotificationsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NotificationsTableViewCell"];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NotificationDetailViewController *destViewController = (NotificationDetailViewController *) segue.destinationViewController;
    destViewController.notification = _selectedMessage;
}

@end
