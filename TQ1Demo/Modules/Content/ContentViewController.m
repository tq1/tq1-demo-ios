//
//  ContentViewController.m
//  TQ1Demo
//
//  Created by Taqtile on 8/27/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *txtContent;

@end

@implementation ContentViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = _titleText;
    _txtContent.text = _content;
    
}

@end
