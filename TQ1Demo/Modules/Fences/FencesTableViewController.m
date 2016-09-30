//
//  FencesTableViewController.m
//  TQ1Demo
//
//  Created by Taqtile Apps on 9/11/15.
//  Copyright (c) 2015 Taqtile Apps. All rights reserved.
//

#import "FencesTableViewController.h"

@interface FencesTableViewController ()

@end

@implementation FencesTableViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark UITableView delegate methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number;
    
    switch (section) {
        case 0:
            number = 2;
            break;
        default:
            number = 0;
            break;
    }
    
    return number;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    
    switch (section) {
        case 0:
            title = @"GEO FENCES";
            break;
        default:
            title = @"";
            break;
    }
    
    return title;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"FenceActionId" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FenceActionId"];
            }
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"Map"];
                    break;
                case 1:
                    [cell.textLabel setText:@"Log/Debug"];
                    break;
            }
            break;
        default:
            cell = nil;
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [self performSegueWithIdentifier:@"show-map-segue" sender:self];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"show-logs-segue" sender:self];
                    break;
            }
            break;
        default:
            break;
    }
}

@end
