//
//  AppDelegate.m
//  TQ1Demo
//
//  Created by Taqtile on 8/20/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "TQ1Geotrigger.h"
#import "TQGManager.h"
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import "UIApplication+SimulatorRemoteNotifications.h"
#import <TQ1SDK/TQ1Inbox.h>
#import "NotificationDetailViewController.h"
#import "HomeViewController.h"
#import <HockeySDK/HockeySDK.h>

@interface AppDelegate ()

@property TQ1InboxMessage *notification;
@property CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //HockeyApp SDK init
    [[TQ1 shared] startWithKey:TQ1_APP_KEY andEnvironment:Production];
    [[TQ1 shared] trackRemoteNofitications:self];
    [[TQ1Geotrigger shared] setManager:[[TQGManager alloc] init]];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // You don't necessarily have to ask for the location authorization, it is just used if you wish to have more control over the geolocation service usage, like in the following example
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestAlwaysAuthorization];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL geoEnabled = [defaults boolForKey:@"Geonotifications"];
    if ([defaults objectForKey:@"Geonotifications"] == nil)
        geoEnabled = true;
    
    if (geoEnabled && [self isLocationAuthorized])
        [[TQ1Geotrigger shared] startGeotriggerService];
    else
        [[TQ1Geotrigger shared] stopGeotriggerService];
    
    [application listenForRemoteNotifications];
    
    _storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];

    return YES;
}

- (BOOL) isLocationAuthorized
{
    return [CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] !=
                                                                                            kCLAuthorizationStatusDenied;
}


- (void) handleBackgroundPushNotification:(NSDictionary *)userInfo pushId:(NSString *)pushId
{
    // Background - app isn`t beign used, but it`s open on Iphone process
    UIApplicationState appState = [UIApplication sharedApplication].applicationState;
    _notification = [[TQ1Inbox shared] getInboxMessage:pushId];
    [self formNotification:_notification];
    [self redirectNotification:_notification];
}

- (void) formNotification:(TQ1InboxMessage *)notification
{
    if (!notification.complete) {
        [[TQ1Inbox shared] retrieveCustomContent:notification.id completion:nil];
    }
}

- (void) handleForegroundPushNotification:(NSDictionary *)userInfo pushId:(NSString *)pushId
{
    // Foreground - app isn`t beign used, but it`s open on Iphone process
    _notification = [[TQ1Inbox shared] getInboxMessage:pushId];
    [self formNotification:_notification];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Notification" message:_notification.alert
                                            delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Open", nil];
    [alert show];
}

- (void) handleCustomActionWithIdentifier:(NSString *)identifier pushId:(NSString *)pushId
{

}

#pragma mark UIAlertViewDelegate methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self redirectNotification:_notification];
    }
}

- (void) redirectNotification:(TQ1InboxMessage *)notification
{
    NotificationDetailViewController *ctrl = [_storyboard instantiateViewControllerWithIdentifier:
                                                                                            @"NotificationDetailSceneId"];
    HomeViewController *root = [_storyboard instantiateViewControllerWithIdentifier:@"HomeSceneId"];
    
    UINavigationController *navController = (UINavigationController *)_window.rootViewController;
    [navController setViewControllers:@[root]];
    [(NotificationDetailViewController *)ctrl setNotification:notification];
    [navController pushViewController:ctrl animated:YES];
}

- (void) applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void) applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void) applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end