//
//  TGManagerViewController.m
//  TQ1Demo
//
//  Created by Taqtile on 8/25/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "TQGManager.h"
#import "Constants.h"

@implementation TQGManager

- (void) configure:(void (^)(void))completion
{
    [[TQGeoTracker sharedInstance] configure:TQG_APP_KEY triggerMode:TriggerModes.Both
                                                                                environment:TQEnvironments.Production];
    [[TQGeoTracker sharedInstance] setTriggerDelegate:self];
    completion();
}

- (void) start
{
    [[TQGeoTracker sharedInstance] start];
}

- (void) stop
{
    [[TQGeoTracker sharedInstance] stop];
}

- (void) resume
{
    [[TQGeoTracker sharedInstance] start];
}

- (void) pause
{
    [[TQGeoTracker sharedInstance] stop];
}

- (NSString *) getDeviceId
{
    return [[TQGeoTracker sharedInstance] getDeviceId];
}

- (void) TQGeoTrackerOnFenceTriggered:(TQGeoTracker *)tqGeoTracker trigger:(TQTrigger *)trigger
{
    return;
}

- (void) TQGeoTrackerOnFenceTriggered:(TQGeoTracker *)tqGeoTracker fenceName:(NSString *)fenceName
                                                                    fenceId:(NSString *)fenceId type:(NSString *)type
{
    [[TQGeoTracker sharedInstance] log:[NSString stringWithFormat:
                                    @"OnFenceTriggered - fenceName: %@ fenceId: %@ type: %@", fenceName, fenceId, type]];
    
    //Send local notification
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [[NSDate alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"fenceName: %@ fenceId: %@ type: %@", fenceName, fenceId, type];
    [[UIApplication sharedApplication] scheduleLocalNotification: notification];
}

@end
