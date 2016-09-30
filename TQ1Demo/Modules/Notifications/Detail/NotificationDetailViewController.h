//
//  NotificationDetailViewController.h
//  TQ1Demo
//
//  Created by Taqtile on 8/24/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TQ1SDK/TQ1Inbox.h>

@interface NotificationDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,
                                                                                                    UIAlertViewDelegate>

@property TQ1InboxMessage *notification;

@end