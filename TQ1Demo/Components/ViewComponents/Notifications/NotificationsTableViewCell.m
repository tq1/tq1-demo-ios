//
//  NotificationsTableViewCell.m
//  TQ1Demo
//
//  Created by Taqtile Apps on 8/24/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "NotificationsTableViewCell.h"
#define DATE_FORMAT @"dd/MM/yyyy HH:mm aa"
#define LBL_TIME_FONT_SIZE 15.0

@interface NotificationsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *lblAlert;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end

@implementation NotificationsTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) setAlert:(NSString *)alert
{
    [_lblAlert setText:alert];
}

- (void) setTime:(NSInteger)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:DATE_FORMAT];
    [_lblTime setText:[formatter stringFromDate:date]];
}

- (void) setRead:(BOOL)read
{
    if (read) {
        [_lblTime setFont:[UIFont systemFontOfSize:LBL_TIME_FONT_SIZE]];
    } else {
        [_lblTime setFont:[UIFont boldSystemFontOfSize:LBL_TIME_FONT_SIZE]];
    }
}

@end
