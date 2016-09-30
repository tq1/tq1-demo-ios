//
//  TGManagerViewController.h
//  TQ1Demo
//
//  Created by Taqtile on 8/25/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UILocalNotification.h>
#import <UIKit/UIApplication.h>
#import "TQ1Geotrigger.h"
#import "TQGeolocationSDK-Swift.h"

@interface TQGManager: NSObject <TQGeoTriggerDelegate, TQGeoTrackerDelegate>

@end