//
//  ViewController.m
//  ProjectMapDS
//
//  Created by Panisara Intoe on 1/6/2558 BE.
//  Copyright (c) 2558 Panisara Intoe. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"";
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)InfoView:(id)sender
{
    UIAlertView *alv = [[UIAlertView alloc]
                        initWithTitle:@"KU Senior Project"
                        message:@"dev. by Panisara Intoe"
                        delegate:self
                        cancelButtonTitle:@"Done"
                        otherButtonTitles: nil];
    [alv show];
}

- (IBAction)OnlinePage:(id)sender
{
    OnlinePageTableViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"OnlinePageTableViewController"];
    [self.navigationController pushViewController:next animated:YES];
}

- (IBAction)OfflinePage:(id)sender
{
    OfflinePageTableViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"OfflinePageTableViewController"];
    [self.navigationController pushViewController:next animated:YES];
}

- (IBAction)FavoritePage:(id)sender
{
    FavoritePageTableViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritePageTableViewController"];
    [self.navigationController pushViewController:next animated:YES];
}

- (IBAction)SearchPage:(id)sender
{
    SearchPageViewController *next = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchPageViewController"];
    [self.navigationController pushViewController:next animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
            
        default:
            break;
    }
}

@end
