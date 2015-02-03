//
//  DownloadRemoteViewController.m
//  NewTvuoo
//
//  Created by xubo on 11/11 Tuesday.
//  Copyright (c) 2014 wap3. All rights reserved.
//
#import "Singleton.h"
#import "DownloadRemoteViewController.h"
#import "CommonBtn.h"
#import "DEFINE.h"

@interface DownloadRemoteViewController ()

@end

@implementation DownloadRemoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* topIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
    topIv.backgroundColor = blueColor;
    [self.view addSubview:topIv];
    [topIv release];
    
    ReturnBtn* goBackBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
    goBackBtn.center = CGPointMake(40, topIv.center.y);
    [goBackBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goBackBtn];
    [goBackBtn release];
    
    UILabel* topTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    topTitleLabel.text = @"智能遥控免费下载";
    topTitleLabel.textAlignment = NSTextAlignmentCenter;
    topTitleLabel.textColor = [UIColor whiteColor];
    topTitleLabel.center = topIv.center;
    [self.view addSubview:topTitleLabel];
    [topTitleLabel release];
    
    UIImageView* yaokongIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xzyk.png"]];
    yaokongIv.frame = CGRectMake(25, 160, 270, 110);
//    yaokongIv.center = CGPointMake(self.view.center.x, 200);
    [self.view addSubview:yaokongIv];
    [yaokongIv release];
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 270, 50)];
    label1.center = CGPointMake(self.view.center.x-135, yaokongIv.center.y+120);
    label1.textColor = blueColor;
    label1.text = @"功能最强大的手机遥控";
    label1.font = [UIFont fontWithName:@"Courier New" size:26];
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    [label1 release];

    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    label2.numberOfLines = 2;
    label2.text = @"最强大的免费手机智能遥控， 空调、电视、热水器全部搞定";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.center = CGPointMake(self.view.center.x-135, label1.center.y+30);
    [label2 sizeToFit];
    label2.textColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1];
    [self.view addSubview:label2];
    [label2 release];
    
    
    UIButton* installBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [installBtn addTarget:self action:@selector(install) forControlEvents:UIControlEventTouchUpInside];
    installBtn.frame = CGRectMake(60, 450, 200, 40);
    installBtn.layer.borderColor = [blueColor CGColor];
    installBtn.layer.borderWidth = 1.0;
    installBtn.layer.cornerRadius = 8.0;
    [installBtn setTitle:@"安装厅游遥控" forState:UIControlStateNormal];
    [installBtn setTitleColor:blueColor forState:UIControlStateNormal];
//    installBtn.titleLabel.textColor
    [self.view addSubview:installBtn];
}

- (void) install
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"暂无" message:@"该功能正在开发，敬请期待!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Singleton getSingle].myBreakDownDelegate = self;
}

#pragma callback 连接异常断开了
- (void) disconnectedWithTv
{
    //    int iP = [ip intValue];
    //    const char* disConnIp = parseIp(iP);
    //    NSString* str = [NSString stringWithFormat:@"%s", disConnIp];
    if([[Singleton getSingle].tvArray count] != 0)
    {
        [Singleton getSingle].conn_statue = 1;
    }
    else
    {
        [Singleton getSingle].conn_statue = 0;
    }
    
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"网络异常,手机与电视连接断开,请您重新连接!";
    [self.view addSubview:hud];
    [self.view bringSubviewToFront:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:3];
    [hud release];
    return;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)returnBack
{
    [self.navigationController popViewControllerAnimated:NO];
}

@end
