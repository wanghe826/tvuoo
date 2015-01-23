//
//  SettingView.m
//  NewTvuoo
//
//  Created by xubo on 11/12 Wednesday.
//  Copyright (c) 2014 wap3. All rights reserved.
//
#import "domain/MyJniTransport.h"
#import "SettingView.h"
#import "Singleton.h"
#define blueColor [UIColor colorWithRed:24.0/255.0 green:180.0/255.0 blue:237.0/255.0 alpha:1]

@implementation SettingView
@synthesize exitDelegate;

- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self fetchFlag];
        self.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:28.0/2550. blue:30.2/255.0 alpha:1];
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        titleLabel.text = @"手机无线手柄设置";
        [titleLabel sizeToFit];
        titleLabel.textColor = blueColor;
        titleLabel.center = CGPointMake(self.center.x, 30);
        [self addSubview:titleLabel];
        [titleLabel release];
        
        UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 1)];
//        line.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:15.0/255.0 blue:19.0/255.0 alpha:1];
        line.backgroundColor = [UIColor whiteColor];
        line.center = CGPointMake(self.center.x, titleLabel.center.y+30);
        [self addSubview:line];
//        [line release];
        
        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(line.frame.origin.x, line.frame.origin.y+40, 100, 30)];
        label1.text = @"游戏按键声音";
        label1.font = [UIFont fontWithName:@"Courier New" size:15];
        [label1 sizeToFit];
        label1.textColor = [UIColor whiteColor];
        [self addSubview:label1];
//        [label1 release];
        [line release];
        
        UIImageView* line2 = [[UIImageView alloc] initWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y+25, 100, 0.5)];
        //        line.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:15.0/255.0 blue:19.0/255.0 alpha:1];
        line2.backgroundColor = [UIColor whiteColor];
//        line2.center = CGPointMake(self.center.x, label1.center.y+20);
        [self addSubview:line2];
        [line2 release];
        
        UISegmentedControl* segementBtn = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"打开",@"关闭", nil]];
        segementBtn.tag = 1;
        if([_voiceFlag intValue]==0)
        {
            segementBtn.selectedSegmentIndex = 1;//关闭
        }
        else
        {
            segementBtn.selectedSegmentIndex = 0;
        }
        [segementBtn addTarget:self action:@selector(segementBtnPress:) forControlEvents:UIControlEventValueChanged];
        segementBtn.frame = CGRectMake(label1.center.x+70, label1.frame.origin.y, 70, 30);
        segementBtn.center = CGPointMake(label1.center.x+100, label1.center.y);
        [self addSubview:segementBtn];
        
        
        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y+55, 100, 30)];
        label2.text = @"游戏按键震动";
        label2.font = [UIFont fontWithName:@"Courier New" size:15];
        [label2 sizeToFit];
        label2.textColor = [UIColor whiteColor];
        [self addSubview:label2];
//        [label2 release];
        [label1 release];
        
        UIImageView* line3 = [[UIImageView alloc] initWithFrame:CGRectMake(label2.frame.origin.x, label2.frame.origin.y+25, 100, 0.5)];
        //        line.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:15.0/255.0 blue:19.0/255.0 alpha:1];
        line3.backgroundColor = [UIColor whiteColor];
//        line3.center = CGPointMake(self.center.x, label2.center.y+20);
        [self addSubview:line3];
        [line3 release];
        
        UISegmentedControl* segementBtn2 = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"打开",@"关闭", nil]];
        if([_validateFlag intValue]==0)
        {
            segementBtn2.selectedSegmentIndex = 1;//关闭
        }
        else
        {
            segementBtn2.selectedSegmentIndex = 0;
        }
        segementBtn2.tag = 2;
        [segementBtn2 addTarget:self action:@selector(segementBtnPress:) forControlEvents:UIControlEventValueChanged];
        segementBtn2.frame = CGRectMake(label2.center.x+70, label2.frame.origin.y, 70, 30);
        segementBtn2.center = CGPointMake(label2.center.x+100, label2.center.y);
        [self addSubview:segementBtn2];
        
        UILabel* label3 = [[UILabel alloc] initWithFrame:CGRectMake(label2.frame.origin.x, label2.frame.origin.y+55, 100, 30)];
        label3.text = @"系统音量控制";
        label3.font = [UIFont fontWithName:@"Courier New" size:15];
        [label3 sizeToFit];
        label3.textColor = [UIColor whiteColor];
        [self addSubview:label3];
//        [label3 release];
        [label2 release];
        UIImageView* line4 = [[UIImageView alloc] initWithFrame:CGRectMake(label3.frame.origin.x, label3.frame.origin.y+25, 100, 0.5)];
        //        line.backgroundColor = [UIColor colorWithRed:14.0/255.0 green:15.0/255.0 blue:19.0/255.0 alpha:1];
        line4.backgroundColor = [UIColor whiteColor];
//        line4.center = CGPointMake(self.center.x, label3.center.y+20);
        [self addSubview:line4];
        [line4 release];
        
        
//        UISegmentedControl* segementBtn3 = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"减小",@"加大", nil]];
//        segementBtn3.tag = 3;
//        [segementBtn3 addTarget:self action:@selector(segementBtnPress:) forControlEvents:UIControlEventValueChanged];
//        segementBtn3.frame = CGRectMake(label3.center.x+70, label3.frame.origin.y, 70, 30);
//        segementBtn3.center = CGPointMake(label3.center.x+100, label3.center.y);
//        [self addSubview:segementBtn3];
//        [label3 release];
        
        UIButton* lowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        lowerBtn.frame = CGRectMake(label3.center.x+65, label3.frame.origin.y, 35, 30);
        lowerBtn.layer.borderColor = [blueColor CGColor];
        lowerBtn.layer.borderWidth = 1.5;
        lowerBtn.layer.cornerRadius = 4.0;
        lowerBtn.center = CGPointMake(label3.center.x+82.5, label3.center.y);
        [lowerBtn setTitle:@"减小" forState:UIControlStateNormal];
        [lowerBtn.titleLabel setFont:[UIFont fontWithName:@"Courier New" size:10]];
        [lowerBtn setTitleColor:[UIColor redColor] forState:UIControlEventTouchDown];
        [lowerBtn addTarget:self action:@selector(lowerVoice) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:lowerBtn];
        
        UIButton* upperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upperBtn.frame = CGRectMake(label3.center.x+65, label3.frame.origin.y, 35, 30);
        upperBtn.layer.borderColor = [blueColor CGColor];
        upperBtn.layer.borderWidth = 1.5;
        upperBtn.layer.cornerRadius = 4.0;
        upperBtn.center = CGPointMake(label3.center.x+122.5, label3.center.y);
        [upperBtn setTitle:@"增大" forState:UIControlStateNormal];
        [upperBtn.titleLabel setFont:[UIFont fontWithName:@"Courier New" size:10]];
        [upperBtn setTitleColor:[UIColor redColor] forState:UIControlEventTouchDown];
        [upperBtn addTarget:self action:@selector(upperVoice) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:upperBtn];
        
        UIButton* doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn addTarget:self action:@selector(downBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [doneBtn addTarget:self action:@selector(downBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn.layer setBorderWidth:1];
        [doneBtn.layer setCornerRadius:8.0];
        [doneBtn.layer setBorderColor:[blueColor CGColor]];
        doneBtn.frame = CGRectMake(10, 270, 80, 30);
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setTitleColor:blueColor forState:UIControlStateNormal];
        [self addSubview:doneBtn];
        
        UIButton* exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [exitBtn addTarget:self action:@selector(exitBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
        [exitBtn addTarget:self action:@selector(exitBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [exitBtn.layer setBorderWidth:1];
        [exitBtn.layer setCornerRadius:8.0];
        [exitBtn.layer setBorderColor:[blueColor CGColor]];
        exitBtn.frame = CGRectMake(110, 270, 80, 30);
        [exitBtn setTitle:@"退出手柄" forState:UIControlStateNormal];
        [exitBtn setTitleColor:blueColor forState:UIControlStateNormal];
        [self addSubview:exitBtn];
        
        
    }
    return self;
}

- (void) downBtnTouchDown:(UIButton*)sender
{
    [sender.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
}
- (void) downBtnTouchUpInside:(UIButton*)sender
{
    [sender.layer setBackgroundColor:[[UIColor blackColor] CGColor]];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_voiceFlag forKey:@"voiceFlag"];
    [defaults setObject:_validateFlag forKey:@"validateFlag"];
    [defaults synchronize];
    [self removeFromSuperview];
}

- (void)exitBtnTouchDown:(UIButton*)sender
{
    [sender.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
}
- (void)exitBtnTouchUpInside:(UIButton*)sender
{
    [sender.layer setBackgroundColor:[[UIColor blackColor] CGColor]];
//    [self removeFromSuperview];
    if(exitDelegate != nil)
    {
        if([exitDelegate respondsToSelector:@selector(exitGame)])
        {
            [exitDelegate exitGame];
        }
    }
}

- (void) lowerVoice
{
    NSLog(@"音量减小");
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 25, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 25, 0);
}

- (void) upperVoice
{
    NSLog(@"音量加大");
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 24, 0);
    keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 24, 0);
}

- (void) segementBtnPress: (UISegmentedControl*)segment
{
    switch(segment.tag)
    {
            case 1:
                if(segment.selectedSegmentIndex == 0)
                {
                    NSLog(@"打开");
                    _voiceFlag = [NSNumber numberWithInt:1];
                    [Singleton getSingle].isVoiceOn = [NSNumber numberWithInt:1];
                }
                else
                {
                    NSLog(@"关闭");
                    _voiceFlag = [NSNumber numberWithInt:0];
                    [Singleton getSingle].isVoiceOn = [NSNumber numberWithInt:0];
                }
                break;
            case 2:
                if(segment.selectedSegmentIndex == 0)
                {
                    NSLog(@"打开");
                    _validateFlag = [NSNumber numberWithInt:1];
                    [Singleton getSingle].isValidateOn = [NSNumber numberWithInt:1];
                }
                else
                {
                    NSLog(@"关闭");
                    _validateFlag = [NSNumber numberWithInt:0];
                    [Singleton getSingle].isValidateOn = [NSNumber numberWithInt:0];
                }
                break;
            default:
                break;
    }
}
- (void) dealloc
{
    [super dealloc];
}

- (void) fetchFlag
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    _voiceFlag = [defaults objectForKey:@"voiceFlag"];
    _validateFlag = [defaults objectForKey:@"validateFlag"];
    
    if(_voiceFlag==nil)
    {
        _voiceFlag = [NSNumber numberWithInt:0];
    }
    if(_validateFlag==nil)
    {
        _validateFlag = [NSNumber numberWithInt:0];
    }
}

@end
