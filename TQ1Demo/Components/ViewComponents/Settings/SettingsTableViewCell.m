//
//  SettingsTableViewCell.m
//  TQ1Demo
//
//  Created by Taqtile Apps on 9/10/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    return self;
}

- (IBAction) valueChanged:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didChangeState:)]) {
        [self.delegate cell:self didChangeState:_state.on];
    }
}

@end
