//
//  SettingView.h
//  NewTvuoo
//
//  Created by xubo on 11/12 Wednesday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExitHandle <NSObject>

@optional
- (void) exitGame;
@end



@interface SettingView : UIView
{
    NSNumber* _voiceFlag;       //0表示关闭
    NSNumber* _validateFlag;
}
@property (retain, nonatomic) id<ExitHandle> exitDelegate;

@end


