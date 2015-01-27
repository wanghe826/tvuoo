//
//  ILSMLAlertView.h
//  MoreLikers
//
//  Created by xiekw on 13-9-9.
//  Copyright (c) 2013年 周和生. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageLoader/EGOImageView.h"

@interface DXAlertView : UIView
{
    UILabel* _gameLabel;
}

- (id)initWithTitle:(NSString *)title
        contentImageUrl:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;

- (void)show;
- (void)setImageUrl:(NSString*)url;
- (void)setGameLabel:(NSString*)gameName;
@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end