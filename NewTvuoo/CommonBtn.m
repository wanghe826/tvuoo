//
//  ReturnBtn.m
//  NewTvuoo
//
//  Created by xubo on 9/15 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//
#import "CommonBtn.h"
#import "domain/MyJniTransport.h"
#import "Singleton.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DEFINE.h"
static SystemSoundID shake_sound_male_id = 0;

@implementation ReturnBtn
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"ty_fanhui1.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"ty_fanhui2.png"] forState:UIControlStateHighlighted];
       [self.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldItalicMT" size:14]];
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end


@implementation SearchBtn
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundImage:[UIImage imageNamed:@"ty_bangzhu1.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"ty_bangzhu2.png"] forState:UIControlStateHighlighted];
    }
    return self;
}

@end

@implementation AndroidGameButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}
@end

@implementation MyImageView
@synthesize downImage;
@synthesize upImage;
@synthesize keyCode;
@synthesize flag;
@synthesize gameType;

- (id) initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if(self)
    {
        self.userInteractionEnabled = YES;
        self.flag = NO;
    }
    return self;
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.image = self.downImage;
    self.flag = YES;
    if([[Singleton getSingle].isVoiceOn intValue] == 1)
    {
        [self playSound];
    }
    if([[Singleton getSingle].isValidateOn intValue] == 1)
    {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
    switch (self.gameType)
    {
        case 1245:
            //左上
            sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 0, 0x0010);
            sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 0, 0x0080);
            break;
        case 1246:
            //右上
            sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 0, 0x0010);
            sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 0, 0x0020);
            break;
        case 1247:
            //左下
            sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 0, 0x0080);
            sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 0, 0x0040);
            break;
        case 1248:
            //右下
            sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 0, 0x0020);
            sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 0, 0x0040);
            break;
        default:
            sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, self.gameType, 0, self.keyCode);
            break;
    }
    
}
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    if(CGRectContainsPoint(self.frame, currentPoint))
    {
    }
    else
    {
    }
    if(self.flag == YES)
    {
        return;
    }
    else
    {
        self.image = self.downImage;
        sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, self.gameType, 0, self.keyCode);
        self.flag = YES;
    }
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.flag == YES)
    {
        self.image = self.upImage;
        switch (self.gameType)
        {
            case 1245:
                //左上
                sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 1, 0x0010);
                sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 1, 0x0080);
                break;
            case 1246:
                //右上
                sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 1, 0x0010);
                sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 1, 0x0020);
                break;
            case 1247:
                //左下
                sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 1, 0x0080);
                sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 1, 0x0040);
                break;
            case 1248:
                //右下
                sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 1, 0x0020);
                sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 4, 1, 0x0040);
                break;
            default:
                sendSimulator([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, self.gameType, 1, self.keyCode);
                break;
        }
        self.flag = NO;
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void) playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"btn" ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);//如果无法再下面播放，可以尝试在此播放
    }
    
    AudioServicesPlaySystemSound(shake_sound_male_id);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    //    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

- (void) dealloc
{
    self.downImage = nil;
    self.upImage = nil;
    [super dealloc];
}

@end


@implementation KeyBtn


- (id) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(12, 3, 30, 30)];
//        _title.center = self.center;
        _title.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
        [_title setFont:[UIFont fontWithName: @"Helvetica" size:20.0]];
        [self addSubview:_title];
        
        [self.layer setBorderWidth:1.0];
        [self.layer setCornerRadius:8.0];
        [self.layer setBorderColor:[[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] CGColor]];
        
    }
    return self;
}

- (void) setText: (NSString*)title
{
    _title.text = title;
}

- (UILabel*) text
{
    return _title;
}
- (void) dealloc
{
    [_title release];
    [super dealloc];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _title.textColor = blueColor;
    self.layer.borderColor = [blueColor CGColor];
    if([_title.text isEqualToString:@"0"] || [_title.text isEqualToString:@"1"] || [_title.text isEqualToString:@"2"] || [_title.text isEqualToString:@"3"] || [_title.text isEqualToString:@"4"] || [_title.text isEqualToString:@"5"] || [_title.text isEqualToString:@"6"] || [_title.text isEqualToString:@"7"] || [_title.text isEqualToString:@"8"] || [_title.text isEqualToString:@"9"])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, [self.titleLabel.text intValue] + 7, 0);
//        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, [self.titleLabel.text intValue] + 7, 0);
    }
    else if([_title.text isEqualToString:@","])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 55, 0);
//        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, , 0);
    }
    else if([_title.text isEqualToString:@"."])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 56, 0);
        //        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, , 0);
    }
    else if([_title.text isEqualToString:@"/"])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 76, 0);
    }
    else if ([_title.text isEqualToString:@"!"])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 59, 0);
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 8, 0);
    }
    else if([_title.text isEqualToString:@"@"])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 77, 0);
    }
    else if([_title.text isEqualToString:@"#"])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 18, 0);
    }
    else if([_title.text isEqualToString:@"("])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 162, 0);
    }
    else if([_title.text isEqualToString:@")"])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 163, 0);
    }
    else if([_title.text isEqualToString:@"*"])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 17, 0);
    }
    else if([_title.text isEqualToString:@":"])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 59, 0);
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 74, 0);
    }
    else if([_title.text isEqualToString:@"_"])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 59, 0);
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 69, 0);
    }
    else if([_title.text isEqualToString:@"&"])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 59, 0);
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, 14, 0);
    }
    else
    {
        NSString* text = [_title text];
        int code = [text characterAtIndex:0];
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 0, code+37, 0);
//        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, code+37, 0);
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _title.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] CGColor];
    
    if([_title.text isEqualToString:@"0"] || [_title.text isEqualToString:@"1"] || [_title.text isEqualToString:@"2"] || [_title.text isEqualToString:@"3"] || [_title.text isEqualToString:@"4"] || [_title.text isEqualToString:@"5"] || [_title.text isEqualToString:@"6"] || [_title.text isEqualToString:@"7"] || [_title.text isEqualToString:@"8"] || [_title.text isEqualToString:@"9"])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, [self.titleLabel.text intValue] + 7, 0);
    }
    else if([_title.text isEqualToString:@","])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 55, 0);
    }
    else if([_title.text isEqualToString:@"."])
    {
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, 56, 0);
    }
    else
    {
        NSString* text = [_title text];
        int code = [text characterAtIndex:0];
        keyEvent([Singleton getSingle].current_tv.tvIp, [Singleton getSingle].current_tv.tvServerport, 1, code+37, 0);
    }
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _title.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1];
    self.layer.borderColor = [[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1] CGColor];
}

@end