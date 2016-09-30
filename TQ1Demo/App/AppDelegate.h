//
//  AppDelegate.h
//  TQ1Demo
//
//  Created by Taqtile on 8/20/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TQ1SDK/TQ1.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, TQ1Delegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property UIStoryboard *storyboard;

@end