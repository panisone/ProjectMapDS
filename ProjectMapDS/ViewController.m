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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (IBAction)nextOnlinePage:(id)sender {
}

- (IBAction)nextOfflinePage:(id)sender {
}

- (IBAction)nextFavoritePage:(id)sender {
}
*/
- (IBAction)infoView:(id)sender
{
    UIAlertView *alv = [[UIAlertView alloc]
                        initWithTitle:@"INFO View"
                        message:@"dev. by Panisara Intoe"
                        delegate:self
                        cancelButtonTitle:@"Done"
                        otherButtonTitles:nil];
    [alv show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
}


@end
