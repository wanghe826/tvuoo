//
//  ReturnBtn.h
//  NewTvuoo
//
//  Created by xubo on 9/15 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnBtn: UIButton
@end


@interface SearchBtn: UIButton
@end

@interface AndroidGameButton : UIButton

@property (retain, nonatomic) UIImage* imageUp;
@property (retain, nonatomic) UIImage* imageDown;

@end

@interface MyImageView : UIImageView
@property (retain, nonatomic) UIImage* downImage;
@property (retain, nonatomic) UIImage* upImage;
@property (assign, nonatomic) int keyCode;
@property (assign, nonatomic) int gameType;
@property (assign, nonatomic) BOOL flag;        //YES 按下    NO 抬起
@end

@interface KeyBtn : UIButton
{
    UILabel* _title;
}

- (void) setText: (NSString*)title;
- (UILabel*) text;

@end