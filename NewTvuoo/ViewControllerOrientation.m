//
//  ViewControllerOrientationViewController.m
//  NewTvuoo
//
//  Created by xubo on 9/5 星期五.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import "ViewControllerOrientation.h"

@interface ViewControllerOrientation()

@end

@implementation ViewControllerOrientation
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSUInteger)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}
- (BOOL) shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

@end
