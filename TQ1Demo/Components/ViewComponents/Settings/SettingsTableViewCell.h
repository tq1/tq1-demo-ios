//
//  SettingsTableViewCell.h
//  TQ1Demo
//
//  Created by Taqtile Apps on 9/10/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingsTableViewCell;

@protocol SettingsTableViewCellDelegate <NSObject>

- (void) cell:(SettingsTableViewCell *)cell didChangeState:(BOOL)state;

@end

@interface SettingsTableViewCell : UITableViewCell

@property id<SettingsTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *state;

@end
