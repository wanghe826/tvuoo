//
//  ContactViewController.m
//  NewTvuoo
//
//  Created by xubo on 11/13 Thursday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "ContactViewController.h"
#import "DEFINE.h"
#import "CommonBtn.h"
#import "MouseControlViewController.h"
#import "HongbaijiViewController.h"
#import "JiejiViewController.h"
#import "PSPViewController.h"
#import "AllUrl.h"
#import "ParseJson.h"
#import "MBProgressHUD.h"
@interface ContactViewController ()

@end

@implementation ContactViewController

- (void) returnBack
{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* topIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 50)];
    topIv.backgroundColor = blueColor;
    [self.view addSubview:topIv];
    [topIv release];
    
    
    ReturnBtn* retBtn = [[ReturnBtn alloc] initWithFrame:CGRectMake(10, 30, 30, 30)];
    [retBtn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retBtn];
    
    UILabel* topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    topLabel.center = CGPointMake(self.view.center.x, retBtn.center.y);
    topLabel.text = @"联系我们";
    topLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:topLabel];
    [topLabel release];
    [retBtn release];
    
    UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 80, 80, 40)];
    label1.text = @"内容合作";
    [self.view addSubview:label1];
    UIImageView* line1 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 120, 280, 2)];
    line1.backgroundColor = blueColor;
    [self.view addSubview:line1];
    [label1 release];
    [line1 release];
    
    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, 250, 40)];
    label2.text = @"游戏、应用合作请于下方QQ联系";
    label2.textColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1];
    [self.view addSubview:label2];
    [label2 release];
    
    UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(30, 145, 250, 40)];
    label3.text = @"陈生QQ:1103895268";
    label3.textColor = blueColor;
    [self.view addSubview:label3];
    [label3 release];
    
    
    UILabel* label4 = [[UILabel alloc] initWithFrame:CGRectMake(30, 210, 80, 40)];
    label4.text = @"硬件合作";
    [self.view addSubview:label4];
    [label4 release];
    
    UIImageView* line2 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 250, 280, 2)];
    line2.backgroundColor = blueColor;
    [self.view addSubview:line2];
    [line2 release];
    
    UILabel* label5 = [[UILabel alloc] initWithFrame:CGRectMake(30, 260, 280, 90)];
    label5.text = @"欢迎各大电视、机顶盒与厅游进行预装、定制等各种合作。请你将大致需求发送到下方通过邮箱发给我们，我们将尽快安排专人与您联系";
    label5.numberOfLines = 0;
    label5.textColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1];
    [self.view addSubview:label5];
    [label5 release];
    
    UILabel* label6 = [[UILabel alloc] initWithFrame:CGRectMake(30, 345, 280, 30)];
    label6.text = @"邮箱:bd@tvuoo.com";
    label6.textColor = blueColor;
    [self.view addSubview:label6];
    [label6 release];
    
    UILabel* label7 = [[UILabel alloc] initWithFrame:CGRectMake(30, 400, 280, 40)];
    label7.text = @"厅游客服";
    [self.view addSubview:label7];
    [label7 release];
    
    UIImageView* line3 = [[UIImageView alloc] initWithFrame:CGRectMake(30, 440, 510, 2)];
    line3.backgroundColor = blueColor;
    [self.view addSubview:line3];
    [line3 release];
    
    UILabel* label8 = [[UILabel alloc] initWithFrame:CGRectMake(30, 440, 280, 60)];
    label8.numberOfLines = 2;
    label8.text = @"您在使用厅游过程中有任何疑问请添加厅游客服微信或Q群";
    label8.textColor = [UIColor colorWithRed:156.0/255.0 green:156.0/255.0 blue:156.0/255.0 alpha:1];
    [self.view addSubview:label8];
    [label8 release];
    
    UILabel* label9 = [[UILabel alloc] initWithFrame:CGRectMake(30, 490, 280, 30)];
    label9.textColor = blueColor;
    label9.text = @"微信号：tvuoozs或厅游助手";
    [self.view addSubview:label9];
    [label9 release];
    
    UILabel* label0 = [[UILabel alloc] initWithFrame:CGRectMake(30, 510, 280, 30)];
    label0.text = @"QQ群: 235404221";
    label0.textColor = blueColor;
    [self.view addSubview:label0];
    [label0 release];
    // Do any additional setup after loading the view from its nib.
    
    NSNotificationCenter* notifi = [NSNotificationCenter defaultCenter];
    [notifi addObserver:self selector:@selector(gotoHandle:) name:@"gameActed" object:nil];
}

- (void) gotoHandle:(NSNotification*)notification
{
    NSDictionary* dic = [notification userInfo];
    NSMutableString* url = [[NSMutableString alloc] initWithString:[[AllUrl getInstance] gameInfoUrl]];
    [url appendString:@"?gamepkg="];
    [url appendString:[dic objectForKey:@"pkg"]];
    
    int limit = [[dic objectForKey:@"limit"] intValue];
    int act = [[dic objectForKey:@"act"] intValue];
    switch (act)
    {
        case 1:                     //启动安卓游戏的手柄
        {
            if(limit == 0)          //启动的是sdk游戏， 直接返回
            {
                [url release];
                return;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                GameInfo* gameInfo = [ParseJson createGameInfoFromJson:url];
                if(gameInfo != nil)
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        MouseControlViewController* mouseControlVC = [[MouseControlViewController alloc] initWithNibName:@"MouseControlViewController" bundle:nil];
                        mouseControlVC.currentGameInfo = gameInfo;
                        [self.navigationController presentViewController:mouseControlVC animated:NO completion:nil];
                        [mouseControlVC release];
                    });
                }
            });
            break;
        }
        case 2:                     //启动红白机游戏的手柄
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                HongbaijiViewController* hongbaiVc = [[HongbaijiViewController alloc] initWithNibName:@"HongbaijiViewController" bundle:nil];
                hongbaiVc.gameParam = limit;
                [self.navigationController presentViewController:hongbaiVc animated:NO completion:nil];
                [hongbaiVc release];
            });
            break;
        }
        case 3:                     //启动接机游戏的手柄
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                JiejiViewController* jiejiVc = [[JiejiViewController alloc] initWithNibName:@"JiejiViewController" bundle:nil];
                [self.navigationController presentViewController:jiejiVc animated:NO completion:nil];
                [jiejiVc release];
            });
            break;
        }
        case 4:
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                PSPViewController* pspVc = [[PSPViewController alloc] initWithNibName:@"PSPViewController" bundle:nil];
                [self.navigationController presentViewController:pspVc animated:NO completion:nil];
                [pspVc release];
            });
            break;
        }
        default:
            break;
    }
    [url release];
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

@end
