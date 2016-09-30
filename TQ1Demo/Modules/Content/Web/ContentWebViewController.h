//
//  ContentWebViewController.h
//  TQ1Demo
//
//  Created by Taqtile Apps on 9/8/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TQ1SDK/TQ1Inbox.h>

@interface ContentWebViewController : UIViewController <UIWebViewDelegate>

@property TQ1InboxMessage *notification;

@end
