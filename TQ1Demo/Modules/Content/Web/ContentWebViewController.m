//
//  ContentWebViewController.m
//  TQ1Demo
//
//  Created by Taqtile Apps on 9/8/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "ContentWebViewController.h"

@interface ContentWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *vwWeb;

@end

@implementation ContentWebViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    switch (_notification.type) {
        case TQ1InboxMessageTypeLink:
            [_vwWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_notification.content]]];
            break;
        case TQ1InboxMessageTypeHtml:
            [_vwWeb loadHTMLString:_notification.content baseURL:nil];
            break;
        default:
            break;
    }
}

@end
