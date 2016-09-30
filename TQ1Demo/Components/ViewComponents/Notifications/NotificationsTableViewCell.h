//
//  NotificationsTableViewCell.h
//  TQ1Demo
//
//  Created by Taqtile Apps on 8/24/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsTableViewCell : UITableViewCell

- (void) setTime:(NSInteger)time;
- (void) setAlert:(NSString *)alert;
- (void) setRead:(BOOL)read;

@end
